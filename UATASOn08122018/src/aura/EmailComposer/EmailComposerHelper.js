({
    getEmailTempaltes : function(component, event) {
        var action = component.get("c.getTemplates");
        //action.setParams({"divisionId":selectedDivision});        
        action.setCallback(this,function(response){
            var loadResponse = response.getReturnValue();
            console.log('templates..!',loadResponse);            
            if(!$A.util.isEmpty(loadResponse)){                
                component.set('v.templates',loadResponse);                 
            }
        });
        $A.enqueueAction(action);
    },
    getTemplate : function(component, event) { 
        var templId = component.get("v.selTemplate");
        if(!$A.util.isEmpty(templId)) {            
            var action = component.get("c.getTemplateDetails");
            action.setParams({"templteId":templId});            
            action.setCallback(this,function(response){
                component.set("v.showLoader", false);
                var responseVal = response.getReturnValue();
                if(!$A.util.isEmpty(responseVal)){
                    component.set("v.templDetail",responseVal);
                    component.set("v.subjTxt",responseVal.Subject);
                    //component.find("txtBody").set("v.disabled", true);
                    //component.find("subjectText").set("v.disabled", true);
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.templDetail", null );
            component.set("v.subjTxt","");
            component.set("v.bodyContent", "");
        }
    },
    clearEmailComposer: function(component, event) {
    	component.set("v.shwSucesMsg", false);
        component.set("v.shoMsg", false);
        //component.set("v.contacts", []);
        component.set("v.selectedLookUpRecords", []);
        component.set("v.selTemplate",'');
        component.set("v.templDetail",[]);
        component.set("v.subjTxt","");
        component.set("v.bodyContent","");
        component.find("attachmentModal").find("attId").set("v.selectedRows", []);
	},
    sendEmails : function(component, event) {
        console.log('sendEmails In.. ');  
        var templateId ;
        component.set("v.shoMsg", false);
        component.set("v.message", "");
        var subjMatter = component.get("v.subjTxt");
        var bodyContent = component.get("v.bodyContent");
        var templDetail = component.get("v.templDetail");
       
        if(templDetail) {
            templateId = templDetail.Id;
        } 
        
        var contacts=component.get("v.contacts");
        var listSelectedItems=component.get("v.selectedLookUpRecords");
        var listSelectedItemsForCC=component.get("v.selectedLookUpRecordsForCC");
        console.log('Hi...');
        console.log(JSON.stringify(listSelectedItemsForCC));
        if(!$A.util.isEmpty(contacts) || !$A.util.isEmpty(listSelectedItems)){
            console.log("contacts", contacts);            
            var conIdsList=[];
            var emailList=[];
            var emailCCList=[];
            contacts.forEach(function(contact){
               conIdsList.push(contact.Id );
            });
            console.log(JSON.stringify(listSelectedItems));            
            listSelectedItems.forEach(function(emailAdd){
               emailCCList.push(emailAdd.Email);
            });  
            listSelectedItemsForCC.forEach(function(emailAdd){
               emailList.push(emailAdd.Email);
            }); 
            console.log(emailList);
            
            if($A.util.isEmpty(templateId) && $A.util.isEmpty(subjMatter) && $A.util.isEmpty(bodyContent)){
            	component.set("v.shoMsg", true);
            	component.set("v.message", "Please provide Recipient Email Body and Subject");
            }else{
                var selectdAttachments 
                	= component.find("attachmentModal").find("attId").get("v.selectedRows");
				
                console.log('---accIdStr--- ', conIdsList);                
                var action = component.get("c.sendAnEmailMsg");
                action.setParams({"templateId":templateId,
                                  "idList":conIdsList,
                                  "emailList":emailList,
                                  "emailCCList":emailCCList,
                                  "subj" : !$A.util.isEmpty(subjMatter) ? subjMatter : '',
                                  "contentBody" : !$A.util.isEmpty(bodyContent) ? bodyContent : '',
                                  "attIds" : selectdAttachments,
                                  "claimId" : component.get("v.recordId")
                                  });
                action.setCallback(this,function(response){                    
                    var emailMsgResp = response.getReturnValue();
                    console.log('--emailMsgResp--', emailMsgResp); //isSuccess  errMsg                    
                    if(emailMsgResp.isSuccess){
                        /*component.set("v.shoMsg", true);
                        component.set("v.shwSucesMsg", true);
                        component.set("v.message", "Email has been sent!");*/
                        
                        component.set("v.shwSucesMsg", false);
                        component.set("v.shoMsg", false);
                        component.set("v.contacts", []);
                        component.set("v.selectedLookUpRecords", []);
                        component.find("attachmentModal").find("attId").set("v.selectedRows", []);
                        var modal = component.find("FileModal");
                        $A.util.addClass(modal, 'slds-hide');
                        // Success
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type" : "success",
                            "message":"Email has been sent successfully!"
                        });
                        toastEvent.fire();  
                        $A.get('e.force:refreshView').fire();
                    }
                    else {
                        component.set("v.shoMsg", true);
                        component.set("v.message", emailMsgResp.errMsg);
                    }                    
                });
                $A.enqueueAction(action);
            }
        }else {
            component.set("v.shoMsg", true);
            component.set("v.message", "Please provide Recipient, Template or Email Body");
        }
        
    }
})