({
    
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [TradeType Instance] on first time Component Load
        // by call this helper function  
        helper.createObjectData(component, event);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {    
        
        // first call the helper function in if block which will return true or false.
        // this helper function check the "WorkType Name" will not be blank on each row.
        if (helper.validateRequired(component, event)) {
            // call the apex class method for save the TradeType List
            // with pass the tradetype List attribute to method param.  
            var action = component.get("c.saveTradeTypes");
            action.setParams({
                "ListTradeType": component.get("v.tradetypeList")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // if response if success then reset/blank the 'tradetypeList' Attribute 
                    // and call the common helper method for create a default Object Data to TradeType List 
                    component.set("v.tradetypeList", []);
                    helper.createObjectData(component, event);
                    alert('record Save');
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        }
    },
    
    // function for create new object Row in TradeType List 
    addNewRow: function(component, event, helper) {
        // call the common "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (tradetypeList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.tradetypeList");
        AllRowsList.splice(index, 1);
        // set the tradetypeList after remove selected row element  
        component.set("v.tradetypeList", AllRowsList);
    },
    

})