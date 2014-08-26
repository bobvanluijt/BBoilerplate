function loginButtons(){
	var delay = 0;
	$('.loginButton').each(function(index, element) {
        $(this).delay(delay).fadeIn(420);
		delay += 120;
    });
	$('.loginButton').click(function(){
		if($(this).hasClass('nosupport')){
			alert('Whoops, this login method is not setup yet...');	
		} else {
			var loginLocation = $(this).attr('rel');
			//loginLocation = loginLocation.charAt(0).toUpperCase() + loginLocation.slice(1).toLowerCase();
			window.location.assign('https://ajax.deeg.in/Lib/Hybridauth/login.php?i='+loginLocation);
		}
		
	});	
}

function showLoginScreen(){
	$('.login').css('display', 'block');
	$('#moreInfo').fadeOut('fast');
	$('#homepageShow').fadeOut('fast', function(){
		$('body').css('overflow', 'hidden');
		/*
		$('.topBlock').animate({
			height: "100%",
		}, { duration: 340, queue: false });
		*/
		$('.login').animate({
			top: "50%",
		}, { duration: 600, queue: false });
		setTimeout('loginButtons()', 600);
	});
	if($('#videoBackground').length){
		var useMeBlock = $('#videoBackground');
	} else {
		var useMeBlock = $('.topBlock');
	}
	useMeBlock.click(function(){
		$('#moreInfo').fadeIn('fast');
		$('#homepageShow').fadeIn('fast');
		$('.login').animate({
			top: "-400px",
		}, 600);
		$('body').css('overflow', 'auto');
	});
}

function otherButtons(){
	$('#Login_Button').click(function(e){
		showLoginScreen();
	});
}

function __run(){
	var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
	otherButtons();
	
	$('#mainCTA').click(function(){
		showLoginScreen();
	});
	
	
	/*
	if(!is_chrome){
		alert('Deegin is still in development, for the best experience please use the webbrowser Google Chrome to visit the website OR your mobile device.');	
	}
	*/
}