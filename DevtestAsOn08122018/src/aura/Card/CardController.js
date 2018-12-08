({
    doInit : function(component, event, helper) {
        // Clear data in value map
        component.set("v.sections", []);
        component.set("v.errors", []);
        component.set("v.valueMap", {});
        component.set("v.errorMap", {});
        component.set("v.cacheData", {});
    },
    refresh : function(component, event, helper) {
        // Clear data in value map
        helper.refreshBody(component, helper);
    },
    updateValueMap : function(component, event, helper) {
		helper.updateValues(component, event);        
    },
    validate : function(component, event, helper) {
        var fieldInputs = component.find("sections").find("fieldInput");
        console.log('fieldInputs: '+fieldInputs);
        var isValid = true;
        fieldInputs.forEach(function(fieldInput) {
            var isRequired = fieldInput.get("v.required");
            var readOnly = fieldInput.get("v.readOnly");
            if(fieldInput.get("v.errors") && fieldInput.get("v.errors").length > 0){
                isValid = false;
            } else if(!readOnly && isRequired && !fieldInput.get("v.value")) {
                isValid= false;
                fieldInput.set("v.errors", [{"message":"This field is required"}]);
            }
            var today = new Date();        
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            // if date is less then 10, then append 0 before date   
            if(dd < 10){
                dd = '0' + dd;
            } 
            // if month is less then 10, then append 0 before date    
            if(mm < 10){
                mm = '0' + mm;
            }
            
            var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
          
            if (fieldInput.get("v.apiName") == 'Lead.When_did_your_business_commence_trading__c'){
                if(fieldInput.get("v.value") > todayFormattedDate){
                    isValid= false;
                    fieldInput.set("v.errors", [{"message":"Business commence trading cannot be in the future"}]);
                }    
            }
            
            if (fieldInput.get("v.apiName") == 'Trade_Type__c.License_Expiry__c'){
                if(fieldInput.get("v.value") < todayFormattedDate){
                    isValid= false;
                    fieldInput.set("v.errors", [{"message":"License expiry cannot be in the past"}]);
                }                
            }

        });
        return isValid;
    },
    convertToValueMap : function(component, event, helper) {
        var valueMap = component.get("v.valueMap");
        return helper.convertValueMap(valueMap);
    },
    retrieveServerOptions: function(component, event, helper) {
        var params = event.getParams();

        var wizardSetting = params.arguments.wizardSetting;
        return helper.getServerOptions(component, wizardSetting);
    }
})