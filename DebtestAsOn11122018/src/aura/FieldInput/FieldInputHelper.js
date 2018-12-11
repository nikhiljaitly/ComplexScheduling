({
    checkIsRequired: function(component){
        var errors = component.get("v.errors");
        var errorList = [];
        if(errors) {
            errors.forEach(function(error) {
                if(error.message != "This field is required" && 
                   error.message != "Business commence trading cannot be in the future" &&
                   error.message != "License expiry cannot be in the past" ){
                    errorList.push(error);                  
                }
            });
            if(errorList.length === 0 ){
                component.set("v.errors", null);         
            } else {
                component.set("v.errors", errorList);
            }
        }
        
        var isRequired = component.get("v.required") ;
        var value = component.get("v.value");
        if(!isRequired){
            return;
        }
        var fieldCMP = component.find("field");
        if(!value || value === null || value === "--None--"){
            var info = "This field is required";
            this.setErrorMessage(fieldCMP, info);
        } 
    }
    ,
    setErrorMessage: function(fieldCMP, info) {
        var message = [{message: info}];
        fieldCMP.set("v.errors", message);
    }
})