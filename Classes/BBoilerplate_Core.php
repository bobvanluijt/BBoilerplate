<?php
//
// This is the core file, start using it by adding it in a file and execute: BBoilerplate::run()
//
class BBoilerplate {
	
	public function countryList($html=false){
		//
		// sends list with countries
		// if $html = true, send HTML option list
		//
		$user = BBoilerplate::user();
		$returner = array();
		$results = DB::pull("SELECT * FROM `countries` ORDER BY `name` ASC");
		$returnerHTML = '<select name="country" id="countryList" style="width:296px">';
		foreach($results as $result){
			$returner['code'] 	     = $result['code'];
			$returner['name'] 	     = $result['name'];
			$returner['tax']  	     = $result['taxState'];
			$returner['combined']    = $result['name'].' ('.$result['code'].')';
			$returner['combinedTax'] = $result['name'].' ('.$result['taxState'].')';
			$returner['taxNumber']	 = intval($result['taxState']);
			if($user['country']==$result['code']){
				$returnerHTML .= '<option selected="selected" value="'.$returner['code'].'">'.$returner['name'].' ('.$result['code'].')</option>'."\n";
			} else {
				$returnerHTML .= '<option value="'.$returner['code'].'">'.$returner['name'].' ('.$result['code'].')</option>'."\n";	
			}
		}
		$returnerHTML .= '</select>';
		if($html===true){
			return $returnerHTML;
		} else {
			return $returner;	
		}
	}
	
	public function globalSearch($q){
		//
		// does a global search, journals and articles
		//
		$mainCount=0;
		$i=1;
		$html;
		$results = BBoilerplate_Google::q($q);
		if(count($results['r'])!=0){
			$html .= '<h1>articles</h1><br>';
			foreach($results['r'] as $result){
				$mainCount++;
				$html .= '<span class="globalsearchReaction"><a href="/view?i='.$result['pii'].'" target="_self">'.$result['title']."</a></span><br>\n";
				if($i==5){
					break;
				} else {
					$i++;
				}
			}
		}
		$i=1;
		$results = BBoilerplate_Google::q($q, 0, 'journal');
		if(count($results['dois'])!=0){
			$html .= '<h1>journals</h1><br>';
			foreach($results['dois'] as $resultKey => $result){
				$mainCount++;
				$html .= '<span class="globalsearchReaction"><a href="/journal?i='.$result['doi'].'" target="_self">'.$resultKey."</a></span><br>\n";
				if($i==5){
					break;
				} else {
					$i++;
				}
			}
		}
		
		if($mainCount==0){
			return 'Nothing found, check your query';	
		} else {
			return $html;	
		}	
	}
	
	public function xmlSearchCache($i){
		//
		// checks if XML result from URL is already in cache and returns result or XML
		//
		$iUrl = $i;
		$i 	  = BBoilerplate::makeMd5Salt($i);
		$step1 = substr($i, 0, 1);
		$step2 = substr($i, 1, 1);
		$step3 = substr($i, 2, 1);
		$location = './Cache/SearchXml/'.$step1.'/'.$step2.'/'.$step3.'/'.$i.'.xml';
		if(file_exists($location)){
			return $location;
		} else {
			if(!is_dir('./Cache/SearchXml/'.$step1)){
				mkdir('./Cache/SearchXml/'.$step1);
				chmod('./Cache/SearchXml/'.$step1, 0777); 
			}
			if(!is_dir('./Cache/SearchXml/'.$step1.'/'.$step2)){
				mkdir('./Cache/SearchXml/'.$step1.'/'.$step2);
				chmod('./Cache/SearchXml/'.$step1.'/'.$step2.$step1, 0777); 
			}
			if(!is_dir('./Cache/SearchXml/'.$step1.'/'.$step2.'/'.$step3)){
				mkdir('./Cache/SearchXml/'.$step1.'/'.$step2.'/'.$step3);
				chmod('./Cache/SearchXml/'.$step1.'/'.$step2.'/'.$step3, 0777); 
			}
			file_put_contents($location, fopen($iUrl, 'r'));
			return $location;
		}
	}
	
	public function AjaxHtml($i){
		//
		// Create HTML for an iframe ajax window
		//
		$html = '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<head>
					<title>Deegin - Where research gets down to business</title>
					<link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" />
					<script src="//ajax.deeg.in/Lib/Js/Core.js"></script>
					<link rel="stylesheet" type="text/css" href="/Lib/Css/Reset.css" media="all"/>
					<link rel="stylesheet" type="text/css" href="/Lib/Css/Core.css" media="all"/></head>
				<body>'.$i.'</body>
				</html>';
		return $html;
	}
	
	public function logout(){
		setcookie('user', "", time()-15778463, "/", ".deeg.in");
		header('Location: http://deeg.in');
	}
	
	public function user($i = false){
		$results = DB::pull("SELECT * FROM users");
		$returner = false;
		if($i===false){
			$searchUser = BBoilerplate::getCookie('user');
		} else {
			$searchUser = BBoilerplate::makeMd5Salt($i);
		}
		
		foreach($results as $result){
			if(BBoilerplate::makeMd5Salt($result['id'])==$searchUser){
				$returner = $result;
				continue;
			}
		}
		//
		//add Creditcard details
		//
		if($returner['paypalVault']!=0){
			$resultsCredit = DB::pull("SELECT * FROM paypalVault WHERE id = '".$returner['paypalVault']."' LIMIT 1");
			if(count($resultsCredit)!=0){
				$returner['paypal'] = $resultsCredit;
			} else {
				$returner['paypal'] = 0;
			}
		}
		//
		// end creditcard
		//
		return $returner;
	}
	
	public function makeMd5Salt($i){
		//
		// Makes a MD5 salt for Deegin
		// NOTE!!! MD5 replaced by SHA512, but makeMd5Salt stays the function name!
		//
		return openssl_digest($i.BBoilerplate::config('salt'), 'sha512');
	}
	
	public function getCookie($name){
		return $_COOKIE[$name];	
	}
	
	public function setCookie($name, $val){
		try {
			setcookie($name, $val, time()+15778463, "/", ".deeg.in", true, true);
		} catch (Exception $e) {
			die('You need to allow cookies...');		
		}
	}
	
	public function validateUser(){
		if(BBoilerplate::user()===false){
			header('Location: http://deeg.in');
			exit;	
		}
	}
	
	public function config($i){
		//
		// Path to config file, make sure to have exact path
		//
		if (file_exists('/var/www/config.xml')) {
			$xml = simplexml_load_file('/var/www/config.xml');
			$i = strip_tags($i);
			return $xml->$i;
		} else {
			die('There is no config file');	
		}	
	}
	
	public function run($skip = true){
		//
		// Remove .php
		//
		if($_SERVER['HTTP_HOST']=='ajax.deeg.in' || $_SERVER['HTTP_HOST']=='read.deeg.in'){
			$ext = parse_url($_SERVER["REQUEST_URI"]);
			if($_SERVER['HTTP_HOST']=='ajax.deeg.in'){
				header('Location: https://read.deeg.in/dashboard');
				exit;	
			}
			
			if(substr($ext['path'], -4, 4)=='.php'){
				if($ext['query']==''){
					header('Location: '.substr($ext['path'], 0, -4));
				} else {
					header('Location: '.substr($ext['path'], 0, -4).'?'.$ext['query']);
				}
				exit;	
			}
		}
		//
		// Adds all classes to the current session
		//
		$di = new RecursiveDirectoryIterator('./Classes');
		foreach (new RecursiveIteratorIterator($di) as $filename => $file) {
			if($file->getExtension()=='php'){
				include_once($filename);
			}
		}
		//
		//update last seen
		//
		$user = BBoilerplate::user();
		DB::push("UPDATE `users` SET `lastLogin` = NOW() WHERE id = '".$user['id']."' LIMIT 1");
		//
		//send user to welcome
		//
		if($user['welcome']==0 && $user!==false && $skip===true){
			$messager = BBoilerplate_Mail::template('confirmation');
			BBoilerplate_Mail::send($user['firstname'].' '.$user['lastname'], $user['email'], $messager['subject'], $messager['message']);
			header('Location: https://read.deeg.in/welcome');	
			exit;
		}
	}
	
}