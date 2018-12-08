({
	 selectAccount : function(component, event, helper){      
    // get the selected Account from list  
      
      var getSelectWorkType = component.get("v.oWorkType");
      console.log("getSelectWorkType: " + JSON.stringify(getSelectWorkType));
    // call the event   
      var compEvent1 = component.getEvent("HRworkTypeEvent");
      console.log("compEvent1" + JSON.stringify(compEvent1));
    // set the Selected Account to the event attribute.  
         compEvent1.setParams({"workTypeByEvent" : getSelectWorkType });
      //console.log("compEvent1" + JSON.stringify(compEvent1));
    // fire the event  
         compEvent1.fire();
    },
})