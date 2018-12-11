({
    // Function to create new contacts on server
    insertTradeType: function(component, event, helper) {
        var tradetype = component.get("v.tradetype"); 
        var selWorkTypeId = component.get("v.selectedWorktypeEntryLookUpRecord").Id;
        
        if(component.get("v.selectedWorktypeEntryLookUpRecord").Id != undefined){
            tradetype.Work_Type__c = component.get("v.selectedWorktypeEntryLookUpRecord").Id;
        }
        console.log('##WorkTypeId ' + component.get("v.selectedWorktypeEntryLookUpRecord").Id);
        // Initializing the toast event to show toast
        var toastEvent = $A.get('e.force:showToast');
        var createAction = component.get('c.createTradeTypeRecord');
        createAction.setParams({
            newTradeType: tradetype,
            sWorkTypeId: selWorkTypeId
            
        });
        createAction.setCallback(this, function(response) {           
            // Getting the state from response
            var state = response.getState();
            if(state === 'SUCCESS') {
                // Getting the response from server
                var dataMap = response.getReturnValue();
                // Checking if the status is success
                if(dataMap.status=='success') {
                    var modal = component.find("tradetypeModal");
                    var modalBackdrop = component.find("tradetypeModalBackdrop");
                    $A.util.removeClass(modal,"slds-fade-in-open");
                    $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
                    
                    // Setting the success toast which is dismissable ( vanish on timeout or on clicking X button )
                    toastEvent.setParams({
                        'title': 'Success!',
                        'type': 'success',
                        'mode': 'dismissable',
                        'message': dataMap.message
                    });
                    // Fire success toast event ( Show toast )
                    toastEvent.fire();            
                    //window.location.reload();
                }
                // Checking if the status is error 
                else if(dataMap.status=='error') {
                    // Setting the error toast which is dismissable ( vanish on timeout or on clicking X button )
                    toastEvent.setParams({
                        'title': 'Error!',
                        'type': 'error',
                        'mode': 'dismissable',
                        'message': dataMap.message
                    });
                    // Fire error toast event ( Show toast )
                    //toastEvent.fire();                
                }
            } else {
                // Show an alert if the state is incomplete or error
                alert('Error in getting data');
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(createAction);
    },
    
    createTradeTypeData: function(component, event, helper) {      
        // get the tradetypeList from component and add(push) New Object to List 
        console.log('In CreateTradeTypeData');
        var fileInput = component.find("licDoc").find("file").getElement();
        var file = fileInput.files[0];
        var fileName = fileInput.files[0]['name'];
        
        //when lightning:input is used for uploading file
        //var fileInput = component.find("licDoc").find("file").get("v.files");
        //var file = fileInput[0];
        console.log('file ' +file);
        console.log('fileName ' +fileName);        
        console.log('fileContentsCreateTrData ' +encodeURIComponent(file));
        
        var RowItemList = component.get("v.tradeTypeList");
        RowItemList.push({
            'sobjectType': 'Trade_Type__c',
            'Work_Type__c': component.get("v.selectedWorktypeEntryLookUpRecord").Id,
            'WorkTypeName__c': component.get("v.wkTypeName"),
            'License_Number__c': component.find("licNumber").get("v.value"),            
            'License_Type__c': component.find("licType").get("v.value"),
            'License_Expiry__c': component.find("licExp").get("v.value"),
            'License_Document__c':file,
            'License_Document_Name__c':fileName,
            'Status__c': 'Pending'
        });
        // set the updated list to attribute (tradetypeList) again    
        component.set("v.tradetype", RowItemList);
        component.set("v.tradeTypeList", RowItemList); 
        console.log('tradeTypeListTradeData ' + JSON.stringify(component.get("v.tradeTypeList")));
        console.log('LicenseDocument ' + encodeURIComponent(component.get("v.tradeTypeList")[0].License_Document__c));
                                                               
        
     /*   var PaginationList = [];
        for(var i=0; i< component.get("v.tradetype").length; i++){
            if(component.get("v.tradetype").length> i)
                PaginationList.push(component.get("v.tradetype")[i]);    
        }
        component.set('v.PaginationList', PaginationList);
        console.log('PaginationList ' + JSON.stringify(component.get("v.PaginationList"))); */
        
        var modal = component.find("tradetypeModal");
        var modalBackdrop = component.find("tradetypeModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open"); 
        
        component.set("v.editSave", false);
       
    },
    
    createObjectData: function(component, event, helper) {
        // get the tradetypeList from component and add(push) New Object to List        
        var RowItemList = component.get("v.tradetype");        
        console.log('RowItemList ' + JSON.stringify(RowItemList));        
        RowItemList.push({
            'sobjectType': 'Trade_Type__c',
            'Work_Type__c': '',
            'WorkTypeName__c':'',
            'License_Number__c': '',
            'License_Type__c': '',
            'License_Expiry__c': '',
            'Status__c':''
        }); 
        // set the updated list to attribute (tradetypeList) again    
        component.set("v.tradetype", RowItemList);
        component.set("v.tradeTypeList", RowItemList);        
        console.log('tradeTypeListObjData ' + JSON.stringify(component.get("v.tradeTypeList")));
        
       /* var PaginationList = [];
        for(var i=0; i< component.get("v.tradetype").length; i++){
            if(component.get("v.tradetype").length> i)
                PaginationList.push(component.get("v.tradetype")[i]);    
        }
        component.set('v.PaginationList', PaginationList);
        console.log('PaginationList ' + JSON.stringify(component.get("v.PaginationList"))); */
        
        
    },
    
    fetchWkTypeName : function(component,event,getInputkeyWord) {
        // call the apex class method
       var selWorkTypeId = component.get("v.selectedWorktypeEntryLookUpRecord").Id;
       var createAction = component.get('c.getWorkTypeName');
        createAction.setParams({
            sWorkTypeId: selWorkTypeId            
        });
        createAction.setCallback(this, function(response) {           
            // Getting the state from response
            var state = response.getState();
            if(state === 'SUCCESS') {
                // Getting the response from server
                var wkTypeNameResult = response.getReturnValue();
                component.set("v.wkTypeName", wkTypeNameResult[0].Name);
                console.log('wkTypeNameResult2 ' + component.get("v.wkTypeName"));
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(createAction);
    },
    
    saveTradeTypeData: function(component, event, helper) {      
        // get the tradetypeList from component and add(push) New Object to List  
        console.log('In saveTradeTypeData');
        var fileInput = component.find("licDoc").find("file").getElement();
        var file = fileInput.files[0];
        var fileName = fileInput.files[0]['name'];
        
        var RowItemList = component.get("v.tradeTypeList");
        RowItemList.push({
            'sobjectType': 'Trade_Type__c',
            'Work_Type__c': component.get("v.selectedWorktypeEntryLookUpRecord").Id,
            'WorkTypeName__c': component.get("v.wkTypeName"),
            'License_Number__c': component.find("licNumber").get("v.value"),            
            'License_Type__c': component.find("licType").get("v.value"),
            'License_Expiry__c': component.find("licExp").get("v.value"),
            'Status__c': 'Pending',
            'License_Document__c':file,
            'License_Document_Name__c':fileName
        });
        // set the updated list to attribute (tradetypeList) again    
        component.set("v.tradetype", RowItemList);
        component.set("v.tradeTypeList", RowItemList); 
        console.log('tradeTypeListTradeData ' + JSON.stringify(component.get("v.tradeTypeList")));
        
       // var selectedItem = event.currentTarget; // Get the target object
        //var index = selectedItem.dataset.record; // Get its value i.e. the index
        var index =  component.get("v.selectedRowIndex");
        console.log('index '+index);
        var selectedTrade = component.get("v.tradeTypeList")[index]; // Use it retrieve the store record 
        console.log('selectedTrade: '+ JSON.stringify(selectedTrade));
        
        var AllRowsList = [];
        AllRowsList = component.get("v.tradeTypeList");        
        AllRowsList.splice(index, 1);
        // set the tradetypeList after remove selected row element  
        component.set("v.tradeTypeList", AllRowsList);
        
        var modal = component.find("tradetypeModal");
        var modalBackdrop = component.find("tradetypeModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
        
        component.set("v.editSave", false);
        
    }
    
})