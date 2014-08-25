<?php
//
// ScienceDirect class, scraping things from SD
//
class BBoilerplate_SD {
	
	public function scrapePrice($Pii){
		$url="http://www.sciencedirect.com/science/article/pii/".$Pii;
		$agent= 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)';
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_VERBOSE, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_USERAGENT, $agent);
		curl_setopt($ch, CURLOPT_URL,$url);
		$result=curl_exec($ch);
		$pos = strpos($result, '/science?_ob=ShoppingCartURL&_method=add&');
		if(!$pos){
			return '0';
		}
		
		$returner = 'http://www.sciencedirect.com';
		while($substr!='"'){
			$returner = $returner.$substr;
			$substr = substr($result, $pos++, 1);
		}
		//
		//next page
		//
		$url=$returner;
		$agent= 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)';
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_VERBOSE, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_USERAGENT, $agent);
		curl_setopt($ch, CURLOPT_URL,$url);
		$result=curl_exec($ch);
		$pos = strpos($result, 'cartRsltPriceSpacer">');

		$pos = $pos+22; //+cartRsltPriceSpacer"> positions
		
		$returner = "";
		while($substr!='<'){
			$returner = $returner.$substr;
			$substr = substr($result, $pos++, 1);
		}

		return substr($returner, 1);
	}
	
}