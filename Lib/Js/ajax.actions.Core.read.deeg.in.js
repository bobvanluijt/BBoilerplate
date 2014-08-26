function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function setProjects(){
	$('.newProject').click(function(){
		var addToProject = $(this).text();
		$.ajax("/ajax.actions?i=addToProject&name="+addToProject+"&addTo="+getParameterByName('addTo')).done(function(data){
			if(data==1){
				window.parent.location.reload();
			} else {
				alert('fatal error updating');	
			}
		});
	});
}

function __run(){
	
}