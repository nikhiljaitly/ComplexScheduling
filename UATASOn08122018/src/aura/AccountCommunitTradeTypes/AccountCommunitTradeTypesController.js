({  // This function that reads the url parameter Lead Id
    // and retrieves Lead details
    init : function(component, event, helper) {
        
        var getUrlParameter = function getUrlParameter(sParam) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;
            
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                
                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };
        console.log(getUrlParameter('accId'));
        var accId=''
        if((getUrlParameter('accId')===undefined)){
            accId  = null;
        }else{
            accId  = getUrlParameter('accId');
        }
        console.log('accId'+accId);
        //Get Lead details for Lead id
        var action = component.get("c.getAccount");
        action.setParams({"accId": accId});
        helper.execute(action).then(function(response) {
            var state = response.getState();
            console.log('accId'+state);
            var accRecord = {};
            if(component.isValid() && state == "SUCCESS"){
                accRecord = response.getReturnValue();
                console.log('Account :',accRecord); 
                component.set("v.acc", accRecord); 
                component.set("v.isAvailable", true);                        
                component.set("v.workCoverDocAdded",false);
                component.set("v.publicLiabilityDocAdded",false);
                component.set("v.otherInsuranceDocAdded",false);
                component.set("v.bankDepositDocAdded",false);
                component.set("v.policeCheckDocAdded",false);
                
                var allCompliances = component.get("v.acc.Trade_Types__r");
                component.find("compliance").set("v.data", allCompliances);
                component.find("compliance").initiateDocs();
                var AllContentFiles=component.get("v.acc.ContentDocumentLinks");
                if((!$A.util.isUndefined(AllContentFiles)) && AllContentFiles.length > 0){                            
                    for (var i = 0; i < AllContentFiles.length; i++) {  
                        if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Police Check Document')){
                            component.set("v.policeCheckDocAdded",true);
                        }
                        if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Work Cover Insurance Policy')){
                            component.set("v.workCoverDocAdded",true);
                        }
                        if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Public Liability Insurance Policy')){
                            component.set("v.publicLiabilityDocAdded",true);
                        }
                        if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Other Insurance Policy')){
                            component.set("v.otherInsuranceDocAdded",true);
                        }
                        if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Bank Deposit Slip')){
                            component.set("v.bankDepositDocAdded",true);
                        }                                
                    }
                    
                }
                // create a Default RowItem [Contact Instance] on first time Component Load
                // by call this helper function 
                console.log('Entered Init');
                helper.firstPartLeadData(component, event);
                helper.createObjectData(component, event);
                helper.fetchBusinessStructureVal(component, 'Business_Structure__c', 'businessStruc'); 
            }
            return accRecord;
        }).then(function(accRecord) {
            var valueMap = component.get("v.valueMap");
            valueMap = valueMap || {};
            valueMap["Account.Work_Type__c"]= accRecord["Work_Type__c"];
            valueMap["Account.Other_Work_Type__c"]= accRecord["Other_Work_Type__c"];
            valueMap["Account.Service_Areas__c"]= accRecord["Service_Areas__c"];
            valueMap["Account.Other_Service_Areas__c"]= accRecord["Other_Service_Areas__c"];
            valueMap["Account.Jobs_Per_Week__c"]= accRecord["Jobs_Per_Week__c"];
            valueMap["Account.Fully_qualified_tradesperson_Rate__c"]= accRecord["Fully_qualified_tradesperson_Rate__c"];
            valueMap["Account.Labourer_Rate__c"]= accRecord["Labourer_Rate__c"];
            valueMap["Account.After_Hours_Rate__c"]= accRecord["After_Hours_Rate__c"];
            valueMap["Account.Call_Out_Rate__c"]= accRecord["Call_Out_Rate__c"];
            valueMap["Account.Report_Rate__c"]= accRecord["Report_Rate__c"];
            valueMap["Account.Other_Rate_s__c"]= accRecord["Other_Rate_s__c"];
            component.set("v.valueMap", valueMap);
            
            Promise.all([helper.getCacheTable(component), 
                         helper.getInitForm(component)]).then(
                function(responses) {
                    console.log("response1", responses[0]);
                    helper.handleFormResults(component, responses[1]);
                    component.find("compliance").set("v.parentId", component.get("v.acc").Id);
                 });
        })
        
    },
    // function for updateDocumentList 
    
    updateDocumentList : function(component, event, helper) {
        //get the selected row Index for delete, from Lightning Event Attribute 
        console.log('Entered the delete row handler');
        var isUploaded = event.getParam("isUploaded");        
        if(isUploaded){
            var a = component.get('c.init');
            $A.enqueueAction(a);
            //component.set("v.publicLiabilityDocAdded", true);
        }
    },
    editRow: function(component, event, helper){
        var recordId = event.target.id;
        console.log(recordId);
        var navEvt = $A.get("e.force:navigateToSObject"); //$A.get("e.force:editRecord"); 
        navEvt.setParams({ "recordId": recordId }); 
        navEvt.fire();
    },
    customActions: function(component, event, helper) {
        helper.customActionsAfterDataChanged(component, event);
    },
    updateAccountJs: function(component, event, helper) {
        var tradeTypeListVal = component.get("v.tradeTypeList");
        tradeTypeListVal = JSON.stringify(tradeTypeListVal);            
        console.log('tradeTypeListVal :',tradeTypeListVal);
        var compliance = component.find("compliance");
        var complianceRows = compliance.get("v.data");
        console.log('complianceRows :',complianceRows);
        var card = component.find("card");
        if(!card.validateFields()){
            return;
        }
        
        //component.find("compliance").saveTradeCompliances();
        
        var accRecord = card.convertToRecord();
        var action = component.get("c.updateAccount");
        var account = component.get('v.acc');
        for(var apiName in accRecord) {
            account[apiName] =accRecord[apiName];
        }
        action.setParams({ 
            "acc": account,
            "tradeCompliances": JSON.stringify(complianceRows)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var rec = response.getReturnValue();
                console.log(rec);
                var a = component.get('c.init');
                $A.enqueueAction(a);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    EditTradeTypeInstance : function(component, event, helper){
        console.log('Edit trade event captured');
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.tradeTypeList");
        console.log('Edit index'+index);
        var editedTT = AllRowsList[index];
        console.log('Edited TT index'+editedTT.index);
        AllRowsList[index].index = index;
        component.set("v.tradeType", AllRowsList[index]);
        
        //Hide and show detail section on edit.
        var typeDetailComp = component.find("detail");
        var ttDetailSection = typeDetailComp.find('ttDetail');
        var ttButton = typeDetailComp.find('ttButton');
        $A.util.toggleClass(ttDetailSection, 'slds-hide');
        $A.util.toggleClass(ttButton, 'slds-hide');		
    },
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        console.log('Entered Us');
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.tradeTypeList");
        var tt = component.get("v.tradeType");
        console.log('No1:'+AllRowsList[index]);
        console.log('No2:'+tt.licenceNo);
        console.log('Entered Us too');
        //Need to revisit        
        //if(AllRowsList[index].licenceNo === tt.licenceNo){
        if(JSON.stringify(AllRowsList[index]) === JSON.stringify(tt)){
            console.log('Entered Me');
            var typeDetailComp = component.find("detail");
            var ttDetailSection = typeDetailComp.find('ttDetail');
            var ttButton = typeDetailComp.find('ttButton');
            $A.util.addClass(ttDetailSection, 'slds-hide');
            $A.util.removeClass(ttButton, 'slds-hide');
            helper.createObjectData(component, event);	        	
        }
        AllRowsList.splice(index, 1); 
        // set the contactList after remove selected row element  
        component.set("v.tradeTypeList", AllRowsList);
    }
})