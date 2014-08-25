<?php
//
// Paypal class
//
class BBoilerplate_Pricing {
	
	public function VAT($Pii){
		//
		// Calculates VAT for user for single PII
		// returns false if no VAT
		//
		$user = BBoilerplate::user();
		$results = DB::pull("SELECT taxState FROM `countries` WHERE `code` = '".$user['country']."' LIMIT 1");
		if($results[0]['taxState']=='0%'){
			return false;
		} else {
			$VAT = array();
			$VAT['excluding'] 	= number_format(BBoilerplate_Pricing::getPrice($Pii), 2);
			$VAT['including'] 	= number_format(round(BBoilerplate_Pricing::getPrice($Pii)*((intval($results[0]['taxState'])/100)+1), 2), 2);
			$VAT['VAT'] 		= number_format(round(BBoilerplate_Pricing::getPrice($Pii)*((intval($results[0]['taxState'])/100)), 2), 2);
			$VAT['VAT_rate'] 	= $results[0]['taxState'];
			$VAT['rent']['excluding'] = '5.00';
			$VAT['rent']['including'] = number_format(round(5*((intval($results[0]['taxState'])/100)+1), 2), 2);
			$VAT['rent']['VAT']		  = number_format(round(5*((intval($results[0]['taxState'])/100)), 2), 2);
			return $VAT;
		}
	}
	
	public function getPrice($Pii){
		//
		// search for price, if not found get from ScienceDirect
		//
		$prices = DB::pull("SELECT `usd` FROM `prices` WHERE `pii` = '".$Pii."' LIMIT 1");
		if(count($prices)==0){
			$Price = BBoilerplate_SD::scrapePrice($Pii);
			$Price = BBoilerplate_Pricing::setPrice($Pii, $Price, 'usd');
			return $Price;
		} else {
			foreach($prices	as $price){
				return $price['usd'];	
			}
		}
	}
	
	public function setPrice($Pii, $v, $Type){
		if($v==''||$v==0){
			//setToStandard of 31.50 if not available
			if(BBoilerplate_Auth::validateOpenaccess($Pii)===true){
				$v = '0.00';
			} else {
				$v = '31.50';	
			}
			DB::push("INSERT INTO `prices` (`date`, `pii`, `usd`) VALUES (NOW(), '".$Pii."', '".$v."');");
			return $v;
		} else {
			DB::push("INSERT INTO `prices` (`date`, `pii`, `usd`) VALUES (NOW(), '".$Pii."', '".$v."');");
			return $v;
		}
	}
	
}