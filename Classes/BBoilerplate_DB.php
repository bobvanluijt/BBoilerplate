<?php
class BBoilerplate_DB {
	
	function connect(){
		$mysqli = new mysqli(BBoilerplate::config('host'), BBoilerplate::config('username'), BBoilerplate::config('password'), BBoilerplate::config('database'));
		if ($mysqli->connect_errno) {
			printf("Connect failed: %s\n", $mysqli->connect_error);
			exit;
		}
		return $mysqli;
	}
	
	function push($q){
		try {
			$mysqli = DB::connect();
			$result = $mysqli->query($q);
			$returner = $mysqli->insert_id;
			$mysqli->close();
			return $returner;
		} catch (Exception $e) {
			die($e);	
		}
	}
	
	function pull($q){
		try {
			$mysqli = DB::connect();
			$result = $mysqli->query($q);
			
			if ($result = $mysqli->query($q)) {
				$returner = array();
				while($row = $result->fetch_assoc()){
					array_push($returner, $row);
				}
				$result->free();
			}
			$mysqli->close();
			return $returner;
		} catch (Exception $e) {
			//die($e);	
		}
	}
	
}

//
// Elsevier DB alias DB
//
class_alias('BBoilerplate_DB', 'DB');