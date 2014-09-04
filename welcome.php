<?php
//
// Deegin profile
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run(false);
BBoilerplate::validateUser();
$user = BBoilerplate::user();
if($user['welcome']==0){
	DB::push("UPDATE `users` SET `welcome` = 1 WHERE id = '".$user['id']."' LIMIT 1");
} else {
	header('Location: /info');
	exit;
}
?><!DOCTYPE HTML><html><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Welcome.css', 'css')?></head><body>
    <div id="animationBox">
    	<div id="animation1" class="animationClass"></div>
        <div id="animation2" class="animationClass"></div>
        <div id="animation3" class="animationClass"></div>
        <div id="animation4" class="animationClass"></div>
        <div id="animation5" class="animationClass"></div>
        <div id="animation6" class="animationClass"></div>
        <div id="animation7" class="animationClass"></div>
    </div>

    <div id="container">

    	<div class="demoBox" id="demo1">
        	<center><img src="/Lib/Img/deegin_full.png" style="width:70px"></center>
            Welcome to Elsevier's Deegin. In this quick tutorial, you can see how easy it is to work in Deegin. 
			<p>&nbsp;</p>
			After viewing this tutorial, go to the menu on the left side of the page. Just click on the menu to open it.
            <p>&nbsp;</p>
            <center><iframe width="315" height="280" src="//www.youtube.com/embed/3XY9Kd1TQMw" frameborder="0" allowfullscreen></iframe></center>
        </div>
        
        <div class="demoBox" id="demo2">
        	<center><img src="/Lib/Img/deegin_full.png" style="width:70px"></center>
            <h4>Search Deegin</h4>
            Now that you've logged in, you can search and browse through millions of primary research articles and book chapters. 
            <p>&nbsp;</p>
            If an article is open access, you can read the whole article right away.
If not, you can read the abstract and then rent the article for 36 hours ($5 US) or purchase it, with the ability to download and print.
            <p>&nbsp;</p>
            <center><iframe width="315" height="250" src="//www.youtube.com/embed/g46a5SDlCdQ" frameborder="0" allowfullscreen></iframe></center>
        </div>
        
        <div class="demoBox" id="demo3">
        	<center><img src="/Lib/Img/deegin_full.png" style="width:70px"></center>
            <h4>Organize your content</h4>
        	Deegin's Reader is where you will store and organize the content you have acquired through Deegin. 
			<p>&nbsp;</p>
			You can do things like: project organizing, tagging, adding descriptions, downloading and printing content. Just double click on a title to go to the article.
            <p>&nbsp;</p>
            <center><iframe width="315" height="280" src="//www.youtube.com/embed/SM-lPluCbNA" frameborder="0" allowfullscreen></iframe></center>
        </div>
        
        <div class="demoBox" id="demo4">
        	<center><img src="/Lib/Img/deegin_full.png" style="width:70px"></center>
            <h4>Rent or buy</h4>
        	Once you've set up your secure account, you can buy or rent articles with a single click. Go to Profile in the menu to add your credit card information.<br>&nbsp;<br>Open access articles are always available to you for free.
            <p>&nbsp;</p>
            <center><iframe width="315" height="280" src="//www.youtube.com/embed/ue3B8QwOaFo" frameborder="0" allowfullscreen></iframe></center>
        </div>
        
        <div class="cursor">
        	<span class="ball selected" id="ball1">&nbsp;</span>
            <span class="ball" id="ball2">&nbsp;</span>
            <span class="ball" id="ball3">&nbsp;</span>
            <span class="ball" id="ball4">&nbsp;</span>
        </div>
        
        <div class="buttonsToNext">
        	<span style="position:relative; float:left">
        		<button id="gotoDeegin">Continue to Deegin</button>
            </span>
        	
            
            <span style="position:relative; float:right;right:-4px;">
            	<button id="gotoNext">Got it, next &gt;</button>
            </span>
            <span style="position:relative; float:right; display:none;">
        		<button id="gotoPrevious">&lt; One more time</button>
            </span>
        </div>	
        
	</div>
</body>
</html>