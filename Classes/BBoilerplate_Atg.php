<?php
class BBoilerplate_Atg {

	const CONTENTSERVICEURL = 'https://cert1-www.store.elsevier.com/';
	
	/*
	 * Step 1, register a client if RETURN = FALSE an error
	 */
	public function register($firstname, $email, $lastname, $company, $password, $product){
		//
		// Set return to FALSE
		//
		$return = FALSE;
		//
		// Receive the homepage to get the sessionID cookie and fill: $jsessionid
		//
		
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, self::CONTENTSERVICEURL);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_HEADER, 1);
		$result = curl_exec($ch);
		preg_match('/^Set-Cookie:\s*([^;]*)/mi', $result, $m);
		parse_str($m[1], $cookies);
		$jsessionid = $cookies['JSESSIONID'];
		if($jsessionid==''){
			return $return;	
		}
		//
		// Create a new user (this is forced, to make sure the user excists
		//
		curl_setopt($ch, CURLOPT_URL, self::CONTENTSERVICEURL.';jsessionid='.$jsessionid);
		$data = array('_dyncharset' => 'UTF-8',
					  //'_dynSessConf' => '-6028645279099295722',
					  '_DARGS' => '/createAccount.jsp',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.firstName' 		 => $firstname,
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.firstName'	 => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.login' 			 => $email,
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.login'		 => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.lastName' 		 => $lastname,
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.lastName'	 => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.estAccountInfoVo.companyName' => $company,
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.estAccountInfoVo.companyName' => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.isCicUser' 			 => '1',
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.isCicUser'	 	 	 => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.password' 		 => $password,
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.password'	 => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.confirmPassword' => $password,
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.value.confirmPassword' => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.confirmPassword' 		 => 'true',
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.confirmPassword'	 => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.registerSuccessURL' 	 => 'http://cert1-www.store.elsevier.com/index.jsp?locale=en_EU',
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.registerSuccessURL' => ' ',
					  'com/elsevier/commerce/profile/ESTAccountProfileFormHandler.create' 				 => 'Submit Query',
					  '_D:com/elsevier/commerce/profile/ESTAccountProfileFormHandler.create'			 => ' ',
					  '_DARGS'																			 => '/createAccount.jsp');
		curl_setopt($ch, CURLOPT_POST, TRUE);
		curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
		$result = curl_exec($ch);
		//
		// Login the user
		//
		curl_setopt($ch, CURLOPT_URL, self::CONTENTSERVICEURL.';jsessionid='.$jsessionid);
		$data = array('_dyncharset' => 'UTF-8',
					  '_DARGS' => '/common/include/profile/login.jsp.form_login',
					  '/com/elsevier/commerce/profile/ESTProfileFormHandler.value.login' => $email,
					  '_D:/com/elsevier/commerce/profile/ESTProfileFormHandler.value.login' => ' ',
					  '/com/elsevier/commerce/profile/ESTProfileFormHandler.value.password' => $password,
					  '_D:/com/elsevier/commerce/profile/ESTProfileFormHandler.value.password' => ' ',
					  '/com/elsevier/commerce/profile/ESTProfileFormHandler.login' => 'Login',
					  '_D:/com/elsevier/commerce/profile/ESTProfileFormHandler.login' => ' ',
					  '/com/elsevier/commerce/profile/ESTProfileFormHandler.loginSuccessURL' => 'http://cert1-www.store.elsevier.com/home.jsp',
					  '_D:/com/elsevier/commerce/profile/ESTProfileFormHandler.loginSuccessURL' => ' ',
					  '/com/elsevier/commerce/profile/ESTProfileFormHandler.loginErrorURL' => 'http://cert1-www.store.elsevier.com/common/include/error/loginError.jsp',
					  '_D:/com/elsevier/commerce/profile/ESTProfileFormHandler.loginErrorURL' => ' ');
		curl_setopt($ch, CURLOPT_POST, TRUE);
		curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
		$result = curl_exec($ch);
		//
		// Add articles to cart
		//
		curl_setopt($ch, CURLOPT_URL, self::CONTENTSERVICEURL.'common/include/;jsessionid='.$jsessionid);
		$data = array('_dyncharset' => 'UTF-8',
					  '_DARGS' => '/common/include/addToCartBook.jsp',
					  '/atg/commerce/order/ESTShoppingCartModifier.catalogRefIds' => $product,
					  '_D:/atg/commerce/order/ESTShoppingCartModifier.catalogRefIds' => ' ',
					  '/atg/commerce/order/ESTShoppingCartModifier.addItemToOrderSuccessURL' => '/product.jsp?isbn=ArticleChoice&_requestid=2966',
					  '_D:/atg/commerce/order/ESTShoppingCartModifier.addItemToOrderSuccessURL' => ' ',
					  '/atg/commerce/order/ESTShoppingCartModifier.addItemToOrderErrorURL' => '/cart.jsp',
					  '_D:/atg/commerce/order/ESTShoppingCartModifier.addItemToOrderErrorURL' => ' ',
					  '/atg/commerce/order/ESTShoppingCartModifier.productId' => 'EST_GLB_BS-PK-ArticleChoice',
					  '_D:/atg/commerce/order/ESTShoppingCartModifier.productId' => ' ',
					  '/atg/commerce/order/ESTShoppingCartModifier.quantity' => '1',
					  '_D:/atg/commerce/order/ESTShoppingCartModifier.quantity' => ' ',
					  '/atg/commerce/order/ESTShoppingCartModifier.addBookToOrder' => 'Add to Cart',
					  '_D:/atg/commerce/order/ESTShoppingCartModifier.addBookToOrder' => ' ');
		curl_setopt($ch, CURLOPT_POST, TRUE);
		curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
		//curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); //temp return
		$result = curl_exec($ch);

		curl_close($ch);
		exit;
	}
	
}