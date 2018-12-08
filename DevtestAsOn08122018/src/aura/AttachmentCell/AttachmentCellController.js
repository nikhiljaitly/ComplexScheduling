({
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       console.log('Entered Remove Row Event')
       var attach = component.get("v.attachmentInstance");
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex"), "description" : attach.Description, "Id" : attach.Id}).fire();
    },

  

})