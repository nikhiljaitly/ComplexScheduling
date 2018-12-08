({
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);

       
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper    
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }        
    },
    
  // function for clear the Record Selection 
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
        
        
        // call the event   
        var compEvent = component.getEvent("handleClearedPriceBookEntryEvent");
        // set the clearance flag to the event attribute.  
        compEvent.setParams({"priceBookEntryPillCleared" : "yes" });  
        // fire the event  
        compEvent.fire(); 
        
      /*   var message = "Please select Product to create WorkOrderLineItem from New Work Order Line Item Tab";
         var type = "error";
         console.log('call toast3');
        // helper.showToast(type, message);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type,
            "duration": 100,
            "mode": "dismissible",
        });
        toastEvent.fire();     
        $A.get('e.force:refreshView').fire(); */
        
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Product record from the COMPONENT event 	 
       var selectedProductGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedProductGetFromEvent); 
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');       
	},
    
    
    // This function call when component loads.   
    doInit : function(component, event, helper) {
        var action = component.get('c.getWorkOrderWorkType');
        action.setParams({
            'WorkOrderId': component.get("v.woRecordId")
        })
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('Response ' + JSON.stringify(storeResponse));
                component.set("v.WOWorkType", storeResponse[0].WorkType.Name);
                component.set("v.woState", storeResponse[0].Risk_State__c);
                console.log('WOWorkType ' + component.get("v.WOWorkType"));
                console.log('woState ' + component.get("v.woState"));
            }
        });
        $A.enqueueAction(action);  
    },  
      
       
})