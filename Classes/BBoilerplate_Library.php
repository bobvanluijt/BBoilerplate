<?php
//
// Library class
//
class BBoilerplate_Library {
	
	/*
	 * Outputs a list with purchases for the current user
	 */
	public function listAll(){
		 DB::connect();
		 $user = BBoilerplate::user();
		 $results = DB::pull("SELECT `pii`, `title`, `desc`, `time` FROM `purchases` WHERE `user` = '".$user['id']."' AND `inReader` = 1;");
		 return $results;
	}
	
	/*
	 * Adds an article to current lib of user
	 */
	public function addToLib($Pii){
		if($Pii!='undefined'){
			 DB::connect();
			 $user = BBoilerplate::user();
			 $xmlLocation = BBoilerplate_Api::abstractLocation($Pii.'_abstract');
			 $abstract = file_get_contents($xmlLocation);
			 $xml = simplexml_load_string($abstract);
   	 		 $xml->getNamespaces(true);
			 $remove = array("Summary", "Abstract"); //remove from desc output
			 $title = $xml->coredata->children('dc', true)->title;
			 $desc = $xml->coredata->children('dc', true)->description;
			 $desc = str_replace($remove, "", $desc);
			 DB::push("INSERT INTO `purchases` (`user`, `pii`, `title`, `desc`, `time`, `relatedPay`)
							VALUES
					   ('".$user['id']."', '".$Pii."', '".$title."', '".$desc."', '0000-00-00 00:00:00', '0');");
		}
	}
	
	/*
	 * Checks if user ownes article return: false, own or lib (lib = it's not owned but in library)
	 */
	public function ownerShip($Pii){
		DB::connect();
		$user = BBoilerplate::user();
		$results = DB::pull("SELECT time FROM `purchases` WHERE  `user` = '".$user['id']."' AND `pii` LIKE  '".$Pii."' LIMIT 1;");
		if(count($results)==0){
			return 'false';	
		} else {
			foreach($results as $result){
				if($result['time']=='0000-00-00 00:00:00'){
					return 'lib';
				} else {
					return 'own';
				}
			}
		}
	}
	
}