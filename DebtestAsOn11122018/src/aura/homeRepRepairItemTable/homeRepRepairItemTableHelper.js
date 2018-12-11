({
	validateRequiredField : function(component){
		return true;
        /*var opportunityItems = component.get("v._opportunity_items");
        var isValid = true;
        for(var index in opportunityItems){
            var opportunityItem = opportunityItems[index];
            opportunityItem.errors["quantity"] = "";
            opportunityItem.errors["salesPrice"] = "";
            opportunityItem.errors["serviceDate"] = "";
            opportunityItem.errors["description"] = "";            
            if(!opportunityItem.quantity){
                isValid = false;
                opportunityItem.errors["quantity"] = "requiredErrorField";
            }
            if(!opportunityItem.salesPrice){
                isValid = false;
                opportunityItem.errors["salesPrice"] = "requiredErrorField";
            }
            if((opportunityItem.errors["salesPrice"] 
               && opportunityItem.errors["salesPrice"].length > 0) 
               || (opportunityItem.errors["quantity"] 
               	&& opportunityItem.errors["quantity"].length > 0)){
                opportunityItem.errors.message = "This field is required";
            }else{
                opportunityItem.errors.message = "";
            }
        }
        if(!isValid){
      		this.renderErrors(component, opportunityItems);
        }
       	return isValid;*/
    },
    renderErrors: function(component, assessmentItems){
            var errorMessage = "There were errors whilst saving your records";
            component.set("v._error", errorMessage);
            component.set("v._assessment_items", assessmentItems);  
    },
    handleErrorOfRepairItemsCreation : function(response, component){

        // NOTE: this won't work... fix if time allows...

    	var results = response.getReturnValue().errorResults;
        var opportunityItems = component.get("v._opportunity_items");
        for(var key in results){
        	var result = results[key];
            var fields = result.fields;
            fields = fields.replace('(','');
            fields = fields.replace(')','');
			var opportunityItem = opportunityItems[result.index];
            opportunityItem.errors["quantity"] = "";
            opportunityItem.errors["salesPrice"] = "";
            opportunityItem.errors["serviceDate"] = "";
            opportunityItem.errors["description"] = "";   
            if(fields.indexOf('Quantity') !== -1){
            	opportunityItem.errors.quantity = 'requiredErrorField';
            }
            if(fields.indexOf('UnitPrice') !== -1){
                opportunityItem.errors.salesPrice = 'requiredErrorField';
            }
            if(fields.indexOf('ServiceDate') !== -1){
                opportunityItem.errors.serviceDate = 'requiredErrorField';
            }
            if(fields.indexOf('Description') !== -1){
                opportunityItem.errors.description = 'requiredErrorField';
            }
            opportunityItem.errors.message = result.message;
	    }
        this.renderErrors(component, opportunityItems);
	},
	fireHandleRepairItemsEvent : function(component, command) {
        var handleRepairItems = component.getEvent("handleRepairItems"); 
        handleRepairItems.setParams({
            "command": command
        });
        handleRepairItems.fire();
	}
})