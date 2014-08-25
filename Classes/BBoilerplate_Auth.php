<?php
//
// Validation of users
//
class BBoilerplate_Auth {
	/*
	 * Validate if openaccess is allowed (true or false)
	 */
	public function validateOpenaccess($Pii){
		$xmlLocation = BBoilerplate_Api::abstractLocation($Pii);
		$xml = simplexml_load_file($xmlLocation);
   	 	$validate = $xml->coredata->openaccess;
		if($validate==1){
			return true;
		} else {
			return false;	
		}
	}
	
	/*
	 * Validates if a user owns an article
	 */
	public function validatePurchase($Pii){
		 DB::connect();
		 $user = BBoilerplate::user();
		 $results = DB::pull("SELECT id FROM purchases WHERE pii = '".$Pii."' AND user = '".$user['id']."' AND time >= NOW() LIMIT 1");
		 if(count($results)>0){
			return true; 
		 } else {
			return false; 
		 }
	}
	
	/*
	 * Validates if a user owns a note
	 */
	public function validateNote($Pii){
		 DB::connect();
		 $user = BBoilerplate::user();
		 $results = DB::pull("SELECT id FROM purchases WHERE pii = '".$Pii."' AND user = '".$user['id']."' AND time >= NOW() LIMIT 1");
		 if(count($results)>0){
			return true; 
		 } else {
			return false; 
		 }
	}
	
	/*
	 * Do an actual purchase
	 */
	public function doPurchase($type, $Pii){
		DB::connect();
		$user = BBoilerplate::user();	
		$VAT = BBoilerplate_Pricing::VAT($Pii);
		
		$PiiPrice = (BBoilerplate_Pricing::getPrice($Pii)*100);
		
		if($VAT!==false){
			$PiiPrice = round($PiiPrice*((intval($VAT['VAT_rate'])/100)+1));
		}
		
		if($type=='try'){
			return 'error'; //place an error, not allowed
			$Date = date("Y-m-d H:i:s", mktime(date("H")+1, date("i"), date("s"), date("m")  , date("d"), date("Y")));
		} else if($type=='rent'){
			$Date = date("Y-m-d H:i:s", mktime(date("H"), date("i"), date("s"), date("m")  , date("d")+7, date("Y")));
			if($VAT!==false){
				$tokenCheck = $user['tokens'] - round(500*((intval($VAT['VAT_rate'])/100)+1));
				$tokensNeeded = round(500*((intval($VAT['VAT_rate'])/100)+1)) - $user['tokens']; //only used if not enough
			} else {
				$tokenCheck = $user['tokens'] - 500;
				$tokensNeeded = 500 - $user['tokens']; //only used if not enough
			}
		} else if($type=='buy'){
			$Date = "9999-12-31 23:59:59";
			$tokenCheck = $user['tokens'] - $PiiPrice;
			$tokensNeeded = $PiiPrice - $user['tokens']; //only used if not enough
		} else {
			return 'false';	
		}
		
		$xmlLocation = BBoilerplate_Api::abstractLocation($Pii);
		$xml = simplexml_load_file($xmlLocation);
   	 	$xml->getNamespaces(true);
		
		$desc = $xml->coredata->children('dc', true)->description;
		$desc = str_replace("'", '"', $desc);
		$replaces = array("Summary", "Abstract");
		$desc = str_replace($replaces, "", $desc);

		$newId = DB::push("INSERT INTO `purchases` (`user`, `pii`, `title`, `time`, `desc`) VALUES ('".$user['id']."', '".$Pii."', '".$xml->coredata->children('dc', true)->title."','".$Date."', '".$desc."');");
		
		if($tokenCheck < 0){
			$returner = BBoilerplate_Paypal::doVaultPay(number_format(($tokensNeeded/100), 2), $newId);
			if($returner!==true){
				DB::push("DELETE FROM `purchases` WHERE `id` = ".$newId);	
			}
			DB::push("UPDATE `users` SET `tokens` = '0' WHERE `id` = '".$user['id']."';");	
		} else {
			DB::push("UPDATE `users` SET `tokens` = '".$tokenCheck."' WHERE `id` = '".$user['id']."';");	
		}
		
		if(isset($tokensNeeded)){
			return 'true['.$tokensNeeded.']';
		} else {
			return 'true';	
		}
	}
	
}