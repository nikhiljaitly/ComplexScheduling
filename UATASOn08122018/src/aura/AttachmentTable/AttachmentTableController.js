({
    // function for create new object Row in Contact List 
    editTradeTypeRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List 
        console.log('Entered Edit event') 
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.attachmentList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.attachmentList", AllRowsList);
    },
})