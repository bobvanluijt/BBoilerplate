function gotoSearchPage(){
	location.assign("/dashboard");
}

function supportType(vidType,codType){ 
	myVid = document.createElement('video');
	isSupp = myVid.canPlayType(vidType+';codecs="'+codType+'"');
	if (isSupp==""){
		isSupp="No";
	}
	return isSupp;
} 

function __run(){
	//
	// First function to run, always __run()
	//
	$('#gotoNext').click(function(){
		if( $('#demo1').css('display')=='block' ){
			$('#gotoPrevious').closest('span').css('display', 'block');
			 $('.demoBox').css('display', 'none');
			 $('#demo2').css('display', 'block');
			 $('.ball').removeClass('selected');
			 $('#ball2').addClass('selected');
		} else if( $('#demo2').css('display')=='block'){
			 $('.demoBox').css('display', 'none');
			 $('#demo3').css('display', 'block');
			 $('.ball').removeClass('selected');
			 $('#ball3').addClass('selected');
		} else if( $('#demo3').css('display')=='block'){
			$('.demoBox').css('display', 'none');
			$('#demo4').css('display', 'block');
			$('.ball').removeClass('selected');
			$('#ball4').addClass('selected');
			$('#gotoNext').toggle();
		} else if( $('#demo4').css('display')=='block'){
			 gotoSearchPage();
		}
	});
	
	$('#gotoPrevious').click(function(){
		if( $('#demo2').css('display')=='block' ){
			$('#gotoPrevious').closest('span').css('display', 'none');
			 $('.demoBox').css('display', 'none');
			 $('#demo1').css('display', 'block');
			 $('.ball').removeClass('selected');
			 $('#ball1').addClass('selected');
		} else if( $('#demo3').css('display')=='block'){
			 $('.demoBox').css('display', 'none');
			 $('#demo2').css('display', 'block');
			 $('.ball').removeClass('selected');
			 $('#ball2').addClass('selected');
		} else if( $('#demo4').css('display')=='block'){
			$('.demoBox').css('display', 'none');
			$('#demo3').css('display', 'block');
			$('.ball').removeClass('selected');
			$('#ball3').addClass('selected');
			$('#gotoNext').toggle();
		}
	});
	
	$('#gotoDeegin').click(function(){
		gotoSearchPage();
	});
	
	//
	//animate deegin
	//
	$('body').css('overflow','none');
	$('#animation1').animate({  textIndent: 0 }, {
		step: function(now,fx) {
		  	$(this).css('display','block');
			$(this).css('-webkit-transform','rotate('+now+'deg)');
			$(this).css('-moz-transform','rotate('+now+'deg)');
			$(this).css('-o-transform','rotate('+now+'deg)');
			$(this).css('-ms-transform','rotate('+now+'deg)');
			$(this).css('transform','rotate('+now+'deg)');
		},
		duration:900,
		complete: function() {
			$('#animation2').fadeIn(120, function(){
				$('#animation3').fadeIn(120, function(){
					$('#animation4').fadeIn(120, function(){
						$('#animation5').fadeIn(120, function(){
							$('#animation6').fadeIn(160, function(){
								$('#animation7').css('width', '1200px');
								$('#animation7').css('height', '1011px');
								$('#animation7').toggle();
								$('#animation7').animate({
									width:'400px',
									height:'338px',
									left:'0px',
									top:'0px'
								},
								210, function(){
									$('body').css('overflow','auto');	
									//$('#container').fadeIn(210, function(){
										$('#container').fadeIn(1210);
										$('#demo1').fadeIn(1210);
										$('#animationBox').fadeOut(1210);
									//});
								});
							});
						});
					});
				});
			});
		}
	},'linear');
	
	//
	//add video
	//
	if(supportType(
	'video/mp4','avc1.42E01E, mp4a.40.2')=='no'){
		$('#video1').html('<img src="/Lib/Img/demo01.gif" style="width:300px">');
		$('#video2').html('<img src="/Lib/Img/demo02.gif" style="width:500px">');
		$('#video3').html('<img src="/Lib/Img/demo03.gif" style="width:500px">');
		$('#video4').html('<img src="/Lib/Img/demo04.gif" style="width:500px">');		
	} else {
		$('#video1').html('<video width="300" autoplay="autoplay" loop controls><source src="/Lib/Vid/demo01.mp4" type="video/mp4"></video>');
		$('#video2').html('<video width="500" autoplay="autoplay" loop controls><source src="/Lib/Vid/demo02.mp4" type="video/mp4"></video>');
		$('#video3').html('<video width="500" autoplay="autoplay" loop controls><source src="/Lib/Vid/demo03.mp4" type="video/mp4"></video>');
		$('#video4').html('<video width="500" autoplay="autoplay" loop controls><source src="/Lib/Vid/demo04.mp4" type="video/mp4"></video>');
	}
}