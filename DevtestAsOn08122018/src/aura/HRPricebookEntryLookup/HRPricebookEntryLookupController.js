({
  
	keyPressController : function(component, event, helper) {
      // get the search Input keyword   
		var getInputkeyWord = component.get("v.SearchKeyWord");
      // check if getInputKeyWord size id more then 0 then open the lookup result List and 
      // call the helper 
      // else close the lookup result List part.   
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
  
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
      
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
     
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("accountByEvent");
	   
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        console.log("Selected Product2 " + JSON.stringify(component.get("v.selectedRecord")));
        console.log("Selected Product Name " + JSON.stringify(component.get("v.selectedRecord").Name));
        console.log("Selected Product Id " + JSON.stringify(component.get("v.selectedRecord").Id));
       
        var selProdId = component.get("v.selectedRecord").Id;
        
        
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
      
        
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        
        
        console.log('***handleComponentEvent begin');
        var action = component.get("c.fetchLabMatCosts"); 
        
        action.setParams({
            selectedProdId: component.get("v.selectedRecord").Id
        });
        console.log('In handleComponentEvent*****');
        console.log(component.get("v.selectedRecord").Id);
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('*****State****');
            console.log(state);
            
            if (state === "SUCCESS" ) {
                component.set("v.listOfLabMatEntries", response.getReturnValue());                
                console.log('listOfLabMatEntries: ' + JSON.stringify(component.get("v.listOfLabMatEntries")));
                console.log('LabourCost1: ' + JSON.stringify(component.get("v.listOfLabMatEntries")[0].Labour_Price__c));
                component.set("v.labourCost", JSON.stringify(component.get("v.listOfLabMatEntries")[0].Labour_Price__c));
                
                var labVal = component.get("v.labourCost");
                var compEvent = component.getEvent("HRLabMatVal");
                 compEvent.setParams({"PassLabVal" : labVal });  
                 compEvent.fire();
              /*  var evt = $A.get("e.c:HRLabMatVal");
                evt.setParams({ "PassLabVal": labVal });
                evt.fire();*/
                
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        console.log(action);
        $A.enqueueAction(action);        
	},
  // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
 // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
  
})