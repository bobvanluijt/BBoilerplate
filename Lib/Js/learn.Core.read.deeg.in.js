function setClick(){
	$('h1').click(function(){
		$('.answer').css('display', 'none');
		$(this).parent().children('.answer').toggle();
	});
	$('#questionArea').click(function(){
		$(this).html('');	
	});
	$('#sendRequest').click(function(){
		$('#askQuestion').html('Thanks for your request');
	});
}

function setHashOpen(){
	if(location.hash.substr(1)!=""){
		$("#namespace__dashboard").trigger('click');
	}
}

function __run(){
	//
	// First function to run, always __run()
	//
	setClick();
	addCornerstone();
	setHashOpen();
}