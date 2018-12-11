({
    AddNewRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected WorkType record from the COMPONENT event 	 
        var selectedWorkTypeGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedWorkTypeGetFromEvent);
        console.log('selectedWorkTypeIdRowItem ' + component.get("v.selectedWorkTypeLookUpRecord").Id); 
        component.set("v.TradeTypeInstance.Work_Type__c" , component.get("v.selectedWorkTypeLookUpRecord").Id);
    }
  
})