({
//this function will fetch Car__c records from server
getTrades : function(component, helper) {
        var action = component.get("c.getAllTrades");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})