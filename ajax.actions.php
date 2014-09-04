<?php
//
// Ajax actions receives AJAX calls and solves them
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();

//
//Create a project
//
if($_GET['i']=='createProject'){
	$user = BBoilerplate::user();
	DB::push("INSERT INTO `projects` (`user`, `name`, `color`) VALUES ('".$user['id']."', '".mysql_real_escape_string(htmlspecialchars($_POST['v']))."', '".mysql_real_escape_string(htmlspecialchars($_POST['color']))."');");
	exit;
}

//
// save note data
//
if($_GET['i']=='saveNote'){
	DB::push("UPDATE `purchases` SET `title` = '".mysql_real_escape_string(htmlspecialchars($_POST['noteTitle']))."' WHERE `pii` = '".mysql_real_escape_string(htmlspecialchars($_POST['noteId']))."';");
	$noteId = DB::pull("SELECT `id` FROM `purchases` WHERE `pii` = '".mysql_real_escape_string(htmlspecialchars($_POST['noteId']))."' LIMIT 1");
	DB::push("UPDATE `notes` SET `text` = '".mysql_real_escape_string(htmlspecialchars($_POST['noteContent']))."' WHERE `mainId` =  '".$noteId[0]['id']."'");
	
	//
	//update desc
	//
	
	DB::push("UPDATE `purchases` SET `desc` = '".substr(mysql_real_escape_string(htmlspecialchars($_POST['noteContent'])), 0, 250)."' WHERE `pii` =  '".mysql_real_escape_string(htmlspecialchars($_POST['noteId']))."' AND `desc` = 'Description...'");
	
	exit;
}

//
//remove from reader
//
if($_GET['i']=='remove'){
	$user = BBoilerplate::user();
	DB::push("UPDATE `purchases` SET `inReader` =0 WHERE `pii` = '".mysql_real_escape_string(htmlspecialchars($_GET['Pii']))."' AND user = '".$user['id']."';");
	exit;
}

//
// return if openaccess
//
if($_GET['i']=='accessType'){
	echo BBoilerplate_Auth::validateOpenaccess(mysql_real_escape_string(htmlspecialchars($_GET['Pii'])));
	exit;
}

//
// save profile
//
if($_GET['i']=='profile'){
	$user = BBoilerplate::user();
	$query = "UPDATE `users` SET";
	foreach($_POST as $key => $name){
		$query .= " `".mysql_real_escape_string($key)."` = '".mysql_real_escape_string($name)."',";
	}
	$query = substr($query, 0, -1)." WHERE `id` = ".$user['id']." LIMIT 1";
	DB::push($query);
	$user = BBoilerplate::user();
	$messager = BBoilerplate_Mail::template('account_done');
	if($user['contactEmail']!=''){
		$user['email'] = $user['contactEmail'];
	}
	BBoilerplate_Mail::send($user['firstname'].' '.$user['lastname'], $user['email'], $messager['subject'], $messager['message']);
	header('Location: /profile#details');
	exit;
}

//
// return global search result
//
if($_GET['i']=='globalSearch'){
	echo BBoilerplate::globalSearch($_GET['q']);
	exit;
}

//
// checks if users ownes the article, sends back false, own or lib (lib = it's not owned but in library)
//
if($_GET['i']=='ownerShip'){
	echo BBoilerplate_Library::ownerShip(htmlspecialchars($_GET['Pii']));
	exit;
}

//
// adds an article to the lib
//
if($_GET['i']=='addToLib'){
	echo  BBoilerplate_Library::addToLib(htmlspecialchars($_GET['Pii']));
	echo 'done';
	exit;
}

//
//buy balance in bulk
//
if($_GET['i']=='buyBulk'){
	$user = BBoilerplate::user();
	
	if($_GET['v']=='buyBulk__1'){
		$returner = BBoilerplate_Paypal::doVaultPay('165.00', 'buyBulk__1');
	} else if($_GET['v']=='buyBulk__2'){
		$returner = BBoilerplate_Paypal::doVaultPay('320.00', 'buyBulk__2');
	} else if($_GET['v']=='buyBulk__3'){
		$returner = BBoilerplate_Paypal::doVaultPay('465.00', 'buyBulk__3');
	} else if($_GET['v']=='buyBulk__4'){
		$returner = BBoilerplate_Paypal::doVaultPay('745.00', 'buyBulk__4');
	} else {
		echo 'fail a: '.$_GET['v'];
		exit;
	}
	
	if($returner===false){
		//something went wrong, return false
		echo 'fail b';	
		exit;
	} else {
		echo 'success';	
		exit;
	}
	
}

//
//remove creditcard
//
if($_GET['i']=='removeCreditcard'){
	if(BBoilerplate_Paypal::removeCard(BBoilerplate::user())===true){
		echo 'success';
	} else {
		echo 'fail';	
	}
	exit;
}
//
//validate creditcard
//
if($_GET['i']=='validateCreditcard'){
	$cc 		= mysql_real_escape_string(htmlspecialchars($_POST['creditNumber_1'].$_POST['creditNumber_2'].$_POST['creditNumber_3'].$_POST['creditNumber_4']));
	$type		= mysql_real_escape_string(htmlspecialchars($_POST['cardType']));
	$firstname 	= mysql_real_escape_string(htmlspecialchars($_POST['cc_firstname']));
	$lastname 	= mysql_real_escape_string(htmlspecialchars($_POST['cc_lastname']));
	$month 		= mysql_real_escape_string(htmlspecialchars($_POST['expMonth']));
	$year 		= mysql_real_escape_string(htmlspecialchars($_POST['expYear']));
	$returner = BBoilerplate_Paypal::addCard($type, $cc, $month, $year, $firstname, $lastname);
	if($returner===true){
		echo 'success';
	} else {
		echo 'fail';	
	}
	exit;
}

//
// returns username
//
if($_GET['i']=='username'){
	$user = BBoilerplate::user();
	echo $user['email'];
	exit;	
}

//
// check if openaccess
//
if($_GET['i']=='openaccess'){
	BBoilerplate_Api::openaccess(htmlspecialchars($_GET['Pii']));
	exit;
}
//
// returns a search abstract with extra info
//
if($_GET['i']=='searchAbstract'){
	echo BBoilerplate_Api::renderAbstract(htmlspecialchars($_GET['Pii']), 0);
	exit;	
}

//
// ajax purchase tokens
//
if($_GET['i']=='buyTokens'){
	$html = file_get_contents('./Lib/Phtml/purchaseTokens.phtml');	
	echo $html;
	exit;
}

//
//Get price of PII
//
if($_GET['i']=='getPrice'){
	$Pii  = htmlspecialchars($_GET['pii']);
	echo BBoilerplate_Pricing::getPrice($Pii);
	exit;	
}

//
//Returns the tax if needed as a text returner
//
if($_GET['i']=='purchaseText'){
	$user = BBoilerplate::user();
	$type = htmlspecialchars($_GET['type']);
	$Pii  = htmlspecialchars($_GET['Pii']);
	$Price = BBoilerplate_Pricing::getPrice($Pii);
	$VAT = BBoilerplate_Pricing::VAT($Pii);
	if($_GET['type']=='buy'){
		if($VAT===false){
			echo 'Are you sure you would like to buy: '.BBoilerplate_Api::renderAbstractObject($Pii, 'title').' for:
		<br><strong>$'.$Price.'</strong> will be charged to your credit card.';
		} else {
			echo 'Are you sure you would like to rent: '.BBoilerplate_Api::renderAbstractObject($Pii, 'title').' for:
		<br><strong>$'.$VAT['including'].'</strong><br>($'.$VAT['excluding'].' + '.$VAT['VAT_rate'].' ($'.$VAT['VAT'].') VAT)</strong> will be charged to your credit card.';
		}
	} else {
		if($VAT===false){
			echo 'Are you sure you would like to rent: '.BBoilerplate_Api::renderAbstractObject($Pii, 'title').' for:
		<br><strong>$5.00</strong> will be charged to your credit card.';
		} else {
			echo 'Are you sure you would like to rent: '.BBoilerplate_Api::renderAbstractObject($Pii, 'title').' for:
		<br><strong>$'.$VAT['rent']['including'].'</strong><br>($'.$VAT['rent']['excluding'].' + '.$VAT['rent']['VAT_rate'].' ($'.$VAT['rent']['VAT'].') VAT)</strong> will be charged to your credit card.';
		}
	}
	exit;
}

//
//Last purchase ID
//
if($_GET['i']=='lastPurchase'){
	$user = BBoilerplate::user();
	$results = DB::pull("SELECT `relatedPay` FROM `purchases` WHERE `user` = '".$user['id']."' ORDER BY `id` DESC LIMIT 1");
	echo $results[0]['relatedPay'];
	exit;
}

//
//Ajax a purchase
//
if($_GET['i']=='purchase'){
	$type = $_GET['type'];
	$Pii  = htmlspecialchars($_GET['Pii']);
	echo BBoilerplate_Auth::doPurchase($type, $Pii);
	exit;
}

//
// Ajax an edit on a product desc
//
if($_GET['i']=='addDescription'){
	$user = BBoilerplate::user();
	$pii = strip_tags(htmlspecialchars($_POST['pii']));
	$text = strip_tags(htmlspecialchars($_POST['text']));
	$text = str_replace("'", "&prime;", $text);
	DB::push("UPDATE `purchases` SET `desc` = '".$text."' WHERE `pii` = '".$pii."' AND `user` = '".$user['id']."' LIMIT 1");
	echo 1; //1 = ok for AJAX
	exit;	
}

//
// send comments for a Pii
//
if($_GET['i']=='comment'){
	$user = BBoilerplate::user();
	if($_POST['comment']!='false'){
		DB::push("INSERT INTO `comments` (`user`, `pii`, `para`, `comment`, `date`) VALUES ('".$user['id']."', '".strip_tags($_GET['pii'])."', '".strip_tags($_GET['para'])."', '".mysql_real_escape_string(htmlspecialchars($_POST['comment']))."', NOW());");
	}
	$results = DB::pull("SELECT comment, user, date FROM comments WHERE pii = '".strip_tags($_GET['pii'])."' AND user = '".$user['id']."' AND para = '".strip_tags(htmlspecialchars($_GET['para']))."' ORDER BY date DESC");
	foreach($results as $result){
		$postUser = BBoilerplate::user($result['user']);
		echo '<table>
		  <tr>
			<td><img src="'.$postUser['picture'].'" class="commentImage" /></td>
			<td class="commentText"><strong>'.$postUser['firstname'].' '.$postUser['lastname'].'</strong><br>'.$result['date'].'<br>'.$result['comment'].'</td>
		  </tr>
		</table><hr class="commentHr" />';
	}
	echo '<textarea id="commentField"></textarea><input type="button" id="submitComment" value="Submit comment"></input>';
	exit;	
}

//
// Add or remove a project
//
if($_GET['i']=='projectEnabeler'){
	$user = BBoilerplate::user();
	$results = DB::pull("SELECT `projects` FROM `purchases` WHERE `user` = ".$user['id']." AND `pii` = '".mysql_real_escape_string(htmlspecialchars($_GET['Pii']))."' LIMIT 1");
	$allProjects = explode("|", $results[0]['projects']);
	
	if($_GET['type']=='on'){
		array_push($allProjects, str_replace("project_", "", htmlspecialchars($_GET['project'])));
		$allProjects = array_unique($allProjects);
	} else {
		if(($key = array_search(str_replace("project_", "", htmlspecialchars($_GET['project'])), $allProjects)) !== false) {
			unset($allProjects[$key]);
		}
	}
	$allProjects = implode("|", $allProjects);
	DB::push("UPDATE `purchases` SET `projects` = '".$allProjects."' WHERE `user` = ".$user['id']." AND `pii` = '".htmlspecialchars($_GET['Pii'])."'");
	exit;	
}

//
// Ajax a project into thickbox
//
if($_GET['i']=='project'){
	$projectName = strip_tags($_GET['val']);
	if($projectName=='[add]'){
		$newProject = BBoilerplate_Projects::listProjects();
		echo BBoilerplate::AjaxHtml($newProject);	
	} else {
		$excistingProject = BBoilerplate_Projects::loadProject($projectName);
		echo BBoilerplate::AjaxHtml($excistingProject);
	}
}

//
// Show the projects and selections
//
if($_GET['i']=='showProjects'){
	$user = BBoilerplate::user();
	//get all user projects
	$results = DB::pull("SELECT * FROM `projects` WHERE `user` = ".$user['id']);
	//get all projects related to this Pii
	$resultsPii = DB::pull("SELECT `projects` FROM `purchases` WHERE `pii` LIKE  '".mysql_real_escape_string(htmlspecialchars($_GET['Pii']))."' AND `user` = ".$user['id']." LIMIT 1");
	$projectsRelated = explode("|", $resultsPii[0]['projects']);
	
	if(count($results)==0){
		echo '<div class="projectBox addProject"><span>+</span></div>';
		exit;
	} else {
		foreach($results as $result){
			echo '<div class="projectBox projectBoxTitle" style="background-color:'.$result['color'].';" rel="'.$result['id'].'">'.$result['name'].'</div>';
		}
	}
	echo '<div class="projectBox addProject"><span>+</span></div>';
	exit;	
}

//
// Add to a users project
//
if($_GET['i']=='addToProject'){
	$user = BBoilerplate::user();
	//echo $_GET['name']. ' to '. $_GET['addTo'];
	$results = DB::pull("SELECT id FROM projects WHERE name = '".strip_tags($_GET['name'])."' AND user = '".$user['id']."' LIMIT 1");
	foreach($results as $result){
		$addId = $result['id'];
	}
	$results = DB::pull("SELECT id, projects FROM purchases WHERE pii = '".strip_tags($_GET['addTo'])."' AND user = '".$user['id']."' LIMIT 1");
	foreach($results as $result){
		$purchaseId = $result['id'];
		$projectArray = explode("|", $result['projects']);
	}
	array_push($projectArray, $addId);
	$projectArraySpliter = array();
	foreach($projectArray as $projectArraySplit){
		$projectArraySpliter[$projectArraySplit] = '';	
	}
	$updateArray = array();
	foreach($projectArraySpliter as $key => $val){
		if (is_numeric($key)){
			array_push($updateArray, $key);
		}
	}
	
	asort($updateArray);
	
	$updateArray = implode("|", $updateArray);

	DB::push("UPDATE purchases SET projects = '".$updateArray."' WHERE id = '".$purchaseId."' AND user = '".$user['id']."' LIMIT 1");
	echo 1; //1 = okay for ajax
	exit;
}