({  // This function that reads the url parameter Lead Id
    // and retrieves Lead details
	init : function(component, event, helper) {
            console.log ('entered Init');
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
	
        var leadId  = getUrlParameter('LeadId');
     	//Get Lead details for Lead id
        var action = component.get("c.getLead");
        action.setParams({"leadId": leadId});

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
    
     // This function updates Lead on Final Registration Submit 
    updateLeadJs: function(component, event, helper) {
        console.log('entered Submit '+ component.get("v.areasYouWorkareasYouWorkValue"));
        var WorkareasYouWorkValue = component.get("v.areasYouWorkareasYouWorkValue"); 
        if(WorkareasYouWorkValue.length > 0){
            var WorkareasYouWorkValueString='';
            for (var i=0; i < WorkareasYouWorkValue.length; i++) {
                WorkareasYouWorkValueString += WorkareasYouWorkValue[i] +';';           
            }
            component.set("v.lead.Specify_the_areas_you_currently_work_in__c", WorkareasYouWorkValueString);
        }
        var WorkareasYouWorkpreviouslyValue = component.get("v.areasYouWorkareasYouWorkpreviouslyValue");
         if(WorkareasYouWorkpreviouslyValue.length > 0){
            var WorkareasYouWorkpreviouslyValueString='';
            for (var i=0; i < WorkareasYouWorkpreviouslyValue.length; i++) {
                WorkareasYouWorkpreviouslyValueString += WorkareasYouWorkpreviouslyValue[i] +';';           
            }
            component.set("v.lead.Specify_the_areas_previously_worked_in__c", WorkareasYouWorkpreviouslyValueString);
        }
        console.log(component.get("v.lead"));
        var validityChecker = [];
        var allIds = component.get("v.validationErrorIds");
        console.log('All Ids Val ',allIds[0].value);        
         for(var id in allIds){
            var comToCheck = component.find(allIds[id].value); 
            var validity = comToCheck.get('v.validity').valid;
            comToCheck.showHelpMessageIfInvalid();
             if(!validity){
                    validityChecker.push({
                        class: "valError",
                        value: allIds[id].value
                    });
            }
        }        
        if(validityChecker.length > 0){
            console.log('Validation failed');
        }
        else{
        var action = component.get("c.updateFinalRegLead");
        var finalRegLead = component.get("v.lead");
        console.log('finalRegLead ',finalRegLead);
        action.setParams({"finalRegLead": finalRegLead});
        action.setCallback(this, function(response) {
            var state = response.getState();
            //Redirect to Thank you submit form if Lead update is success
            if(component.isValid() && state == "SUCCESS"){
                console.log('Saved : '+response.getReturnValue());
                window.location.href = '/trade/s/thankyou?FormName=final' ;
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);
        }
    },
    //If ‘Yes’, specify the areas you work in currently
    showAnyCurrentWorkOrders: function(component, event, helper) {
        var anyCurrentWorkOrders = component.find("AnyCurrentWorkOrders").get("v.value");
        if (anyCurrentWorkOrders == 'Yes'){
            document.getElementById("AnyCurrentWorkOrders").style.display = 'Block';
        }else{
            document.getElementById("AnyCurrentWorkOrders").style.display = 'none';
        }
    },
    //If ‘Yes’, specify the areas you work in previously
    showAnyPreviousWork: function(component, event, helper) {
        var anyPreviousWork = component.find("AnyPreviousWork").get("v.value");
        if (anyPreviousWork == 'Yes'){
            document.getElementById("AnyPreviousWork").style.display = 'Block';
        }else{
            document.getElementById("AnyPreviousWork").style.display = 'none';
        }
    },
    
    //Show Whoreferedyou field if Referred is selcted as "Yes"
    showRefer: function(component, event, helper) {
       var selectedRefered = component.find("Referred").get("v.value");
        if (selectedRefered == 'Yes'){
            document.getElementById("Whoreferredyou").style.display = 'Block';
        }
    },
    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");     
    }
})