<?php
//
// Returned info from Paypal
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate_Paypal::setConsent(htmlspecialchars($_GET['code']));
echo 'return';
header('Location: /profile');