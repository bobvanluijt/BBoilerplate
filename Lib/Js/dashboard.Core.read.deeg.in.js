function numberWithCommas(x) {
    x = x.toString();
    var pattern = /(-?\d+)(\d{3})/;
    while (pattern.test(x))
        x = x.replace(pattern, "$1,$2");
    return x;
}

function addTextOptions(){
	//
	//empty
	//
}

function animateImage(){
	$("#userImage").animate({
		opacity: "1",
		width: "150px"
	}, "fast", function(){
		addTextOptions();
	});
}


var searchPage = 0;
function addScrollOption(){
	//
	// check for scrollbottom and adds auto
	//
	searchPage = parseInt($('#resultCounter').val());
	if(parseInt($('#resultCounter').val())<50){
		$.ajax({ url:"//read.deeg.in/search.ajax?p="+searchPage+"&i="+$("#searchText").val()+"&addAll=false&type="+$('#kindOfSearch').val(), cache:false }).done(function(dataset) {
			addDataSetsPost(dataset);
			addAbstracts();
			addScrollOption();
		});
	}
}

function addAbstracts(){
	
	$('.ui-state-deegin-nocheck').each(function(index, element) {
		
		$('.ui-state-deegin-nocheck').removeClass('ui-state-deegin-nocheck');
		
		var currentView = $(element);
	
		$('.projectTitle h2').css('color', '#F90');
	
		$.ajax({ url:"//read.deeg.in/ajax.actions?i=searchAbstract&Pii="+$(element).attr('id'), cache:false })
		.done(function(dataAbstract){							
			$(currentView).find(".moreInfo").html(dataAbstract);	
			
			$('.addToLib').click(function(e) {
				e.preventDefault();
				if($(element).closest('li').attr('id')!='undefined'){
					$.ajax({ url:"//read.deeg.in/ajax.actions?i=addToLib&Pii="+$(element).closest('li').attr('id'),
							 cache:false });
					$(element).closest('span').remove();
				}
			});
			
			//
			//check ownership and if payed
			//
			$.ajax({ url:"//read.deeg.in/ajax.actions?i=ownerShip&Pii="+$(currentView).attr('id'), cache:false })
			.done(function(ownerShip){
				if(ownerShip=='lib'){
					$(currentView).find('.isInLib').remove();
				} else if(ownerShip=='own'){
					$(currentView).find('.isInLib').remove();
					$(currentView).find('.isInOwn').remove();	
				}
			});
			
			/*
			$(currentView).dblclick(function(){
				window.location.assign('/view?i='+$(currentView).closest('li').attr('id'));
			});
			*/
			
			$(currentView).click(function(){
					
					$('#searchResultsAbstract').animate({
						right:'0px'
					}, "fast");
					$('.cornerstone').toggle();
					
					
					
					if($(currentView).find(".openaccess").length){
						var documentReadText = 'read the full article';
					} else {
						var documentReadText = 'buy or rent this article';
					}
					
					
					
					$('#searchResultsAbstract').html('<h1>'+$(currentView).find(".projectTitle").text()+'</h1><h2>'+$(currentView).find(".projectDesc").eq(1).text()+'</h2>'+dataAbstract+'<div id="searchResultsAbstractMore"><a href="/view?i='+$(currentView).closest('li').attr('id')+'" target="_self">'+documentReadText+'</a></div><div id="searchResultsAbstractBottom"><!--empty--></div>');
					
					
					
					$('#searchResultsAbstractMore').prepend('<div id="closeThisTab">X</div>');
					$('#closeThisTab').click(function(){
						$('#searchResultsAbstract').animate({
							right:'-300px'
						}, "fast");
						$('.cornerstone').toggle();
					});
					
					/*/	
					
					//
					// send directly to article if selected
					//
					if($(currentView).hasClass("ui-state-deegin-clicked")){
						window.location.assign('/view?i='+$(currentView).closest('li').attr('id'));
					}
					
					$(".ui-state-deegin").removeClass("ui-state-deegin-clicked");
					$(currentView).addClass("ui-state-deegin-clicked");
					
					/*/	
			});
			
		});
		
	});
}


function addDataSetsPost(dataset){
	if(parseInt($('#resultCounter').val())<50){
		$('#sortable').append(dataset);
		$('#resultCounter').val(parseInt($('#resultCounter').val())+1);
	}
}

function addDataSets(dataset, addTo){
	
	$(".topBlock").animate({
		height: "0px"
	}, "fast", function(){
		
		$(".topBlock").html(""); //empty topblock
		
		$('#header').animate({
			top: "-46px"
		}, "slow");	
		
		$('#search').animate({
			top:"-190px"
		}, "fast");
		
		$('#search h1').remove();
		
		$("#searchText").animate({
			marginTop: "8px"
		}, "fast", function(){
			if(addTo!='#container'){
				$('#container').html('');
			}
			$('#container').css('top', '8px');
			$('#container').css('display', 'block');
			$('body').css('overflow','visible');
			
			$(addTo).append(dataset);
			$('#resultCounter').val(parseInt($('#resultCounter').val())+1);
			addAbstracts();
			
			var delay = 200;
			$(".searchResult").each(function(index) {
				delay = delay + 120;
				$(this).delay(delay).fadeIn(200);
			});
			
			//
			//add scroll option
			//
			addScrollOption();
			
		});
		$('#searchResults').text('');
	});	
}

function searchText(){
	var opened = false;

	$('#searchText').keyup(function(e) {
        if(e.which == 13) {
			$('#resultCounter').val('0');
			var param = { q: $('#searchText').val() };
			window.location.assign("#!"+$.param(param));
			
			$(this).blur();
			if(opened===false){
				if($('.topBlock').css('height')=='0px'){
					$('.topBlock').css('position', 'fixed');
					$('#container').toggle();
					$('.footer').toggle();
					//$('#elsevierLogoSearch').toggle();
					$('#searchText').css('background-color', '#CCC');
					$('#searchText').css('color', '#000');
					$('#search').animate({
						top:'14px'
					}, "fast");
					//
					// edit for topblock
					// 
					$('.topBlock').animate({
						height:$(window).height()
					}, "fast", function(){
						$('#header').animate({
							top: "46px"
						}, "slow");	
					});
				}
				opened = true;
			
				$('#searchResults').text('Searching...');
				
				/*
				$("#searchResults").cooltext({
				   sequence:[
					  {action:"animation", animation:"cool12", speed:180, stagger:540}
				   ]
				});
				*/
			} else {
				$('#container').fadeOut("fast");	
			}
			
			//
			//Do the actual AJAX search
			//
			$.ajax({ url:"//read.deeg.in/search.ajax?i="+$(this).val()+"&addAll=true&type="+$('#kindOfSearch').val(), cache:false }).done(function(dataset) {
				$('#container').html('');	
				addDataSets(dataset, '#container');	
			});
		}
    });
	
}

function __run(){
	//
	// First function to run, always __run()
	//
	if(location.hash.substr(1)=='!load'){
		animateImage();
		location.hash = '';
	} else {
		//addTextStripped();
		//$('.topBlock').css('height', '100%');
		$('#search').toggle();
		$('#container').toggle();
		$('.footer').toggle();
		addCornerstone();
	}
	$('.listItem').click(function(){
		elapse = 50;
		$('listItem').each(function(index, element) {
            $(element).fadeOut(elapse);
			elapse = elapse + 50;
        });
		loadUrl($(this).attr('rel'));
	});
	searchText();
	//
	//check if #!q is set
	//
	if(getUrlVars()["!q"]){
		$('#searchText').val(getUrlVars()["!q"]);
		var e = jQuery.Event("keyup");
			e.which = 13;
		$('#searchText').trigger(e);
	}
	
	//
	//enable search button
	//
	$('#theSearchButton').click(function(){
		if($('#searchText').val()!=''){
			var e = jQuery.Event("keyup");
			e.which = 13;
			$('#searchText').trigger(e);
		}
	});
	
}