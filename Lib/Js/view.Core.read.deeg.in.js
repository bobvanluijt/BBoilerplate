window.highlight = function(id) {
    var selection = window.getSelection().getRangeAt(0);
    var selectedText = selection.extractContents();
    var span = $("<span class='highlight'>" + selectedText.textContent + "</span>");
    selection.insertNode(span[0]);
   
    if (selectedText.childNodes[1] != undefined){
        //console.log(selectedText.childNodes[1]);
        $(selectedText.childNodes[1]).remove();
    }
    
    var txt = $(id).html();
    $(id).html(txt.replace(/<\/span>(?:\s)*<span class="highlight">/g, ''));
     clearSelection();
}

function clearSelection() {
    if ( document.selection ) {
        document.selection.empty();
    } else if ( window.getSelection ) {
        window.getSelection().removeAllRanges();
    }
}

//
// setup type of color ( $('#box').lightOrDark(); )
//
(function($){
  
  $.fn.lightOrDark = function(){
    var r,b,g,hsp
      , a = this.css('background-color');
    
    if (a.match(/^rgb/)) {
      a = a.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+(?:\.\d+)?))?\)$/);
      r = a[1];
      b = a[2];
      g = a[3];
    } else {
      a = +("0x" + a.slice(1).replace( // thanks to jed : http://gist.github.com/983661
          a.length < 5 && /./g, '$&$&'
        )
      );
      r = a >> 16;
      b = a >> 8 & 255;
      g = a & 255;
    }
    hsp = Math.sqrt( // HSP equation from http://alienryderflex.com/hsp.html
      0.299 * (r * r) +
      0.587 * (g * g) +
      0.114 * (b * b)
    );
    if (hsp>127.5) {
      return 'light';
    } else {
      return 'dark';
    }
  }
  
})(jQuery);

//
// Special setup for selection START
//
function getHTMLOfSelection() {
      var range;
      if (document.selection && document.selection.createRange) {
        range = document.selection.createRange();
        return range.htmlText;
      }
      else if (window.getSelection) {
        var selection = window.getSelection();
        if (selection.rangeCount > 0) {
          range = selection.getRangeAt(0);
          var clonedSelection = range.cloneContents();
          var div = document.createElement('div');
          div.appendChild(clonedSelection);
          return div.innerHTML;
        }
        else {
          return '';
        }
      }
      else {
        return '';
      }
}

function addRightclickMenu(){
	$('.article').append('<div id="littleMenu"><div class="bfh-colorpicker" data-name="colorpicker1">Color</div><div style="position:absolute; left:27px; top:4px;"><a href="#" id="highlight">Highlight</a> | Paragraph note | Inline note | Url | Reference</div></div>');	
}
	
function wrapText(offset, length){
    $(".article").html(function(i,oldHtml) {
        return oldHtml.substr(0,offset) +
               '<span class="articleSelection">' +
               oldHtml.substr(offset, length) +
               "</span>" +
               oldHtml.substr(offset + length);
    });
}

function addMenu(){
	var position = $('#menuStarter').position();
	if($("#littleMenu").css('display')=='none'){
		$("#littleMenu").css('display', 'block');
		$(".bfh-colorpicker").bfhcolorpicker();
		$(".form-control").css('display', 'none');
		$(".bfh-colorpicker").css("display", "inline");
		$(".bfh-colorpicker-popover").change(function(){
			alert('heij');	
		});
	}
	$('.article').click(function(){
		if($("#littleMenu").css('display')=='block'){
			$("#littleMenu").fadeOut(200);	
		}
	});
	$("#littleMenu").animate({
		top: (position.top-48)+'px',
		left: position.left+'px'
	}, 200);
	$('#menuStarter').remove();
}

function rightMouse(){
	var i = 1;
	var currentCount = 1;
	$('.para').mouseup(function(e){
		var fullPara = $(this).html();
		var fullSelection = getHTMLOfSelection();
		var before = fullPara.slice(0, fullPara.search(fullSelection));
		var after = fullPara.slice(fullPara.search(fullSelection));
		var isThereChange = false;
		$('.articleSelection').each(function(index, element) {
            //if(!$(this).hasClass('changed')){
			//	$(this).unwrap('.articleSelection');
			//}
        });
		if(fullSelection!=''){
			if((fullPara.split(fullSelection).length - 1) < 2){
				if((fullSelection.split('paraCount__').length - 1) > 0){
					//find if there is a para in there, if so remove it and reset
					var chk = '<div>'+fullSelection+'</div>';
					var idToRemove = $(".articleSelection", chk).attr('id');
					//var textUnwrapped = $('#'+idToRemove).contents().unwrap();
					$("#"+idToRemove).contents().unwrap();
					fullPara = $(this).html();
				}
				$(this).addClass('edited').addClass('active');
				currentCount = 'paraCount__' + i++;
				$(this).html(fullPara.replace(fullSelection, '<span id="menuStarter"></span><span class="articleSelection" id="'+currentCount+'">'+fullSelection+'</span>'));
			}
		}
		addMenu();
		return false;
	});
	$('#highlight').click(function(e){
		e.preventDefault();
		$('#'+currentCount).css('background-color', $('.bfh-colorpicker-icon').css('background-color'));
		if($('#'+currentCount).lightOrDark()=='light'){
			$('#'+currentCount).css('color', '#000');
		} else {
			$('#'+currentCount).css('color', '#FFF');
		}
		$('#'+currentCount).addClass('changed');
	});
}
//
// Special setup for selection END
//

function colapseAll(){
	//$('.abstract').toggle();
	$('.abstract h2').css('cursor', 'pointer');
	$('.abstract h2').click(function(){
		$('.abstract .para').toggle();
	});
	//$('.keywords').toggle();
	$('.keywords h2').css('cursor', 'pointer');
	$('.keywords h2').click(function(){
		$('.keywords .keyword').toggle();
	});
	
	//
	// disables HRs
	// 
	$('hr').css('display', 'none');
	
}

function purchaseArticle(){
	if ($(".purchaseArticle").length > 0) {
		$(".purchaseArticle").click(function(){
			if($(this).attr('id')=='try'){
				var text = 'try (one hour) '; 
				var amount = '$0.00';
			} else if($(this).attr('id')=='rent'){
				var text = 'rent (one week) ';
				var amount = '$5.00';
			} else if($(this).attr('id')=='buy'){
				var text = "buy";
				var amount = '$'+$('#buyVal').val();
			}
			var Pii  = $(this).attr('rel');
			var Type = $(this).attr('id');	
			$.ajax("/ajax.actions?i=purchaseText&type="+Type+"&Pii="+Pii).done(function(dataText) {
				alertify.confirm(dataText, function (e) {
					if (e) {
						alertify.set({ delay: 1600 });
						alertify.success("Validating you purchase");
						$.ajax("/ajax.actions?i=purchase&type="+Type+"&Pii="+Pii).done(function(data) {
							if(data.substr(0,4)=='true'){
								matches = data.match(/\[(.*?)\]/);
								if (matches) {
									//
									//add Google Analytics
									//
									$.ajax("/ajax.actions?i=lastPurchase").done(function(lastPurData) {
										ga('ecommerce:addTransaction', {
										  'id': lastPurData,
										  'affiliation': 'Deegin Article ('+Pii+')',
										  'revenue': parseFloat(Math.round((matches[1]/100) * 100) / 100).toFixed(2),
										  'shipping': '0',
										  'tax': '0',
										  'currency': 'USD'
										});
										ga('ecommerce:send');
										ga('ecommerce:clear');
										alertify.success("You've purchased: "+$('#mainTitle').text());
										setTimeout(function(){
											location.reload();
										}, 1400);
									});
								}
							} else {
								if(data=='outOfTokens'){
									alertify.error("You don't have enough credits left.");
									tb_show('','/ajax.actions.php?i=buyTokens&TB_iframe=false&width=280&modal=false');	
								} else {
									alertify.error("Something went wrong...");
								}
							}
						}).fail(function() {
							alertify.error("Something went wrong...");
						});
					} else {
						alertify.error("No purchase...");
					}
				});
			});
		});
	}
}

function addNote(){
	var offset;
	var left;
	var top;
	$('body').append('<div class="panelRight">&nbsp;</div>');
	$('body').append('<div class="noteLink"><img src="/Lib/Icons/Open/add.png" class="noteLinkImg"></div>');	
	$('.noteLink').click(function(){
		setPanelRight();	
	});
	$('.para').mouseover(function(){
		offset = $(this).offset();
		left = offset.left + $(this).width() + 28;
		top = offset.top;
		if($(window).scrollTop() > top){
			top = top + ($(window).scrollTop()-top) + 4;	
		}
		//console.log('I: '+$(this).attr('id'));
		//$('.noteLink').attr('rel', $(this).attr('id'));
		$('.noteLink').css('display', 'block');
		$('.noteLink').animate({
			left: left+"px",
			top: top+"px"
		}, "fast");
	});
}

function disableAll(){
	$('.panelRight').remove();
	$('.noteLink').remove();
}

function addHighlight(){
	$('.para').mouseup(function(){
		if(window.getSelection()){
			highlight('#'+$(this).attr('id'));
		}
	});
}

function articleOptionsPanel(){
	if($('#isAbstract').length!=1){
		/*
		$('.panel').append('<table class="extraMenuTable"><tr><td style="width:53%"><div id="articleTypeRadio"><input type="radio" id="articleTypeRadio1" name="articleTypeRadio" checked="checked"><label for="articleTypeRadio1">Read</label><input type="radio" id="articleTypeRadio3" name="articleTypeRadio"><label for="articleTypeRadio3">Edit</label></div></td><td style="vertical-align:middle;"><div id="fontSlider"></div></td></tr></table>');
		$( "#fontSlider" ).slider({
		  value:22,
		  min: 12,
		  max: 30,
		  step: 1,
		  slide: function( event, ui ) {
				$(".para").css('font-size', ui.value+'px');
		  }
		});
		$('#articleTypeRadio').buttonset();
		$("input[name='articleTypeRadio']").change(function() {
			if( $("input[name='articleTypeRadio']:checked").attr('id')=='articleTypeRadio1' ){
				//read
				disableAll();
				$('.para').attr('contenteditable', 'false');
			} else if( $("input[name='articleTypeRadio']:checked").attr('id')=='articleTypeRadio2' ){
				//review
				//addNote();
				//addRightclickMenu();
				//rightMouse();
				//$('.para').attr('contenteditable', 'false');
				//$('.para').get().hideFocus = true;
			} else if( $("input[name='articleTypeRadio']:checked").attr('id')=='articleTypeRadio3' ){
				//edit
				addNote();
				addHighlight();
				//addRightclickMenu();
				//rightMouse();
				//$('.para').attr('contenteditable', 'false');
				//$('.para').get().hideFocus = true;	
			}
			setPanel();
		});
		*/
	}
}

function saveNote(returner){
	$.post("/ajax.actions?i=saveNote", { noteId: getParameterByName('i'), noteTitle: $('#mainview > h1').text(), noteContent: $('.para').html() } ).done(function(data){
	}, function(){
		if(returner===true){
			window.location.assign("/reader")
		} else {
			alertify.success("Saved to your Reader");	
		}
	});
}

function setEdit(){
	var name = getParameterByName('i');
	    nameType = name.substr(0,1);
		if(nameType=='N'){
			//
			// Set a note to edit.
			//
			$('extraMenuTable').css('display', 'none');
			/*
			$('#articleTypeRadio3').prop('checked',true);
			$('#articleTypeRadio').buttonset("refresh");
			//edit
			addNote();
			addRightclickMenu();
			rightMouse();
			*/
			$('#mainview > h1').attr('contenteditable', 'true');
			$('#mainview > h1').get().hideFocus = true;
			$('.para').attr('contenteditable', 'true');
			$('.para').get().hideFocus = true;
			$('#articleTypeRadio').css('display', 'none');
			
			$('#saveThisNoteButton').click(function(){
				saveNote(false);
			});
			
			$('#saveThisNoteReturnButton').click(function(){
				saveNote(true);
			});
					
			
		}
}

function setArticleOverview(){
	/*
	if(!$('#articleOverview').length){
        $('.panel').append('<div id="articleOverview">&nbsp;</div>');
    }
	$.ajax({
		url: '/ajax.lib',
		dataType: "html",
		cache:false,
		success: function(data){
			$('#articleOverview').html(data);
			$('.singleArticle').each(function(index, element) {
            	$(this).click(function(){
					var urlArticle = '/view?i='+$(element).attr('id').replace('singleArticle_', '');
					$('#mainView').load(urlArticle+' #mainView');
				});
            });
		}
	});	
	*/
}

function getPrice(){
	//
	// update price via AJAX
	//
	if($('#buyVal').length){
		var Pii = $('#buy').attr('rel');
		$.ajax({
			url: '/ajax.actions?i=getPrice&pii='+$('#buy').attr('rel'),
			cache:false,
			success: function(data){
				$('#buyVal').val(data);
				$('#buy').remove();
				$('.mainPurchaseBlock').append('<button class="purchaseArticle" id="buy" rel="'+Pii+'" style="width:140px;height:140px">Buy now for $'+data+'</button>');
				purchaseArticle();
			}
		});
	}
}

function isOpenAccess(){
	var Pii = getParameterByName('i');
	$.ajax("/ajax.actions?i=accessType&Pii="+Pii).done(function(dataText) {
		if(dataText=='1'){
			$('#mainView').prepend('<span id="bigOpenAccess" class="projectViewSingle openaccess" style="font-size:22px;"><img src="/Lib/Img/OA.png" class="libImageTitle" style="width:18px;height:18px">open access</span>');	
		}
	});	
}

function __run(){
	//
	// First function to run, always __run()
	//
	document.title = 'Deegin Article';
	//$.getScript('//ajax.deeg.in/min/index?f=/Lib/Js/bootstrap-formhelpers.min.js');
	addCornerstone('view');
	colapseAll();
	//purchaseArticle();
	articleOptionsPanel();
	setEdit();
	setArticleOverview();
	getPrice();
	isOpenAccess();
}