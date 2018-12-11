({
    saveWoliRecord : function(component, event, helper) {
        var woliObj = component.get("v.objWorkOrderLineItem");
        //var quantity = component.find('quantity');
        //console.log('Quantity3 ' + quantity);
        component.set("v.Spinner", true); 
        
        var labourCmp = component.find("labourprice");
        if(labourCmp != undefined){            
            var labourprice = component.find("labourprice").get("v.value");
            var materialprice = component.find("materialprice").get("v.value");
            var labourtime = component.find("labourtime").get("v.value");
            var quantity = component.find("quantity").get("v.value");
            console.log('labourtime ' + labourtime);       
            console.log('WorkOrderId ' + component.get("v.recordId"));
        }else{
            var message = "Product cannot be empty. Please select Product";
            var type = "error";             
            helper.showToast(type, message);
        }
        //set the default Product2Id is null 
        woliObj.Product2Id = null ; 
        // check if selectedPricebookEntryLookupRecord is not equal to undefined then set the Product2Id from 
        // selected Lookup Object to WorkOrderLineItem Object before passing this to Server side method
        if(component.get("v.selectedPricebookEntryLookUpRecord").Id != undefined){
            woliObj.PricebookEntryId = component.get("v.selectedPricebookEntryLookUpRecord").Id;
            woliObj.WorkOrderId = component.get("v.selectedWorkOrderLookUpRecord").Id;
            woliObj.Service_Appointment__c = component.get("v.selectedServiceApptLookUpRecord").Id;
            woliObj.Room__c = component.get("v.selectedRoomLookUpRecord").Id;
            woliObj.WorkOrderId = component.get("v.recordId");
         	woliObj.Labour_Cost__c = labourprice;
          	woliObj.Material_Cost__c = materialprice;
         	woliObj.Labour_Time__c = labourtime;
            woliObj.Quantity = quantity;
        } 
        
        if(component.get("v.selectedPricebookEntryLookUpRecord").Id == undefined){
            var message = "Product cannot be empty. Please select Product";
            var type = "error";             
            helper.showToast(type, message);
        }
        
        //call apex class method
        var action = component.get('c.createWorkOrderLineItem');
        action.setParams({
            'woli': woliObj
        })
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            var woLineItemNumber = response.getReturnValue();
            console.log('woNumber ' + woLineItemNumber);
            if (state === "SUCCESS") {
                var message = "WorkOrderLineItem" + ' ' + woLineItemNumber + ' ' + "created successfuly";
                var type = "success";             
                helper.showToast(type, message);
                $A.get('e.force:refreshView').fire();
                //alert('Record Created');
            }
        });
        $A.enqueueAction(action);       
        
    },
    
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Product record from the COMPONENT event 	 
       var selectedProductGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedProductGetFromEvent);
       console.log('selectedPriceEntryId ' + component.get("v.selectedPricebookEntryLookUpRecord").Id);
       helper.searchCostsHelper(component,event);  
	}, 
    
    
    handleCancel : function(component, event, helper) {
        var message = "WorkOrderLineItem creation cancelled";
        var type = "error";             
        helper.showToast(type, message);
        $A.get('e.force:refreshView').fire();
    },
    
    clearCosts : function(component, event, helper) {
        console.log('clearcosts fired');
        component.find("labourprice").set("v.value", "0.00");
        component.find("materialprice").set("v.value", "0.00");
    },
    
    overrideCosts : function(component, event, helper) {
        console.log('overrideCosts fired');
        component.find("labourprice").set("v.value", component.get("v.labourPrice"));
        component.find("materialprice").set("v.value", component.get("v.materialPrice"));
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
       // component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
      
})