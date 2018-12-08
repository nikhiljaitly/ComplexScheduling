({
	lookUpABN : function(component, event, helper) {
		console.log('Enter Here')
		//var abn = component.find('abn');
		var abn = document.getElementById("00N5D000000iNGK").value;
		console.log('ABN'+abn);
		var action = component.get("c.getAbnCalloutResponseContents");
		action.setParams({ abnVal : abn });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                alert("From server: " + response.getReturnValue());
                var abnData = response.getReturnValue();
                abnData = JSON.parse(abnData);
                //console.log("From server: " + response.get("EntityName");
                console.log("Gst: " + abnData.Gst);
                console.log("Name: " + abnData.EntityName);
                document.getElementById("company").value = abnData.EntityName;
                //console.log("From server: " + response.get('EntityName'));

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},

	searchABNChange : function(component, event, helper) {
		console.log('Entered on change'); 
		var abnErrTarget = component.find('abnError');
		$A.util.addClass(abnErrTarget, 'slds-hide');
        var abnInactiveErrTarget = component.find('abnInactiveError');
        $A.util.addClass(abnInactiveErrTarget, 'slds-hide'); 				
		var abn = document.getElementById("00N5D000000iNGK").value;
		console.log('ABN'+abn);
		var abnLength = abn.length;
		console.log('LENGTH'+abnLength);
		if(abnLength < 11){
			console.log('Length too low');
			component.set("v.valError",true);
			//slds-has-error
			var abnFormTarget = component.find('abnForm');
			$A.util.addClass(abnFormTarget, 'slds-has-error');


			var cmpTarget = component.find('abnHelp');
			$A.util.removeClass(cmpTarget, 'slds-hide');

			
			document.getElementById("company").value = '';
			document.getElementById("gst").value = '';

		}
		else if(abnLength == 11){
			console.log('Length is correct');
			component.set("v.valError",false);
			document.getElementById("company").value = '';
			document.getElementById("gst").value = '';

			//slds-has-error
			var abnFormTarget = component.find('abnForm');
			$A.util.removeClass(abnFormTarget, 'slds-has-error');

			var cmpTarget = component.find('abnHelp');
			$A.util.addClass(cmpTarget, 'slds-hide');
			//callout
			var abnAction = component.get("c.getAbnCalloutResponseContents");
			abnAction.setParams({ abnVal : abn });			
			helper.getAbnDetails(component,abnAction);
		}		



	},

	validateForm : function(component, event, helper) {
		console.log('Entered submit');
		alert('Please correct all the errors')
		return true;
	}

})