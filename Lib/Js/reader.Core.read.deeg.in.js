jQuery.fn.selectText = function(){
   var doc = document;
   var element = this[0];
   if (doc.body.createTextRange) {
       var range = document.body.createTextRange();
       range.moveToElementText(element);
       range.select();
   } else if (window.getSelection) {
       var selection = window.getSelection();        
       var range = document.createRange();
       range.selectNodeContents(element);
       selection.removeAllRanges();
       selection.addRange(range);
   }
};

var oldE;
function clickProjectBox(e){
	oldE = e;
	$('body').append('<div class="projectManagerDark">&nbsp;</div><div class="projectManager"></div>');
	$.ajax("/ajax.actions?i=showProjects&Pii="+$(this).closest('li').attr('id')).done(function(data) {
		$('.projectManager').html(data);
		$('.projectBox').click(function(){
			if($(this).text()=='+'){
				alertify.prompt("Name of the project", function (e, str) {
					if(e) {
						if(e!=''){
							$.post("/ajax.actions?i=createProject", { v:str, color:get_random_color() }, function(){
								$('.projectManagerDark').remove();
								$('.projectManager').remove();
								clickProjectBox(oldE);
								alertify.success("Project "+str+" created");
								
							});
						}
					} else {
						alertify.log("No project created");
					}
				}, "");
			} else {
				var PiiToAdd = $(this).attr('rel');
				$.get("/ajax.actions?i=projectEnabeler&Pii="+e+"&type=on&project=project_"+PiiToAdd, function(){
					
					$('.projectManagerDark').fadeOut("fast");
					$('.projectManager').fadeOut("fast", function(){
							location.reload();
							$('.projectManagerDark').remove();
							$('.projectManager').remove();
					});	
				});
			}
		});
		$('.projectManagerDark').click(function(){
			$('.projectManagerDark').fadeOut("fast");
			$('.projectManager').fadeOut("fast", function(){
					$('.projectManagerDark').remove();
					$('.projectManager').remove();
			});
		});
	});
}

function setDrag(){
	$( "#sortable" ).sortable({
      placeholder: "ui-state-highlight",
	  connectWith: ".ui-state-deegin",
      handle: ".handle"
    });
    $( ".ui-state-deegin" ).click(function(){
		
		if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
			if($(this).attr('id').length){
				window.location = '/view.php?i='+$(this).attr('id');	
			}
		} else {
		
			if($(this).find("input[name='select']").prop('checked')===true){
				$(this).find("input[name='select']").prop('checked', false);
				$(this).removeClass('ui-selected');
			} else {
				$(this).find("input[name='select']").prop('checked', true);
				$(this).addClass('ui-selected');
			}
			$('#download_PDF').css('display', 'none');
			$('#remover').css('display', 'none'); 
			var num = 0;
			$('#container').find("input[name='select']").each(function(index, element) {
			   if($(element).prop('checked')===true){
					$('#download_PDF').css('display', 'inline');
					$('#remover').css('display', 'inline');   
					num++;
			   }
			});
			var newstr = $('#download_PDF').html();
			$('#download_PDF').html( newstr.replace(/\[(.+?)\]/g, "["+num+"]") );
			var newstr = $('#remover').html();
			$('#remover').html( newstr.replace(/\[(.+?)\]/g, "["+num+"]") );
		}
	});
	
	$('#download_PDF').click(function(){
		alertify.alert("Your files are in the queue for creation, you will receive an email when the ZIP file is ready to download");
	});
	
	$('#remover').click(function(){
		alertify.confirm("Are you sure you would like to remove these?", function (e) {
			if(e){
				$( ".ui-state-deegin" ).each(function(index, element) {
					if($(element).find("input[name='select']").prop('checked')===true){
						$.get("/ajax.actions?i=remove&Pii="+$(element).attr('id'), function(){
							$(element).remove();
						});
					}
                });
			}
		});	
	});
	
	$(".ui-state-deegin").dblclick(function() {
		if($(this).attr('id').length){
			window.location = '/view.php?i='+$(this).attr('id');	
		}
	});
	$(".projectViewSingle").click(function(event){
		var Pii = $(this).closest('li').attr('id');
		var ProjectId = $(this).attr('rel');
		var aboutToRemove = $(this);
		if( $(this).text()=='+project' ){
			event.stopPropagation();
			var projectClick = $(this).text();
			var addTo =  $(this).closest('li').attr('id');
			if(projectClick=='+project'){
				projectClick = '[add]';	
			}
			clickProjectBox($(this).closest('.ui-state-deegin').attr('id'));
		} else {
			alertify.confirm("Remove this article from project '"+$(this).text()+"'?<br>", function (e) {
				if(e) {
					$.get("/ajax.actions?i=projectEnabeler&Pii="+Pii+"&type=off&project=project_"+ProjectId, function(){
						aboutToRemove.remove();
					});
					alertify.log($(this).text()+" removed");
				}
			});	
		}
	});
}

function setRemove(){
	$('.remove').click(function(event){
		var currentRemove = $(this);
		event.stopPropagation();
		alertify.confirm("Are you sure you want to remove this title from your library? You can always add it later by searching for it.", function (e) {
				if(e) {
					$(currentRemove).closest('li').animate({ "height": "0px", "opacity": "0"}, "slow", function(){
						$(currentRemove).closest('li').remove();	
					});
					alertify.success('Removed');	
				}
		});
	});
}

function setDropdown(){
	$('.headerButton').button();
	$('#download').buttonset();
	
	$('#createNote').click(function(){
		window.location.assign("/view?i=N");
	});
	
	var showPandT = false;
	$('#showPandT').click(function(){
		if(showPandT==true){
			$('#projectsMenu').toggle();
			showPandT = false;	
		} else {
			
			if($('#projectsMenu').length){
				$('#projectsMenu').toggle();
			} else {
			
				$('#container').append('<div id="projectsMenu">&nbsp;</div>');
				
				var elementText = new Array();
				$('.projectViewSingle').each(function(index, element) {
					elementText.push($(element).text());
				});
				var elementTextHist = {};
				elementText.map( function (a) { if (a in elementTextHist) elementTextHist[a] ++; else elementTextHist[a] = 1; } );
				for (var key in elementTextHist) {
					if(key!='+project'){
						var color;
						$('.projectViewSingle').each(function(index, element) {
							if($(element).text()==key){
								color = $(element).css('background-color');
								return;	
							}
						});
						$('#projectsMenu').append('<div class="projectsMenuOption projectViewSingle" style="background-color:'+color+'!important;"><input class="selectProjects" type="checkbox" checked="checked"><span style="padding-left:6px">'+key+'</span></div>');
					}
				}
				$('#projectsMenu').append('<div class="projectsMenuOption projectViewSingle" style="background-color:grey!important;"><input class="selectProjects" type="checkbox" checked="checked"><span style="padding-left:6px">untagged</span></div>');
	
				var enable;
				var disable;
				$('.selectProjects').click(function(){
					//
					//here the actual selection.
					//
					var onOff; //false = display none
					$('.ui-state-deegin').each(function(index, element) {
						onOff = false;
						$(element).find('.projectViewSingle').each(function(index2, element2) {
							var currentText = $(element2).text();
							if(currentText!='+project'){
								$('.projectsMenuOption').each(function(index3, element3) {
									if( $(element3).find('span').text() == currentText){
										if(	$(element3).find('.selectProjects').prop('checked') ){
											onOff = true;	
										}
									}
								});
							}
							
							//if nothing put back on
							if($(element).find('.projectViewSingle').length==1){
								onOff = true;
								$('.projectsMenuOption').each(function(index, element) {
									if( $(element).find('span').text() == 'untagged'){
										if(	!$(element).find('.selectProjects').prop('checked') ){
											onOff = false;	
										}
									}
								});
							}
						});
						if(onOff===true){
							$(element).css('display', 'block');
						} else if(onOff===false){
							$(element).css('display', 'none');
						}
					});
				});
				
				var position = $(this).position();
				$('#projectsMenu').css('left', position.left);
				$('#projectsMenu').css('top', (position.top+25));
				showPandT = true;	
			}
		}
	});
	
	$('#showPandT').click(function(){
		//tb_show('body','/read.actions.php?i=project&val='+projectClick+'&TB_iframe=true&width=280&modal=true');	
	});
}

function setEditable(){
	if(!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
		$('.projectDesc').attr('contenteditable', 'true');
		$('.projectDesc').click(function(event){
			event.stopPropagation();
			var resetText = $(this).text();
				resetText = resetText.replace(/\s+/g, ''); //remove spaces
			if(resetText=='Description...'){
				$(this).text('');
			}
			$(this).selectText();
		});
		var jqxhr;
		$('.projectDesc').keyup(function(){
			jqxhr = $.post("/ajax.actions?i=addDescription", { pii: $(this).closest('li').attr('id'), text: $(this).text() }, function(data){
				//succes, nothing for now
			});
		});
		$('.projectDesc').keydown(function(){
			try {
				jqxhr.abort();
			} catch(e){
				//nothing for now	
			}
		});
		$('.projectDesc').keypress(function(e){ return e.which != 13; });
	}
}

function setReaderhelp(){
	$('#readerHelp').click(function(){
		alertify.confirm("Do you want to visit the help page?", function (e) {
			if(e) {
				window.location.assign("/learn#namespace__dashboard");
			}
		});
	});
}

function __run(){
	//
	// First function to run, always __run()
	//
	addCornerstone();
	setDrag();
	setRemove();
	setDropdown();
	setEditable();
	setReaderhelp();
}