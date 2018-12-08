({
    searchCostsHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchCostsValues");
        // set param to method
        console.log('woRecId ' + component.get("v.recordId"));
        action.setParams({
            'PricebookEntryId' : component.get("v.selectedPricebookEntryLookUpRecord").Id,
            'woRecId' : component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                var listLength = storeResponse.length;
             /*   for (var i = 0; i < listLength; i++) {
                    alert(storeResponse[i]); 
                    //or
                    alert(storeResponse[i].Id);
                }*/
                component.set("v.priceBookId", storeResponse[0].Id);
                component.set("v.labourPrice", storeResponse[0].Labour_Price__c);
                component.set("v.materialPrice", storeResponse[0].Material_Price__c);
                component.set("v.labourTime", storeResponse[0].Labour_TIME_mins__c);
                console.log('PriceRecord '+ JSON.stringify(storeResponse));
                console.log('priceBookId '+ component.get("v.priceBookId"));
                console.log('Labourcost '+ component.get("v.labourPrice"));
                console.log('MaterialCost '+ component.get("v.materialPrice"));
                console.log('LabourTime '+ component.get("v.labourTime"));
                
                console.log('Resetcosts fired');
                component.find("labourprice").set("v.value", component.get("v.labourPrice"));
                component.find("materialprice").set("v.value", component.get("v.materialPrice"));    
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);    
    },
    
    showToast : function(type, message) {        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type,
            "duration": 100,
            "mode": "dismissible",
        });
        toastEvent.fire();        
    },
    
})