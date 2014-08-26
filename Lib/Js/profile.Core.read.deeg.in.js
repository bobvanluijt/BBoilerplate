function creditCardSetup(){
	$('#addCreditcard').click(function(){
		var dataFlow = $('#creditcardForm').serialize();
		$('#addCreditcard').toggle();
		jQuery.ajax({
		  type: "POST",
		  url: '/ajax.actions?i=validateCreditcard',
		  data: dataFlow,
		  success: function(dataReturn){
				if(dataReturn=='success'){
					alertify.success("Your card is added successfully.");
					setTimeout(function(){location.reload();},1400);
				} else {
					$('#addCreditcard').toggle();
					alertify.error("Something went wrong, please try again or contact our support team.");
				}
			},
		  dataType: 'html'
		});
	});
	
	$('#deleteCreditcard').click(function(){
		jQuery.ajax({
		  url: '/ajax.actions?i=removeCreditcard',
		  success: function(dataReturn){
				if(dataReturn=='success'){
					alertify.success("Your card is removed successfully.");
					setTimeout(function(){location.reload();},1400);
				} else {
					$('#addCreditcard').toggle();
					alertify.error("Something went wrong, please try again or contact our support team.");
				}
			},
		  dataType: 'html'
		});
	});
	
	$('.buyBulk').click(function(){
		var mainId = $(this).attr('id');
		var addAnimator = 0;
		
		if($(this).attr('id')=='buyBulk__1'){
			var textBuy = 'Do you want to update your account with $175 for $165?';
		} else if($(this).attr('id')=='buyBulk__2'){
			var textBuy = 'Do you want to update your account with $350 for $320?';
		} else if($(this).attr('id')=='buyBulk__3'){
			var textBuy = 'Do you want to update your account with $525 for $465?';
		} else if($(this).attr('id')=='buyBulk__4'){
			var textBuy = 'Do you want to update your account with $875 for $745?';
		} else {
			return;
		}
		
		alertify.confirm(textBuy, function (e) {
			if (e) {
				jQuery.ajax({
				  url: '/ajax.actions?i=buyBulk&v='+mainId,
				  success: function(dataReturn){
						if(dataReturn=='success'){
							alertify.success("Your order is done.");
							if(mainId=='buyBulk__1'){
								addAnimator = 175;
								ga('ecommerce:addTransaction', {
								  'id': 'buyBulk__1',
								  'affiliation': 'Deegin BULKBUY $175 for $165',
								  'revenue': '165.00',
								  'shipping': '0',
								  'tax': '0'
								});
							} else if(mainId=='buyBulk__2'){
								addAnimator = 350;
								ga('ecommerce:addTransaction', {
								  'id': 'buyBulk__2',
								  'affiliation': 'Deegin BULKBUY $350 for $320',
								  'revenue': '320.00',
								  'shipping': '0',
								  'tax': '0'
								});
							} else if(mainId=='buyBulk__3'){
								addAnimator = 525;
								ga('ecommerce:addTransaction', {
								  'id': 'buyBulk__3',
								  'affiliation': 'Deegin BULKBUY $525 for $465',
								  'revenue': '465.00',
								  'shipping': '0',
								  'tax': '0'
								});
							} else if(mainId=='buyBulk__4'){
								addAnimator = 875;
								ga('ecommerce:addTransaction', {
								  'id': 'buyBulk__4',
								  'affiliation': 'Deegin BULKBUY $875 for $745',
								  'revenue': '745.00',
								  'shipping': '0',
								  'tax': '0'
								});
							}
							ga('ecommerce:send');
							//
							//animate update
							//
							var numberCount = parseInt($('#accountBalance').val().substr(1));
							var endNumberCount = numberCount + addAnimator;
							animatorInterval = setInterval(function(){
								numberCount = numberCount+1;
								$('#accountBalance').val('$'+(numberCount)+'.00');
								if(numberCount==endNumberCount){
									clearInterval(animatorInterval);
								}
							}, 1);
						} else {
							alertify.error("Something went wrong, please try again or contact our support team.");
						}
					},
				  dataType: 'html'
				});
			} else {
				alertify.error("Your order is canceled.");
				return;
			}
		});	
		
	});
}

function __run(){
	//
	// First function to run, always __run()
	//
	addCornerstone();
	creditCardSetup();
	$('#radioOffline').buttonset();
}