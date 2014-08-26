function rand(min, max) {
    return parseInt(Math.random() * (max-min+1), 10) + min;
}

function get_random_color() {
    var h = rand(1, 360);
    var s = rand(30, 100);
    var l = rand(30, 70);
    return 'hsl(' + h + ',' + s + '%,' + l + '%)';
}

function enableVisibility(){
	(function($){
	
		/**
		 * Copyright 2012, Digital Fusion
		 * Licensed under the MIT license.
		 * http://teamdf.com/jquery-plugins/license/
		 *
		 * @author Sam Sehnert
		 * @desc A small plugin that checks whether elements are within
		 *       the user visible viewport of a web browser.
		 *       only accounts for vertical position, not horizontal.
		 */
		var $w = $(window);
		$.fn.visible = function(partial,hidden,direction){
	
			if (this.length < 1)
				return;
	
			var $t        = this.length > 1 ? this.eq(0) : this,
				t         = $t.get(0),
				vpWidth   = $w.width(),
				vpHeight  = $w.height(),
				direction = (direction) ? direction : 'both',
				clientSize = hidden === true ? t.offsetWidth * t.offsetHeight : true;
	
			if (typeof t.getBoundingClientRect === 'function'){
	
				// Use this native browser method, if available.
				var rec = t.getBoundingClientRect(),
					tViz = rec.top    >= 0 && rec.top    <  vpHeight,
					bViz = rec.bottom >  0 && rec.bottom <= vpHeight,
					lViz = rec.left   >= 0 && rec.left   <  vpWidth,
					rViz = rec.right  >  0 && rec.right  <= vpWidth,
					vVisible   = partial ? tViz || bViz : tViz && bViz,
					hVisible   = partial ? lViz || lViz : lViz && rViz;
	
				if(direction === 'both')
					return clientSize && vVisible && hVisible;
				else if(direction === 'vertical')
					return clientSize && vVisible;
				else if(direction === 'horizontal')
					return clientSize && hVisible;
			} else {
	
				var viewTop         = $w.scrollTop(),
					viewBottom      = viewTop + vpHeight,
					viewLeft        = $w.scrollLeft(),
					viewRight       = viewLeft + vpWidth,
					offset          = $t.offset(),
					_top            = offset.top,
					_bottom         = _top + $t.height(),
					_left           = offset.left,
					_right          = _left + $t.width(),
					compareTop      = partial === true ? _bottom : _top,
					compareBottom   = partial === true ? _top : _bottom,
					compareLeft     = partial === true ? _right : _left,
					compareRight    = partial === true ? _left : _right;
	
				if(direction === 'both')
					return !!clientSize && ((compareBottom <= viewBottom) && (compareTop >= viewTop)) && ((compareRight <= viewRight) && (compareLeft >= viewLeft));
				else if(direction === 'vertical')
					return !!clientSize && ((compareBottom <= viewBottom) && (compareTop >= viewTop));
				else if(direction === 'horizontal')
					return !!clientSize && ((compareRight <= viewRight) && (compareLeft >= viewLeft));
			}
		};
	
	})(jQuery);
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function setCommentsPerPara(i){
	if(i==null){
		var url = '/ajax.actions?i=comment&pii='+getParameterByName('i')+'&para='+$('.noteLink').attr('rel');
		var theComment = 'false';
		console.log('geen comment');
	} else {
		var url = '/ajax.actions?i=comment&pii='+getParameterByName('i')+'&para='+$('.noteLink').attr('rel');
		var theComment = i;
		console.log('wel comment');
	}
	$.post(url, { comment: theComment }, function( data ) {
		$('.panelRight').html(data);
		$('#submitComment').button();
		$('#submitComment').css('width', '100%');
		$('#submitComment').click(function(){
			setCommentsPerPara($('#commentField').text());
		});
	});
}

var panelOpen = false;
var currentLeft;
var currentLeftPanel;
var currentMenuImage;

function setPanel(urlTo){
	if(panelOpen===false){
		currentLeft = $(".cornerstone").css('left');
		currentLeftPanel = $(".panel").css('left');
		currentMenuImage = $(".panel").css('left');
		console.log(currentLeft+'   '+currentLeftPanel);
		$('#footerPanel').toggle();
		$("#globalSearch").css("background-color", "#999");
		$(".cornerstone").animate({
			left: '300px',
			width: '9999px'
		}, { duration: 100, queue: false });
		$(".menuImage").animate({
			left: '-3px'
		}, { duration: 100, queue: false });
		$(".panel").animate({
		   left: '0px'
		}, { duration: 100, queue: false });
		$(".cornerstone").animate({
		   left: '269px'
		}, { duration: 100, queue: false });
		if($('.article').length){
			var setArticle = 309 - $('.article').offset().left; //299+10 = some extra left margin
			if(setArticle > 0){
				$(".article").animate({
				   left: '+='+(setArticle)+'px' 
				}, { duration: 100, queue: false });	
			}
		}
		
		$('#articleOverview').css('display', 'block');
		
		if($('.lib').css('display')=='block'){
			$(".lib").animate({
			   left: '+=259px'
			}, { duration: 100, queue: false });
		}
		
		if($('.horizontalMenu').length){
			$('.horizontalMenu').css('display', 'block');
			$('.menuItemSearch').css('display', 'block');
		}
		
		panelOpen = true;
	} else {
		$('#footerPanel').toggle();
		$("#globalSearch").css("background-color", "#f4f3f1");
		$(".cornerstone").animate({
			left: '0px',
			width: '40px'
		}, { duration: 100, queue: false });
		$(".menuImage").animate({
			left: '217px'
		}, { duration: 100, queue: false });
		$(".panel").animate({
		   left: currentLeftPanel
		}, { duration: 100, queue: false });
		$(".cornerstone").animate({
		   left: currentLeft+'px'
		}, { duration: 100, queue: false });
		$(".article").animate({
		   left: '-=0px'
		}, { 
			duration: 100,
			queue: false,
			complete: function(){
				$(this).css("left", "");
			}
		});
		
		$('#articleOverview').css('display', 'none');
		
		if($('.lib').css('display')=='block'){
			$('.lib').toggle();
			$(".lib").animate({
			   left: '-=259px'
			}, { duration: 100, queue: false });
		}
		
		if($('.horizontalMenu').length){
			$('.horizontalMenu').css('display', 'none');
			$('.menuItemSearch').css('display', 'none');
		}
		
		panelOpen = false;
		loadUrl(urlTo);
	}
}

var panelRightOpen = false;
function setPanelRight(){
	if(panelRightOpen===false){
		$(".noteLink").animate({
		   left: '-=218px'
		}, { duration: 100, queue: false });
		$(".panelRight").animate({
		   right: '0px'
		}, { duration: 100, queue: false });
		$(".article").animate({
		   left: '-=218px'
		}, { duration: 100, queue: false });
		//
		//Add all the content
		//
		setCommentsPerPara(null);
		panelRightOpen = true;
	} else {
		$(".noteLink").animate({
		   left: '+=218px'
		}, { duration: 100, queue: false });
		$(".panelRight").animate({
		   right: '-320px'
		}, { duration: 100, queue: false });
		$(".article").animate({
		   left: '+=218px'
		}, { 
			duration: 100,
			queue: false,
			complete: function(){
				$(this).css("right", "");
			}
		});
		panelRightOpen = false;
	}
}

function loadUrl(i){
	if(typeof i != 'undefined'){
		setTimeout(function(){
			window.location.assign(i);
		},100);
	}
}

function getUrlVars(){
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('#') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

function setGlobalSearch(){
	var xhr;
	$('#globalSearch').keyup(function(e){
		 if(e.keyCode==13) { //Enter keycode
		 	window.location.assign("/dashboard#!q="+$('#globalSearch').val());
		 }
		if(!$('#globalSearchResults').length){
			$('body').append('<div id="globalSearchResults">&nbsp;</div><div id="globalsearchTrans">&nbsp;</div>');
			$('#globalsearchTrans').click(function(){
				$('#globalsearchTrans').remove();
				$('#globalSearchResults').fadeOut(200, function(){
					$(this).remove();
					$('#globalSearch').val('Search...');	
					$('#globalSearch').css('color', '#f4f3f1');
					$('#globalSearch').css('background-color', '#f4f3f1');
				});
			});
		}
		if(xhr && xhr.readystate != 4){
            xhr.abort();
        }
		var searchVal = $(this).val();
		xhr = $.ajax({
			type: "GET",
			url: "/ajax.actions?i=globalSearch&q="+searchVal,
			success: function(data) {
				$('#globalSearchResults').html(data);
			},
			dataType:"html",
			cache:false
		});
	});
}

function getHashValue(key) {
	return location.hash.match(new RegExp(key+'=([^&]*)'))[1];
}

function addCornerstone(v){
	$('body').append('<div class="cornerstone"><img class="cornerStoneHandle" src="/Lib/Img/drag.png" border="0"></div><div class="panel"></div>');
	$('.panel').html(createPanel(v));
	setGlobalSearch();
	$('#globalSearch').click(function(){
		if($(this).val()=='Search...'){
			$(this).val('');
			$(this).css('color', '#000');
		};
	});
	$('#globalSearch').focusout(function(){
		if($(this).val()==''){
			$(this).val('Search...');
			$(this).css('color', '#999');
		};
	});
	$('#quickSearch').keyup(function(){
		//do something
	});
	$('.menuItem').hover(function(){
		$(this).find('span').animate({
			width:'7px'
		}, 90);
	});
	$('.menuItem').mouseout(function(){
		$(this).find('span').animate({
			width:'0px'
		}, 90);
	});
	$('.menuItem').each(function(index, element) {
		$(this).click(function(){
			var parentThis = $(this);
			$(this).find('span').animate({
				width:'100%'
			}, "fast", function(){
				if(parentThis.text().replace(/\s+/g, '')=='Reader'){ //note the spaces
					setPanel('/reader');
				} else if(parentThis.text().replace(/\s+/g, '')=='Search'){ //note the spaces
					setPanel('/dashboard');
				} else if(parentThis.text().replace(/\s+/g, '')=='Profile'){ //note the spaces
					setPanel('/profile');
				} else if(parentThis.text().replace(/\s+/g, '')=='Fullscreen'){ //note the spaces
					$(document).fullScreen(true);
				} else if(parentThis.text().replace(/\s+/g, '')=='Learn'){ //note the spaces
					setPanel('/learn');
				} else if(parentThis.text().replace(/\s+/g, '')=='Apps'){ //note the spaces
					setPanel('/apps');
				}  else if(parentThis.text().replace(/\s+/g, '')=='Feedback'){ //note the spaces
					setPanel('/feedback');
				}
				
			});
		});
    });
	$('.cornerstone').click(function(){	
		setPanel();
	});
}

function createPanel(v){
	//
	// Creates the HTML of the panel
	//
	//<div class="menuItem"><img src="/Lib/Icons/Open/search.png" class="menuImage" style="top:8px"><input type="text" id="globalSearch" value="Search..."></div>
	
		var returner = '<div class="menuItem"><span class="menuItemOrange">&nbsp;</span><img src="/Lib/Icons/Open/library.png" class="menuImage">Reader</div>';
			
			returner = returner + '<div class="menuItem"><span class="menuItemOrange">&nbsp;</span><img src="/Lib/Icons/Open/search.png" class="menuImage">Search</div>';
			
			returner = returner + '<div class="menuItem"><span class="menuItemOrange">&nbsp;</span><img src="/Lib/Icons/Open/help.png" class="menuImage">Learn</div>';
			
			returner = returner + '<div class="menuItem"><span class="menuItemOrange">&nbsp;</span><img src="/Lib/Icons/Open/profile.png" class="menuImage">Profile</div>';
			
			returner = returner + '<div class="menuItem"><span class="menuItemOrange">&nbsp;</span><img src="/Lib/Icons/Open/cloudEmpty.png" class="menuImage">Apps</div>';
			
			returner = returner + '<div class="menuItem"><span class="menuItemOrange">&nbsp;</span><img src="/Lib/Icons/Open/feedback.png" class="menuImage">Feedback</div>';
		returner = returner + '<div class="menuItem" id="menuItemFullscreen" style="display:none"><span>&nbsp;</span>Fullscreen</div><div id="footerPanel">Copyright ©2014 Elsevier B.V. All rights reserved.<br><a href="http://www.elsevier.com/legal/privacy-policy?keepThis=true&TB_iframe=true&height=460&width=810" title="Privacy Policy" target="_blank">Privacy Policy</a> | <a href="/terms.pdf" title="Terms and Conditions" target="_blank">Terms and Conditions (pdf)</a> | <a href="http://www.reedelsevier.com/Pages/Home.aspx" target="_blank">A Reed Elsevier Company</a><br>Cookies are set by this site | <a href="/logout" target="_self">Logout</a></div>';
		
		
		return returner;
}

function addJs(iAdd){
	var url = location.pathname.split("/");
		url = url[1];
		url = url.replace(".php", "");
		if(url==''){
			url = 'main';	
		}
	var iAdd = '//ajax.deeg.in/Cache/JsCss/'+url+'.Core.'+iAdd+"?additionalTimer="+(Math.random()*1000000);
	$.ajax({
		type: "GET",
		url: iAdd,
		success: function() {
			__run();
		},
		dataType: "script",
		cache: false
	});
}

function setVideoSize(){
	var video_x = 960;
	var video_y = 540;
	$('#videoBackground').css('height', $('.topBlock').height()+'px');
	var new_video_y = $('.topBlock').height();
	var new_video_x = video_x*(new_video_y/video_y);
	$('#videoBackground').css('width', new_video_x);
	if($('#videoBackground').width() < $('.topBlock').width()){
		//
		//change
		//
		console.log('change');
		$('#videoBackground').css('width', $('.topBlock').width()+'px');
		var new_video_x = $('.topBlock').width();
		var new_video_y = video_y*(new_video_x/video_x);
		
		$('#videoBackground').css('height', new_video_y);
	}
}

function addVideo(){
	//
	//Adds video if .topBlock is there and MP4 is supported
	//
	if($('.topBlock').length){
		if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
			//no video
			$('.homepageShow h1').css('color', '#FFF');
			$('.topBlock').css('background-image', 'url(//ajax.deeg.in/Lib/Img/no_vid.jpg)');
		} else {
			var myVideo = document.createElement('video');
			var videoNr = Math.floor((Math.random() * 2) + 1);
			if(myVideo.canPlayType('video/mp4') || myVideo.canPlayType('video/ogg')) {
				
				if(!$('#videoBackground').length){
				
					$('.topBlock').css('background-image', '');
					$('.topBlock').css('background-color', '#FFF');
					
					if(myVideo.canPlayType('video/mp4')){
						videoNr = 2; //force video 2
						$('.topBlock').append('<video id="videoBackground" preload autoplay loop><source src="/Lib/Vid/vid_0'+videoNr+'.mp4" type="video/mp4">');
					} else if(myVideo.canPlayType('video/ogg')){
						videoNr = 2; //force video 2
						$('.topBlock').append('<video id="videoBackground" preload autoplay loop><source src="/Lib/Vid/vid_0'+videoNr+'.ogg" type="video/ogg">');
					}
		
					
					if(videoNr==1){
						$('#homepageShow > h1').css('color', '#FFF');
					} else if(videoNr==2){
						$('#homepageShow > h1').css('color', '#FFF');
					} else if(videoNr==3){
						$('#homepageShow > h1').css('color', '#FFF');
					}
						
					setVideoSize();
					
					$(window).resize(function() {
						setTimeout(function() {
							setVideoSize();
						}, 5);
					});
					
				}
			} else {
				//
				// no video set 'things'
				//
				$('.homepageShow h1').css('color', '#FFF');
				$('.topBlock').css('background-image', 'url(//ajax.deeg.in/Lib/Img/no_vid.jpg)');
			}
		}
	}
}

function moreInfoClick(){
	$('#moreInfo').click(function(){
		$('html, body').animate({
			scrollTop: $('.topBlock').height()-70
		}, 560);
	});
}

function __construct(){
	//
	// function runs the jQuery website
	//
	$.ajax({
		type: "GET",
		url: "//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js",
		success: function() {
			$.ajax({
				type: "GET",
				url: '//ajax.deeg.in/Cache/JsCss/alertify.min.js',
				success: function() {
					$.ajax({
						type: "GET",
						url: '//ajax.deeg.in/Cache/JsCss/thickbox.js',
						success: function() {
							var url = document.location.host+'.js';
							addJs(url);
							enableVisibility();
							moreInfoClick();
							addVideo();
							
							//DISABLE right click and rightclick
							/*
							$(function() {
								$(this).bind("contextmenu", function(e) {
									e.preventDefault();
								});
							});
							*/
							
							//set correct main header size
							if($('.topBlock').length){
								$('.topBlock').height( $(window).height()-46 );
							}
							$(window).resize(function() {
								if($('.topBlock').length){
									$('.topBlock').height( $(window).height()-46 );
								}
							});
							
							;(function($) {
							$.timer = function(func, time, autostart) {	
								this.set = function(func, time, autostart) {
									this.init = true;
									if(typeof func == 'object') {
										var paramList = ['autostart', 'time'];
										for(var arg in paramList) {if(func[paramList[arg]] != undefined) {eval(paramList[arg] + " = func[paramList[arg]]");}};
										func = func.action;
									}
									if(typeof func == 'function') {this.action = func;}
									if(!isNaN(time)) {this.intervalTime = time;}
									if(autostart && !this.isActive) {
										this.isActive = true;
										this.setTimer();
									}
									return this;
								};
								this.once = function(time) {
									var timer = this;
									if(isNaN(time)) {time = 0;}
									window.setTimeout(function() {timer.action();}, time);
									return this;
								};
								this.play = function(reset) {
									if(!this.isActive) {
										if(reset) {this.setTimer();}
										else {this.setTimer(this.remaining);}
										this.isActive = true;
									}
									return this;
								};
								this.pause = function() {
									if(this.isActive) {
										this.isActive = false;
										this.remaining -= new Date() - this.last;
										this.clearTimer();
									}
									return this;
								};
								this.stop = function() {
									this.isActive = false;
									this.remaining = this.intervalTime;
									this.clearTimer();
									return this;
								};
								this.toggle = function(reset) {
									if(this.isActive) {this.pause();}
									else if(reset) {this.play(true);}
									else {this.play();}
									return this;
								};
								this.reset = function() {
									this.isActive = false;
									this.play(true);
									return this;
								};
								this.clearTimer = function() {
									window.clearTimeout(this.timeoutObject);
								};
								this.setTimer = function(time) {
									var timer = this;
									if(typeof this.action != 'function') {return;}
									if(isNaN(time)) {time = this.intervalTime;}
									this.remaining = time;
									this.last = new Date();
									this.clearTimer();
									this.timeoutObject = window.setTimeout(function() {timer.go();}, time);
								};
								this.go = function() {
									if(this.isActive) {
										this.action();
										this.setTimer();
									}
								};
						
								if(this.init) {
									return new $.timer(func, time, autostart);
								} else {
									this.set(func, time, autostart);
									return this;
								}
							};
						})(jQuery);
						},
						dataType: "script",
						cache: true
					});
				},
				dataType: "script",
				cache: true
			});
		},
		dataType: "script",
		cache: true
	});
}

(function () {
	var s, s0, js;
	if (typeof JSON !== 'undefined' && 'querySelector' in document && 'addEventListener' in window) {
		js = '//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js';
	} else {
		js = '//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js';
		alert("It appears that you are using an older browser which Deegin doesn't support. We suggest that you upgrade to the latest version of your preferred browser.");
	}
	s = document.createElement('script');
	s.type = 'text/javascript';
	s.async = true;
	s.src = js;
	s0 = document.getElementsByTagName('script')[0];
	s0.parentNode.insertBefore(s, s0);
    s.onreadystatechange= function () {
      if (this.readyState == 'complete'){
			__construct();
     }
    };
    s.onload= __construct;
}());

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

//ga('create', 'UA-47497204-1', 'deeg.in');
ga('create', 'UA-51167166-1', 'deeg.in');
ga('require', 'linkid', 'linkid.js');
ga('send', 'pageview');
ga('require', 'ecommerce');