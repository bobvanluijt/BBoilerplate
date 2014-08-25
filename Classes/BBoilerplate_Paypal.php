<?php
//
// Paypal class
//
class BBoilerplate_Paypal {
	
	/*
	 * Sandbox First Call
	 */
	 public function requestAccesstoken(){
			$ch = curl_init();
			$clientId = BBoilerplate::config('PAYPALCLIENTID');
			$secret   = BBoilerplate::config('PAYPALSECRET');
			$access	  = BBoilerplate::config('PAYPALACCESS');
			curl_setopt($ch, CURLOPT_URL, "https://".$access."/v1/oauth2/token");
			curl_setopt($ch, CURLOPT_HEADER, false);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_POST, true);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
			curl_setopt($ch, CURLOPT_USERPWD, $clientId.":".$secret);
			curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=client_credentials");
			$result = curl_exec($ch);
			if(empty($result))die("Error: No Paypal response.");
			else
			{
				$json = json_decode($result);
			}
			curl_close($ch);
			DB::push("INSERT INTO `paypalAccess` (`token`, `expire`) VALUES
				    ('".$json->access_token."', '".(time()+$json->expires_in)."');");
			return $json->access_token;
	 }
	 
	 public function getToken(){
		 //
		 // Gets token but also does a validation
		 //
			$results = DB::pull("SELECT * FROM  `paypalAccess` ORDER BY `id` DESC LIMIT 1");
			foreach($results as $result){
				if(time() > $result['expire']){
					return BBoilerplate_Paypal::requestAccesstoken();
				} else {
					return $result['token'];
				}
			}
			return BBoilerplate_Paypal::requestAccesstoken();
	 }
	 
	 public function addCard($cardType, $cardNumber, $cardExpireMonth, $cardExpireYear, $cardFirstname, $cardLastname) {
		 	$access	  = BBoilerplate::config('PAYPALACCESS');
			$user = BBoilerplate::user();
			$ch = curl_init();
			$data = '{
			 "payer_id":"deegin_'.$user['id'].'",
			 "type":"'.$cardType.'",
			 "number":"'.$cardNumber.'",
			 "expire_month":"'.$cardExpireMonth.'",
			 "expire_year":"'.$cardExpireYear.'",
			 "first_name":"'.$cardFirstname.'",
			 "last_name":"'.$cardLastname.'"
			}';
			curl_setopt($ch, CURLOPT_URL, "https://".$access."/v1/vault/credit-card");
			curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
			curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			  "Content-Type: application/json",
			  "Authorization: Bearer ".BBoilerplate_Paypal::getToken(), 
			  "Content-length: ".strlen($data))
			);
			
			$result = curl_exec($ch);
			if(empty($result))die("Error: No response.");
			else
			{
				$json = json_decode($result);
			}
			curl_close($ch);
			
			if($json->state=='ok'){
				$lastId = DB::push("INSERT INTO `paypalVault` (`cardId`,`payerId`,`validTill`,`lastNumbers`)
							VALUES ('".$json->id."','".$json->payer_id."','".$json->valid_until."','".$json->number."');");
				DB::push("UPDATE `users` SET paypalVault = '".$lastId."' WHERE id = '".$user['id']."' LIMIT 1");
			} else {
				return false;
			}
 			return true;
	 }
	 
	 public function removeCard($user){
		 $cardId = $user['paypalVault'];
		 if(is_numeric($cardId)){
		 	DB::push("DELETE FROM `paypalVault` WHERE `id` = ".$cardId." LIMIT 1");
			DB::push("UPDATE `users` SET paypalVault = 0 WHERE id = '".$user['id']."' LIMIT 1");
			return true;
		 } else {
		 	return false;
		 }
	 }
	 
	 public function doVaultPay($amount, $purchaseId){ //set purchaseId to false if bulk purchase
		 	$access	= BBoilerplate::config('PAYPALACCESS');
		 	$user = BBoilerplate::user();
			$creditCard = DB::pull("SELECT v.cardId AS cardId, v.payerId AS payerId FROM users AS u INNER JOIN paypalVault AS v ON v.id=u.paypalVault WHERE u.id = '".$user['id']."' LIMIT 1;");
			$ch = curl_init();
			
			$data = '{
			  "intent":"sale",
			  "payer":{
				"payment_method":"credit_card",
				"funding_instruments":[
				  {
					"credit_card_token":{
					  "credit_card_id":"'.$creditCard[0]['cardId'].'",
					  "payer_id":"'.$creditCard[0]['payerId'].'"
					}
				  }
				]
			  },
			  "transactions":[
				{
				  "amount":{
					"total":"'.$amount.'",
					"currency":"USD"
				  },
				  "description":"Elsevier Deegin ('.uniqid().')"
				}
			  ]
			}';
			curl_setopt($ch, CURLOPT_URL, "https://".$access."/v1/payments/payment");
			curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
			curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			  "Content-Type: application/json",
			  "Authorization: Bearer ".BBoilerplate_Paypal::getToken(), 
			  "Content-length: ".strlen($data))
			);
			
			$result = curl_exec($ch);
			if(empty($result))die("Error: No response.");
			else
			{
				$json = json_decode($result);
				$ppResult = $result;
			}
			curl_close($ch);
			
			if($json->state=='approved'){
				$lastId = DB::push("INSERT INTO `paypalPayment` (`paypalId`, `createTime`, `amount`, `description`, `saleId`, `return`) VALUES ('".$json->id."', '".$json->create_time."', '".$json->transactions[0]->amount->total."', '".$json->transactions[0]->description."', '".$json->transactions[0]->related_resources[0]->sale->id."', '".$ppResult."');");
				if(substr($purchaseId,0,9)=='buyBulk__'){
					DB::push("INSERT INTO `paypalPayment` (`user`, `bulkArticle`, `time`, `relatedPay`)
								VALUES ('".$user['id']."', '".$purchaseId."', NOW(), '".$lastId."')");
					if($purchaseId=='buyBulk__1'){
						DB::push("UPDATE `users` SET `tokens` = (`tokens`+17500) WHERE id = '".$user['id']."' LIMIT 1");
					} else if($purchaseId=='buyBulk__2'){
						DB::push("UPDATE `users` SET `tokens` = (`tokens`+35000) WHERE id = '".$user['id']."' LIMIT 1");
					} else if($purchaseId=='buyBulk__3'){
						DB::push("UPDATE `users` SET `tokens` = (`tokens`+52500) WHERE id = '".$user['id']."' LIMIT 1");
					} else if($purchaseId=='buyBulk__4'){
						DB::push("UPDATE `users` SET `tokens` = (`tokens`+87500) WHERE id = '".$user['id']."' LIMIT 1");
					}
				} else {
					DB::push("UPDATE `purchases` SET `relatedPay` = '".$lastId."' WHERE `id` = '".$purchaseId."' AND user = '".$user['id']."' LIMIT 1");
				}
				
				$title = DB::pull("SELECT `title` FROM `purchases` WHERE `id` = '".$purchaseId."' LIMIT 1");
				$vars['title'] = $title[0]['title'];
				$messager = BBoilerplate_Mail::template('purhchase_confirmation', $vars);
				if($user['contactEmail']!=''){
					$user['email'] = $user['contactEmail'];
				}
				BBoilerplate_Mail::send($user['firstname'].' '.$user['lastname'], $user['email'], $messager['subject'], $messager['message']);
				return true;	
			} else {
				return false;	
			}
	 }
	 
	 public function orderInfo($i){
		 	$access	= BBoilerplate::config('PAYPALACCESS');
		 	$user = BBoilerplate::user();
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, "https://".$access."/v1/payments/sale/".$i);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
			curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			  "Content-Type: application/json",
			  "Authorization: Bearer ".BBoilerplate_Paypal::getToken())
			);
			
			$result = curl_exec($ch);
			if(empty($result))die("Error: No response.");
			else
			{
				$json = json_decode($result);
				$ppResult = $result;
			}
			
			var_dump($json);
			
			curl_close($ch);
			
	 }
	 
	 /*
	  **
	  *** ALL PAYMENTS SET TO PAYPAL REQUESTS 
	  **
	  */
	  
	  public function getConsent(){
		  	$access	= BBoilerplate::config('PAYPALREDIR');
			header('Location: '."https://".$access."/webapps/auth/protocol/openidconnect/v1/authorize?client_id=".self::CLIENTID."&response_type=code&scope=profile+email+address+phone+https%3A%2F%2Furi.paypal.com%2Fservices%2Fpaypalattributes&redirect_uri=https://read.deeg.in/paypalReturn",true,302);
			exit;
	  }
	  
	  public function setConsent($i){
		  	$user = BBoilerplate::user();
			DB::push("UPDATE users SET paypalToken = '".$i."', paypalVault = 0 WHERE id = '".$user['id']."' LIMIT 1");
			return true;
	  }
	 
}