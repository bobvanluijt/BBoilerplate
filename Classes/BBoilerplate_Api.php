<?php
class BBoilerplate_Api {
	
	public function cleanup($xmlLocation){
		//
		//Cleanup the xml
		//	
		$xml = file_get_contents($xmlLocation);
		$xml = str_replace("converted-article","article",$xml);
		$xml = str_replace("simple-article","article",$xml);
			   file_put_contents($xmlLocation, $xml);
	}
	
	/*
	 * Returns the location where a abstract should be
	 */
	public function abstractLocation($Pii){
		$pos = strpos($Pii, '_abstract');
		if($pos===false){
			$Pii = BBoilerplate::makeMd5Salt($Pii);
		} else {
			$Pii = BBoilerplate::makeMd5Salt($Pii).'_abstract';
		}
		$step1 = substr($Pii, 0, 1);
		$step2 = substr($Pii, 1, 1);
		$step3 = substr($Pii, 2, 1);
		if(!is_dir('./Cache/Xml/'.$step1)){
			mkdir('./Cache/Xml/'.$step1);
			chmod('./Cache/Xml/'.$step1, 0777); 
		}
		if(!is_dir('./Cache/Xml/'.$step1.'/'.$step2)){
			mkdir('./Cache/Xml/'.$step1.'/'.$step2);
			chmod('./Cache/Xml/'.$step1.'/'.$step2.$step1, 0777); 
		}
		if(!is_dir('./Cache/Xml/'.$step1.'/'.$step2.'/'.$step3)){
			mkdir('./Cache/Xml/'.$step1.'/'.$step2.'/'.$step3);
			chmod('./Cache/Xml/'.$step1.'/'.$step2.'/'.$step3, 0777); 
		}
		$location = './Cache/Xml/'.$step1.'/'.$step2.'/'.$step3.'/'.$Pii.'.xml';
		return $location;
	}
	
	/*
	 * Search for a word or set of words, add the $query and the $count (max 500)
	 */
	public function search($query, $count, $header){
		$query = str_replace(" ", "+", $query);
		if($header===true){
			header("Content-type: text/xml");
		}
		if($count > 500) $count = 500;
		$curl = curl_init();
		curl_setopt_array($curl, array(
			CURLOPT_RETURNTRANSFER => 1,
			CURLOPT_URL => 'http://api.elsevier.com/content/search/index:SCIDIR?query='.$query.'&view=COMPLETE&sort=-date&count='.$count
		));
		curl_setopt($curl, CURLOPT_HTTPHEADER, array(
			'X-ELS-APIKey: '.BBoilerplate::config('elsevierAPI'),
			'Accept: text/xml, application/atom+xml'
		));
		$result = curl_exec($curl);
		curl_close($curl);
		return $result;
	}
	
	/*
	 * Download as PDF
	 */
	 public function pdf($Pii){
		//header('Content-type: application/pdf');
		$curl = curl_init();
		curl_setopt_array($curl, array(
			CURLOPT_RETURNTRANSFER => 1,
			CURLOPT_URL => 'http://api.elsevier.com/content/article/PII:'.$Pii.'?view=PDF'
		));
		curl_setopt($curl, CURLOPT_HTTPHEADER, array(
			'X-ELS-APIKey: '.BBoilerplate::config('elsevierAPI'),
			'application/pdf'
		));
		$result = curl_exec($curl);
		curl_close($curl);
		$fp = fopen('./Cache/'.md5($Pii).'.pdf', 'w');
		fwrite($fp, $result);
		fclose($fp);
		return $result;
	 }
	
	/*
	 * Request an article ABSTRACT, $Pii
	 * $Type PDF forces a PDF header
	 */
	public function articleAbstract($Pii){
		$curl = curl_init();
		
		curl_setopt_array($curl, array(
			CURLOPT_RETURNTRANSFER => 1,
			CURLOPT_URL => 'http://api.elsevier.com/content/article/PII:'.$Pii.'?view=META_ABS'
		));
		curl_setopt($curl, CURLOPT_HTTPHEADER, array(
			'X-ELS-APIKey: '.BBoilerplate::config('elsevierAPI'),
			'Accept: text/xml, application/atom+xml'
		));
		$result = curl_exec($curl);
		curl_close($curl);
		return $result;
	}
	
	/*
	 * Render an article object (like: title)
	 */
	function renderAbstractObject($Pii, $Object){
		$user = BBoilerplate::user();	
		$xmlLocation = BBoilerplate_Api::abstractLocation($Pii.'_abstract');
		if (file_exists($xmlLocation)) {
			$abstract = file_get_contents($xmlLocation);
		} else {
			$abstract = BBoilerplate_Api::articleAbstract($Pii);
			$fp = fopen($xmlLocation, 'w');
			fwrite($fp, $abstract);
			fclose($fp);
		}
		$xml = simplexml_load_string($abstract);
   	 	$xml->getNamespaces(true);
		$remove = array("Summary", "Abstract"); //remove from desc output
		return $desc = $xml->coredata->children('dc', true)->$Object;
	}
	
	/*
	 * Render an article ABSTRACT (if $renderHtml = 0, no html)
	 */
	function renderAbstract($Pii, $renderHtml = 1){
		$user = BBoilerplate::user();	
		$xmlLocation = BBoilerplate_Api::abstractLocation($Pii.'_abstract');
		if (file_exists($xmlLocation)) {
			$abstract = file_get_contents($xmlLocation);
		} else {
			$abstract = BBoilerplate_Api::articleAbstract($Pii);
			$fp = fopen($xmlLocation, 'w');
			fwrite($fp, $abstract);
			fclose($fp);
		}
		$xml = simplexml_load_string($abstract);
   	 	$xml->getNamespaces(true);
		$remove = array("Summary", "Abstract"); //remove from desc output
		if($renderHtml==0){
			$desc = $xml->coredata->children('dc', true)->description;
			$desc = str_replace($remove, "", $desc);
			return $desc;
		} else {
			//
			//render HTML for output and buy options
			//
			if($Pii==''){
				$html = file_get_contents('./Lib/Phtml/noPage.phtml');
				return $html;
			} else {
				$html = file_get_contents('./Lib/Phtml/abstract.phtml');
				$html = str_replace("[[Pii]]"			, $Pii, $html);
				if(BBoilerplate_Pricing::VAT($Pii)!==false){
					$html = str_replace("[[VAT]]", '<span style="font-size:10px">* All prices without VAT.</span>', $html);
				} else {
					$html = str_replace("[[VAT]]", '<!--NO VAT-->', $html);
				}
				$html = str_replace("[[title]]"			, $xml->coredata->children('dc', true)->title, $html);
				$html = str_replace("[[name]]"			, $xml->coredata->children('dc', true)->creator, $html);
				$desc = $xml->coredata->children('dc', true)->description;
				$desc = str_replace($remove, "", $desc);
				$html = str_replace("[[description]]"	, $desc, $html);
				if($user['paypalVault']==0){
					$html = str_replace("[[DisplayBuy]]"	, 'display:none;', $html);
					$html = str_replace("[[DisplaySetup]]"	, 'display:block;', $html);
				} else {
					$html = str_replace("[[DisplayBuy]]"	, 'display:block;', $html);
					$html = str_replace("[[DisplaySetup]]"	, 'display:none;', $html);				
				}
				return $html;
			}
		}
	}
	
	/*
	 * Request an article, $Pii, $Type = FULL, PDF, REF or PDF, $Header sends as XML or PDF
	 * $Type PDF forces a PDF header
	 */
	public function article($Pii, $Type, $Header){	
		//
		// request article
		// Type can be: META, META_ABS, META_ABS_REF, REF, FULL, PDF
		//
		$Type = strtoupper($Type);
		if($Header===true){
			if($Type==='PDF' || $Type=='PDF'){
				header('Content-type: application/pdf');
			} else {
				header("Content-type: text/xml");
			}
		}
		$xmlLocation = BBoilerplate_Api::abstractLocation($Pii);
		if (file_exists($xmlLocation)) {
			return file_get_contents($xmlLocation);
		} else {
			$curl = curl_init();
			curl_setopt_array($curl, array(
				CURLOPT_RETURNTRANSFER => 1,
				CURLOPT_URL => 'http://api.elsevier.com/content/article/PII:'.$Pii.'?view='.$Type
			));
			curl_setopt($curl, CURLOPT_HTTPHEADER, array(
				'X-ELS-APIKey: '.BBoilerplate::config('elsevierAPI'),
				'Accept: text/xml, application/atom+xml'
			));
			$result = curl_exec($curl);
			curl_close($curl);
			$fp = fopen($xmlLocation, 'w');
			fwrite($fp, $result);
			fclose($fp);
			BBoilerplate_Api::cleanup($xmlLocation);
			return $result;
		}
	}
	
	/*
	 * check if openaccess
	 */
	function openaccess($Pii){
		$xmlLocation = BBoilerplate_Api::abstractLocation($Pii.'_abstract');
		$xml = simplexml_load_file($xmlLocation);
		if($xml->coredata->openaccess==0){
			return false;
		} else {
			return true;
		}
	}
}