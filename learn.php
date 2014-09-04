<?php
//
// Deegin profile
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
?><!DOCTYPE HTML><html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Learn.css', 'css')?></head><body>
    <div id="container">
    	<span>
        	<h1 class="bullet">Can I see the introduction again?</h1>
        	<div class="answer">Yes, click <a href="/welcome" target="_self">here</a></div>
        </span>
        <span>
        	<h1 class="bullet">What is Deegin?</h1>
        	<div class="answer">Deegin is a place where researchers can acquire and work with scientific content that will help them discover, plan and advance scientific and engineering research using Elsevier’s world leading journal and book content.</div>
        </span>
        <span>
            <h1 class="bullet">Do I need a Paypal account?</h1>
            <div class="answer">We only use PayPal to process credit card transactions. You may use any major credit card to pay for the content you need. Of course, you are welcome to use your Paypal account if you prefer.</div>
        </span>
        <span>
            <h1 class="bullet">Must I buy all the content I use on Deegin?</h1>
            <div class="answer">No, you do not have to purchase all the content you wish to read.  There is a rental option on Deegin that allows you to view content for 36 hours online. However, with a rental, you may not download or copy the content you rent.</div>
        </span>
        <span>
            <h1 class="bullet">What do you do with my social login details?</h1>
            <div class="answer">We keep all your login information confidential and use your login information only to identify you as a user on the Deegin platform.</div>
        </span>
        <span>
            <h1 class="bullet">How do you store my credit card details?</h1>
            <div class="answer">Paypal Vault, a recognized PCI complaint service provider, stores your credit card details.  Deegin does not keep any of your payment information on its servers.</div>
        </span>
        <span>
            <h1 class="bullet">Why can’t I download rental articles?</h1>
            <div class="answer">The Deegin rental agreement gives you the right to read content for a limited period of time (36 hours), at a reduced rate per article.  To have full rights to an article, including printing or downloading, you need to pay the full purchase prices for the article.</div>
        </span>
        <span>
            <h1 class="bullet">What are Deegin Apps?</h1>
            <div class="answer">Deegin Apps enable you to use the content you purchased on Deegin on the platform with which you are most comfortable.</div>
        </span>
        <span>
            <h1 class="bullet">I have a great idea on an improvement or change to Deegin.  How do I tell you about it?</h1>
            <div class="answer">Suggestions on making Deegin a better tool for our users are always welcome.  Just send us an email at hello@deeg.in and put the word IDEA in the subject.  We’ll review all suggestions that come in and get back to you if your idea is adopted. </div>
        </span>
        <span>
            <h1 class="bullet">What’s the best way search Deegin?</h1>
            <div class="answer">Deegin uses Google Scholar technology for searching Elsevier content. Use the same techniques you would use on Google Scholar to conduct your searches.</div>
        </span>
        <span>
            <h1 class="bullet" id="namespace__dashboard">How does the Reader work?</h1>
            <div class="answer">The Reader is the place on Deegin where all the content you have chosen is stored. You can put full-text content in the Reader.  You can also add abstracts you want to reference later. Notes, that you create yourself, are also stored in the Reader. While in the Reader, you can mark content for specific projects by clicking the “+project” button. Projects are color-coded for easy recognition, and are sortable by clicking on the “Manage my projects” button. Double click with your desktop (or tap on your mobile device) to view the full content. By selecting an article you are able to download or print the content. You can remove content from the Reader by clicking to highlight and hitting the trash icon.<br>&nbsp;<br><iframe width="540" height="360" src="//www.youtube.com/embed/SM-lPluCbNA" frameborder="0" allowfullscreen></iframe></div>
        </span>
        <p>&nbsp;</p>
        <span id="askQuestion">
            <p>
                <textarea id="questionArea">Can't find the answer to your question? Please ask it here...</textarea>
            </p>
            <p>&nbsp;</p>
            <button type="button" id="sendRequest">Send my question</button>
        </span>
	</div>
</body>
</html>