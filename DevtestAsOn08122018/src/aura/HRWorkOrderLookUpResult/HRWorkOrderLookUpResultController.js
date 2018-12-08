({
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
    // call the event   
      var compEvent = component.getEvent("SelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord });  
    // fire the event  
         compEvent.fire();
    },
    
    loadValues : function (component) {
        var record = component.get("v.oRecord");
        var subheading = '';
        for(var i=0; i<component.get("v.subHeadingFieldsAPI").length ;i++ ){
            if(record[component.get("v.subHeadingFieldsAPI")[i]]){
                subheading = subheading + record[component.get("v.subHeadingFieldsAPI")[i]] + ' • ';
            }
        }
        subheading = subheading.substring(0,subheading.lastIndexOf('•'));
        component.set("v.subHeadingFieldValues", subheading);
    },
    
})