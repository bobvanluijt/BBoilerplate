<?php
class BBoilerplate_Google {
	/*
	 * Does an XML search for articles
	 * q = query
	 * p = page
	 * t = type, 'article' or 'journal'
	 * articlePiis = add article piis to result (boolean)
	 */
	public function q($q, $p = 0, $t = 'article', $articlePiis = false){
		$results = array();
		if($t=='article'){
			$cx = BBoilerplate::config('CXarticle');
			$num = 1;
		} else {
			$cx = BBoilerplate::config('CXjournals');
			$num = 1;
		}
		$xml = simplexml_load_file('https://www.google.com/cse?cx='.$cx.'&client=google-csbe&num='.$num.'&start='.$p.'&output=xml_no_dtd&q='.urlencode($q));
		if(isset($xml->Spelling->Suggestion)){
			$results['didYouMean'] = $xml->Spelling->Suggestion;
		} else {
			$results['didYouMean'] = false;
		}
		
		$results['query'] = $xml->Q;
		$results['time'] = $xml->TM;
		$i=0;
		if($t=='article'){
			//
			// search article realtions
			//
			foreach($xml->RES->R as $result){
				$results['r'][$i]['title'] = $result->T;
				$results['r'][$i]['description'] = $result->S;
				foreach($result->PageMap->DataObject->Attribute as $attribute ){
					if($attribute['name'][0]=='citation_journal_title') $results['r'][$i]['journal_title'] = $attribute['value'][0];
					if($attribute['name'][0]=='citation_issn') 		$results['r'][$i]['issn'] 			= $attribute['value'][0];
					if($attribute['name'][0]=='citation_volume') 	$results['r'][$i]['volume'] 		= $attribute['value'][0];
					if($attribute['name'][0]=='citation_issue') 	$results['r'][$i]['issue'] 			= $attribute['value'][0];
					if($attribute['name'][0]=='citation_date') 		$results['r'][$i]['date'] 			= $attribute['value'][0];
					//if($attribute['name'][0]=='citation_title') 	$results['r'][$i]['title'] 			= $attribute['value'][0];
					if($attribute['name'][0]=='citation_firstpage') $results['r'][$i]['firstpage'] 		= $attribute['value'][0];
					if($attribute['name'][0]=='citation_lastpage') 	$results['r'][$i]['lastpage'] 		= $attribute['value'][0];
					if($attribute['name'][0]=='citation_type') 		$results['r'][$i]['type'] 			= $attribute['value'][0];
					if($attribute['name'][0]=='citation_doi') 		$results['r'][$i]['doi'] 			= $attribute['value'][0];
					if($attribute['name'][0]=='citation_pii'){ 
						$results['r'][$i]['pii'] = $attribute['value'][0];
						BBoilerplate_Api::renderAbstract($results['r'][$i]['pii']);
						//BBoilerplate_Api::article($results['r'][$i]['pii'], 'FULL', false);
					}
					if($attribute['name'][0]=='citation_authors') 	$results['r'][$i]['authors'] 		= $attribute['value'][0];
				}
				//$results[$i]['abstract'] = BBoilerplate_Api::renderAbstract($results[$i]['pii'], 0);
				$i++;
			}
		} else if($t=='journal'){
			//
			// search journal realtions
			//
			if(isset($results['didYouMean']) && count($xml->RES->R)==0){
				self::q(strip_tags($results['didYouMean']), 0, 'journal');
			} else {
				foreach($xml->RES->R as $result){
					$pos = strpos($result->T, "|");
					if($pos!==false) {
						$i2=0;
						$title = explode("|", $result->T);
						$doi = str_replace('http://www.sciencedirect.com/science/journal/', '', $result->U);
						$doi = explode('/', $doi);
						$results['dois'][strip_tags($title[0])]['doi'] = $doi[0];
						if($articlePiis===true){
							$xmlPiis = simplexml_load_file(BBoilerplate::xmlSearchCache('http://rss.sciencedirect.com/publication/science/'.$doi[0]));
							foreach($xmlPiis->channel->item as $xmlPii){
								$results['dois'][strip_tags($title[0])]['piis'][$i2]['title'] = $xmlPii->title;
								$results['dois'][strip_tags($title[0])]['piis'][$i2]['date'] = $xmlPii->feedDate;
								$results['dois'][strip_tags($title[0])]['piis'][$i2]['pii'] = substr($xmlPii->guid, strpos($xmlPii->guid, 'piikey')+9, 17);
								$i2++;
							}
						}
					}
				}
			}
		}
		return $results;
	}
}
?>