({
    EditRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event
       component.getEvent("EditRowEvt").setParams({"TradeType" : component.get("v.TradeTypeInstance"),"indexVar" : component.get("v.rowIndex") }).fire();

    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },

  
})