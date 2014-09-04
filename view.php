<?php
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();

if(strip_tags($_GET['i'])=='N'){
	$view = 'N';	
} else {
	if(substr(strip_tags($_GET['i']), 0, 1)=='N'){
		$view = 'N'.preg_replace("/[^0-9]/","", strip_tags($_GET['i']));	
	} else {
		//$view = 'S'.preg_replace("/[^0-9]/","", strip_tags($_GET['i']));
		$view = strip_tags($_GET['i']);
		BBoilerplate_Api::article($view, 'FULL', false); //downloads to the Cache
	}
}

if(BBoilerplate_Auth::validatePurchase($view)===true || BBoilerplate_Auth::validateNote($view)===true || BBoilerplate_Auth::validateOpenaccess($view)===true){
	//
	// Render the HTML
	//
	$html = str_replace("[[css]]", BBoilerplate::incl('Core.css', 'css'), BBoilerplate_Html::render($view));
	$html = str_replace("[[js]]", BBoilerplate::incl('Core.js', 'js'), $html);
	echo '<!DOCTYPE HTML>'.$html;
} else {
	//
	// Render the abstract or create note
	//
	if($view=='N'){
		 BBoilerplate_Html::renderNote($view);
	} else {
		echo BBoilerplate_Api::renderAbstract($view);
	}	
}