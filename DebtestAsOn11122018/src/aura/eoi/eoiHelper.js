({
	getAbnDetails : function(cmp,action) {

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                var abnData = response.getReturnValue();
                abnData = JSON.parse(abnData);
                //console.log("From server: " + response.get("EntityName");
                console.log("Gst: " + abnData.Gst);
                console.log("Name: " + abnData.EntityName);
                console.log("AbnStatus: " + abnData.AbnStatus);
                console.log("Message: " + abnData.Message);
                if(abnData.Message){
                	//alert("From server: " + abnData.Message);
                	console.log('Entereed Message');
                	cmp.set("v.valError",true);
                    var abnFormTarget = cmp.find('abnForm');
                    $A.util.addClass(abnFormTarget, 'slds-has-error');                        
 					var abnErrTarget = cmp.find('abnError');
					$A.util.removeClass(abnErrTarget, 'slds-hide'); 
					document.getElementById("company").value = '';              		
                }
                else{
                	if(abnData.AbnStatus != 'Active'){
                        cmp.set("v.valError",true);
                        var abnFormTarget = cmp.find('abnForm');
                        $A.util.addClass(abnFormTarget, 'slds-has-error');                       
                        var abnInactiveErrTarget = cmp.find('abnInactiveError');
                        $A.util.removeClass(abnInactiveErrTarget, 'slds-hide'); 
                        
                    }
                	if(abnData.AbnStatus == 'Active'){
                		console.log('Active');
                        document.getElementById("company").value = abnData.EntityName;
                		document.getElementById("gst").value = 'Active';
                	}
            	}
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
})