({
    // Function used to open the tradetype modal
    openModal: function(component, event, helper) {
        var modal = component.find("tradetypeModal");
        var modalBackdrop = component.find("tradetypeModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
        
        console.log('Clear Fields');
       // function for clear the Selected WorkType 
        var pillTarget = component.find("wktype").find("lookup-pill");
        var lookUpTarget = component.find("wktype").find("lookupField"); 
 
        console.log('pillTarget ' + pillTarget);
        console.log('lookUpTarget ' + lookUpTarget);
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );
        
        component.find("licNumber").set("v.value", '');
        component.find("licType").set("v.value", '');
        component.find("licExp").set("v.value", '');
     
        //component.find('fileInput').set('v.files', []);
        //component.find('fileInput').getElement().value='';
        component.find("licDoc").find("file").getElement().value='';
    },

    // Function used to close the tradetype modal
    closeModal: function(component, event, helper) {
        var modal = component.find("tradetypeModal");
        var modalBackdrop = component.find("tradetypeModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },

    // Function used to create new tradetype
    createTradeType: function(component, event, helper) {
        helper.insertTradeType(component, event, helper);
    },
    
    // Function used to store new tradetype
    storeTradeTypeData: function(component, event, helper) {
    //component.set("v.tradetype", []);
    var editSave = component.get("v.editSave");
        if(!editSave){
            helper.createTradeTypeData(component, event, helper);
        }else{
            helper.saveTradeTypeData(component, event, helper);
        }         
	},
    
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [TradeType Instance] on first time Component Load
        // by call this helper function 
        console.log('in Init'); 
        component.set("v.tradetype", []);
        helper.createObjectData(component, event);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected WorkType record from the COMPONENT event 	 
        var selectedWorkTypeGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedWorkTypeGetFromEvent);
        console.log('selectedWkTypeEntryId ' + component.get("v.selectedWorktypeEntryLookUpRecord").Id);
        helper.fetchWkTypeName(component,event);  
    },
    
    
    removeRow : function(component, event, helper){
        var rowIndex = event.currentTarget.parentElement.id ;
        console.log("Row No : " + rowIndex);        
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       // component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
         component.getEvent("DeleteRowEvt").setParams({"indexVar" : rowIndex }).fire();
    }, 
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        console.log('selectedrowindex ' +index);
        // get the all List (tradeTypeList attribute) and remove the Object Element Using splice method    
        var AllRowsList = [];
        AllRowsList = component.get("v.tradeTypeList");        
        AllRowsList.splice(index, 1);
        // set the tradetypeList after remove selected row element  
        component.set("v.tradeTypeList", AllRowsList);      
    },
    
    // Function used to Edit the tradetype modal
    editModal: function(component, event, helper) {   		
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        console.log('index '+index);
        var selectedTrade = component.get("v.tradeTypeList")[index]; // Use it retrieve the store record 
        console.log('selectedTrade: '+ JSON.stringify(selectedTrade));  
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );
        
        var modal = component.find("tradetypeModal");
        var modalBackdrop = component.find("tradetypeModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
        
        // function for clear the Selected WorkType 
        var pillTarget = component.find("wktype").find("lookup-pill");
        var lookUpTarget = component.find("wktype").find("lookupField"); 
 
        console.log('pillTarget ' + pillTarget);
        console.log('lookUpTarget ' + lookUpTarget);
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
       /* component.set("v.SearchKeyWord",{});
        component.set("v.listOfSearchRecords", {} );
        component.set("v.selectedRecord", {} );*/

        component.find("licNumber").set("v.value", component.get("v.tradeTypeList")[index].License_Number__c);
        component.find("licType").set("v.value", component.get("v.tradeTypeList")[index].License_Type__c);
        component.find("licExp").set("v.value", component.get("v.tradeTypeList")[index].License_Expiry__c);
        component.find("licDoc").find("file").getElement().value='';
        
        
        component.set("v.editSave", true);
        component.set("v.selectedRowIndex", index);
        
        

        // call the event   
   /*     var compEvent = component.getEvent("selectedRowIndex");
        // set the clearance flag to the event attribute.  
        compEvent.setParams({"rowIndexfromevent" : index });  
        // fire the event  
        compEvent.fire(); */
        
      /*  var AllRowsList = [];
        AllRowsList = component.get("v.tradeTypeList");        
        AllRowsList.splice(index, 1);
        // set the tradetypeList after remove selected row element  
        component.set("v.tradeTypeList", AllRowsList);  */  
    },
    
    
    setFileContent: function(component, event, helper) {
        var selfile = event.getParam("selectedfile");
        component.set("v.selectedFileContent", selfile);        
        console.log('selfile ' +selfile);
    }
    
    
})