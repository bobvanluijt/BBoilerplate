<?php
//
// Paypal class
//
class BBoilerplate_Mail {
	
	public function template($name, $vars=array()){
		//
		// set a template, add an array in $vars like: $vars['title'] = 'Im a title'
		//
		$result = DB::pull("SELECT `subject`, `message` FROM `emails` WHERE name = '".$name."' LIMIT 1");
		$message = $result[0]['message'];
		foreach($vars as $varKey => $var){
			$message = str_replace($varKey, $var, $message);
		}
		$returner['message'] = $message;
		$returner['subject'] = $result[0]['subject'];
		return $returner;
	}
	
	public function send($toName, $toEmail, $subject, $message){
		//
		// Gravatar settings: login: deegin pass: noreply$$5
		//
		$headers  = 'MIME-Version: 1.0' . "\r\n";
		$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
		$headers .= 'From: Elsevier Deegin <noreply@deeg.in>' . "\r\n";
		$headers .= 'Reply-To: hello@deeg.in' . "\r\n";
		$body  = '<html><head>';
		$body .= '<style>
		body {
			background-color:#CCCCCC;	
		}
		.container {
			background-color:#FFF;
			padding:10px;
			border-radius:6px;
		}</style>';
		$body .= '</head><body>';
		$body .= '<div class="container">';
		$body .= $message;
		$body .= '</div></body></html>';
		mail($toEmail, $subject, $body, $headers);
	}
	
}