({
	init : function(component, event, helper) {
       // var recordId = component.get("v.recordId"); // "00Q5D000001MIfr"; // for demo purpose
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
	
        var recordId  = getUrlParameter('LeadId');
     
        var action = component.get("c.getLead");
        action.setParams({"recordId": recordId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var l = response.getReturnValue();
                console.log('Lead',l);                
                component.set("v.lead", l);   
                window.setTimeout(
                    $A.getCallback(function () {
                         component.set("v.isAvailable", true);
                    })
                );
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    updateLeadJs: function(component, event, helper) {
        var action = component.get("c.updateLead");
        var tradeLead = component.get("v.lead");
        action.setParams({"tradeLead": tradeLead});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                console.log('Saved : '+response.getReturnValue());
                component.set("v.isSaved", true);
            } else {
                component.set("v.isSaved", false);
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);
    },
})