<?php
//
// Deegin dashboard
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
?><!DOCTYPE html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Dashboard.css', 'css')?></head><body id="body">
<div class="topBlock"><!--topblock contains moving image--></div>
<div id="header" style="z-index:9997;">
	<div id="headerContent">
    	<span style="float:left;"><img src="//ajax.deeg.in/Lib/Img/Elsevierlogo_@2.png" style="width:120px" alt="Elsevier logo" /></span>
    </div>
</div>
<span id="homepageShow">
    <img src="<?=$user['picture']?>" alt="Users face" id="userImage">
    <h1 class="cooltext1">Hi <?=$user['firstname']?>!</h1>
    <h2 class="cooltext2">Welcome to Elseviers Deegin!<br>What are you going to do today?</h2>
</span>
<span id="search" style="display:none;"><!--<h1>Search Elsevier's Journals and Books</h1>--><img src="/Lib/Img/deegin_full.png" id="elsevierLogoSearch" style="width:200px; padding-bottom:2px;" ><br><input id="searchText">
<select id="kindOfSearch">
  <option value="all">All</option>
  <option value="openaccess">Open Access</option>
</select>
<button id="theSearchButton">search!</button><br><span><img src="//ajax.deeg.in/Lib/Img/pbg.png" style="height:28px; margin-top:17px"></span>

<div id="container"></div>
<div id="searchResults"></div>
<div id="searchResultsAbstract"><div id="searchResultsAbstractMore">&nbsp;</div></div>
</span>
<input type="hidden" id="resultCounter" value="0">
</body>
</html>