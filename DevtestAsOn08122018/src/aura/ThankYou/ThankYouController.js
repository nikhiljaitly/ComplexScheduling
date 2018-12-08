({
	doInit: function(component, event, helper){
        console.log('Entered Thank You');
            // the function that reads the url parameters
            var getUrlParameter = function getUrlParameter(sParam) {
                var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                    sURLVariables = sPageURL.split('&'),
                    sParameterName,
                    i;

                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('=');

                    if (sParameterName[0] === sParam) {
                        return sParameterName[1] === undefined ? true : sParameterName[1];
                    }
                }
            };
		//console.log('URL Param'+getUrlParameter('type'));
		var formName = getUrlParameter('FormName');
		console.log('formName'+formName);
		console.log('Mattt');
		if(formName == 'initial'){

			console.log('Mattt');

			component.set("v.initialForm", true);

		}else{

			component.set("v.initialForm", false);

		}

        
    },
})