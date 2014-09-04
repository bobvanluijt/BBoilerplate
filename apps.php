<?php
//
// Deegin profile
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
?><!DOCTYPE HTML><html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Apps.css', 'css')?></head><body>
    <div id="container">
        <h1>Deegin Apps</h1>
        <h4>The apps in Deegin help you to easily connect directly to other (cloud) software you may prefer.<br>If your preferred software is not listed or if you would like to see other software or apps, feel free to contact us via email at <a href="mailto:hello@deeg.in" target="_blank">deegin@elsevier.com</a></h4>
        <center><a href="#integration">integration</a> - <a href="#tools">tools</a> - <a href="#developers">developers</a></center>
        <a name="integration"><p><h2 class="h2First">Integration</h2></p></a>
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/Drive.png"></span>Google Docs</div>
            <div class="listItem">Import all your purchased articles into Google Docs.<br>
            </div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;"><em>Coming soon</em></button></div>
        </span>
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/Evernote.png"></span>Evernote</div>
            <div class="listItem">Import all your purchased articles into Evernote.<br>
            </div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;"><em>Coming soon</em></button></div>
            
        </span>
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/DeeginOnline.png"></span>Deegin Open API</div>            <div class="listItem">Deegin Open API import all articles in XML format into your own software.<br><a href="http://www.elsevier.com/author-schemas/elsevier-xml-dtds-and-transport-schemas" target="_blank">Read more about Elsevier XML</a><br>
            </div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;"><em>Coming soon</em></button></div>
        </span>
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/Mendeley.png"></span>Mendeley</div>
            <div class="listItem">Import all your purchased articles into Mendeley.<br>
            </div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;"><em>Coming soon</em></button></div>
        </span>
        <a name="tools"><p><h2>Tools</h2></p></a>
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/Twitter.png"></span>Twitter Alerts</div>
            <div class="listItem">Receive a Tweet as soon new articles in your area of interest are released.<br>
            </div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;"><em>Coming soon</em></button></div>
        </span>
        
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/DeeginOffline.png"></span>Offline browsing</div>
            <div class="listItem">Use Deegin to read your articles offline.</div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;"><em>Coming soon</em></button></div>
        </span>
        <a name="developers"><p><h2>Developers</h2></p></a>
        <span class="dashboardBox">
            <div class="listItem"><span class="appIcon"><img src="/Lib/Icons/Apps/Developer.png"></span>Developers</div>
            <div class="listItem">Add simple boxes to your own website to directly sell articles.<br>Documentation: <a href="http://developer.deeg.in" target="_blank">developer.deeg.in</a></div>
            <div class="listItem"><button id="mendeley" class="enable-disable" style="width:100%;height:100%;">Enable</button></div>
        </span>
    </div>
</body>
</html>