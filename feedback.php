<?php
//
// Deegin profile
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
?><!DOCTYPE HTML><html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Feedback.css', 'css')?></head><body>
    <div id="container">
    	<h1>Deegin wants to hear from you!</h1>
        
        <h4>Deegin is a new product in beta.  We welcome  feedback, comments and suggestions from our users – to make this tool more useful and a better resource for you!<br>&nbsp;<br>Send your suggestions/comments to: <a href="mailto:deegin@elsevier.com">deegin@elsevier.com</a>.</h4>
	</div>
</body>
</html>