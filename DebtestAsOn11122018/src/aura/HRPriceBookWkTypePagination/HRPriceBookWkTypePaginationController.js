({
   onfocus : function(component,event,helper){
     /*  $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close'); */
        // Get Default 5 Records order by createdDate DESC  
         //var getInputkeyWord = '';
        // helper.searchHelper(component,event,getInputkeyWord);
       
       /*  var getInputkeyWord = component.get("v.SearchKeyWord");
         var next = false;
         var prev = false;
         var offset = component.get("v.offset");
         helper.getPriceBookEntries(component,next,prev,offset,getInputkeyWord);*/

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
        console.log('##SearchKeyWord ' + getInputkeyWord);
        var next = false;
        var prev = false;
        var offset = component.get("v.offset");
        //helper.getPriceBookEntries(component,next,prev,offset,getInputkeyWord);
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper    
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
           helper.getPriceBookEntries(component,next,prev,offset,getInputkeyWord);
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

    getPriceBookEntry : function(component, event, helper) {
        var next = false;
        var prev = false;
        var offset = component.get("v.offset");
        var getInputkeyWord = component.get("v.SearchKeyWord");
        helper.getPriceBookEntries(component,next,prev,offset,getInputkeyWord);
    },
    Next:function(component, event, helper){
        var next = true;
        var prev = false;
        var offset = component.get("v.offset");
        var getInputkeyWord = component.get("v.SearchKeyWord");
        helper.getPriceBookEntries(component,next,prev,offset,getInputkeyWord); 
    },
    Previous:function(component,event,helper){
        var next = false;
        var prev = true;
        var offset = component.get("v.offset");
        var getInputkeyWord = component.get("v.SearchKeyWord");
        helper.getPriceBookEntries(component,next,prev,offset,getInputkeyWord); 
    },

    selectPriceBkEntry: function(component, event, helper) {   		
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        console.log('index '+index);
        var selectedPbe = component.get("v.pricebookentry")[index]; // Use it retrieve the store record 
        console.log('selectedPbe: '+ JSON.stringify(selectedPbe)); 
        
        var priceBookEntryId = component.get("v.pricebookentry")[index].Id;
        //component.set("v.priceBookId", priceBookId);
        //component.find("licNumber").set("v.value", component.get("v.tradeTypeList")[index].License_Number__c);
     	
        // call the apex class method 
        var action = component.get("c.fetchCostsValues");
        // set param to method
        //console.log('woRecId ' + component.get("v.recordId"));
        action.setParams({
            'PricebookEntryId' : priceBookEntryId,
           // 'woRecId' : component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('##PriceBookResp ' + storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                var listLength = storeResponse.length;
                /*   for (var i = 0; i < listLength; i++) {
                    alert(storeResponse[i]); 
                    //or
                    alert(storeResponse[i].Id);
                }*/
                component.set("v.priceBookId", storeResponse[0].Id);
                component.set("v.labourPrice", storeResponse[0].Labour_Price__c);
                component.set("v.materialPrice", storeResponse[0].Material_Price__c);
                component.set("v.labourTime", storeResponse[0].Labour_TIME_mins__c);
                console.log('PriceRecord '+ JSON.stringify(storeResponse));
                console.log('priceBookId '+ component.get("v.priceBookId"));
                console.log('Labourcost '+ component.get("v.labourPrice"));
                console.log('MaterialCost '+ component.get("v.materialPrice"));
                console.log('LabourTime '+ component.get("v.labourTime"));
                
                console.log('Resetcosts fired');
                component.find("labourprice").set("v.value", component.get("v.labourPrice"));
                component.find("materialprice").set("v.value", component.get("v.materialPrice")); 
                component.find("labourtime").set("v.value", component.get("v.labourTime")); 
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action); 
        
        
    },
    
    overrideCosts : function(component, event, helper) {
        console.log('overrideCosts fired');
        component.find("labourprice").set("v.value", component.get("v.labourPrice"));
        component.find("materialprice").set("v.value", component.get("v.materialPrice"));
    },

       
})