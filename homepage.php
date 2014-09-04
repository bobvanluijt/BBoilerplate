<?php
//
// Deegin login system, valid user get redirected
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
if(BBoilerplate::user()!==false){
	header('Location: //ajax.deeg.in/dashboard.php');
	exit;
}
?><!DOCTYPE html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><link rel="apple-touch-icon-precomposed" href="/Lib/Img/cornerstone_80x80.png"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" />
<script src="./Cache/JsCss/Core.js"></script>
<?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Homepage.css', 'css')?></head><body>
<div class="topBlock">
	<div id="moreInfo">&nbsp;</div>
</div>
<div id="header">
	<div id="headerContent">
    	<span style="float:left;"><img src="//ajax.deeg.in/Lib/Img/Elsevierlogo_@2.png" style="width:120px" alt="Elsevier logo" /></span>
        <span style="float:right; margin-top:-2px">
        	<a href="#" id="Login_Button"><img src="//ajax.deeg.in/Lib/Icons/Fill/profile.png" style="width:20px;" alt="" /><span style="position:relative;top:-3px">Login</span></a>
            <!--<span>&nbsp;</span>-->
            <!--<a href="#" id="NeedHelp_Button">Need help?</a>-->
        </span>
    </div>
</div>
<div class="blocks" style="background-color:#F6F6F6">
	<div class="innerBlocks innerBlocksLeft innerBlocksText">
        <h1>Deegin is the corporate researcher’s free new solution for working with Elsevier's content. Rent or buy articles as you need them.</h1>
    </div>
	<div class="innerBlocks innerBlocksRight blockImage" style="background-image:url(//ajax.deeg.in/Lib/Img/home1.png)"></div>
</div>
<div class="blocks" style="background-color:#D3D76A">
	<div class="innerBlocks innerBlocksLeft blockImage" style="background-image:url(//ajax.deeg.in/Lib/Img/home2.png);top:20px"></div>
    <div class="innerBlocks innerBlocksRight innerBlocksText">
    	<h1>Gain key insights and ideas</h1>
        <h2>Get the research findings most important to your project.</h2>
    </div>
</div>
<div class="blocks" style="background-color:#F6F6F6">
	<div class="innerBlocks innerBlocksLeft innerBlocksText">
    	<h1>Organize your data</h1>
        <h2>Select, collect, notate and manage the data, in Deegin or on the platform that you prefer.</h2>
    </div>
	<div class="innerBlocks innerBlocksRight blockImage" style="background-image:url(//ajax.deeg.in/Lib/Img/home4.png);top:20px"></div>
</div>
<div class="blocks" style="background-color:#47BEB4">
	<div class="innerBlocks innerBlocksLeft blockImage" style="background-image:url(//ajax.deeg.in/Lib/Img/home3.png)"></div>
    <div class="innerBlocks innerBlocksRight innerBlocksText">
    	<h1>Advance your work</h1>
        <h2>Be your most productive with Deegin.</h2>
    </div>
</div>
<div class="blocks" style="background-color:#F6F6F6">
	<div class="innerBlocks innerBlocksLeft innerBlocksText">
    	<h1>Desktop, tablet or mobile</h1>
        <h2>Designed to help you be productive, however you access Deegin.</h2>
    </div>
	<div class="innerBlocks innerBlocksRight blockImage" style="background-image:url(//ajax.deeg.in/Lib/Img/devices.png)"></div>
</div>
<div class="blocks" style="background-color:#FFF">
	<div class="innerBlocks innerBlocksLeft blockImage" style="background-image:url(//ajax.deeg.in/Lib/Img/home5.jpg)"></div>
    <div class="innerBlocks innerBlocksRight innerBlocksText">
    	<h1>Powered by Google</h1>
        <h2>Deegin uses Google Scholar technology to search Elsevier's book and journal content.</h2>
    </div>
</div>

<div id="homepageShow">
    <div id="logo">
        <img src="//ajax.deeg.in/Lib/Img/deegin_full.png" alt="Deegin Logo" />
    </div>
    
    <h1>Discover, acquire and manage research content from<br>Elsevier’s authoritative journals and books</h1>
    
    <div><button id="mainCTA" style="font-size:24px">get your free account</button></div>
    
    <div style="color:#FFF; font-size: 32px; text-shadow: 0 1px 3px rgba(0,0,0,1.5); margin-top: 15px;">Free • Rent • Buy</div>
    
</div>
	<div class="login">
        <img src="//ajax.deeg.in/Lib/Img/deegin_full.png" class="loginLogo" alt="Deegin logo" /><br>
        <img src="//ajax.deeg.in/Lib/Img/signIn_google_big.png" class="loginButton" rel="google" alt="" /><br>
        <img src="//ajax.deeg.in/Lib/Img/signIn_facebook_big.png" class="loginButton" rel="facebook" alt="" /><br>
        <img src="//ajax.deeg.in/Lib/Img/signIn_linkedin_big.png" class="loginButton" rel="linkedin" alt="" /><br>
        <span style="font-size:10px; text-align:center">Copyright &copy; <?=date('Y')?> Elsevier B.V.<br>All rights reserved</span>
    </div>
    <div class="footer">
        	Copyright ©<?=date("Y")?> <a href="http://elsevier.com" target="_blank">Elsevier</a> B.V. All rights reserved.<br>
            <a href="http://www.elsevier.com/legal/privacy-policy" title="Privacy Policy" class="thickbox">Privacy Policy</a> | <a href="http://www.elsevier.com/legal/elsevier-website-terms-and-conditions" title="Terms and Conditions" class="thickbox">Terms and Conditions</a> | <a href="http://www.reedelsevier.com/Pages/Home.aspx" target="_blank">A Reed Elsevier Company</a><br>Cookies are set by this site. To decline them or learn more, visit our <a href="http://www.elsevier.com/legal/use-of-cookies-by-this-site" target="_blank">Cookies page</a>
    </div>
    <script type="text/javascript" src="/Cache/JsCss/Core.js"></script>
</body>
</html>