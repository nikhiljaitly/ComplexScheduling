({
	 selectAccount : function(component, event, helper){      
    // get the selected Account from list  
      var getSelectPbEntry = component.get("v.oPricebookEntry");
    // call the event   
      var compEvent = component.getEvent("HRPricebookEntryEvent");
      
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"accountByEvent" : getSelectPbEntry }); 
      
    // fire the event  
         compEvent.fire();
    },
})