({
	fetchData: function (component) {
        var action = component.get("c.getClaimContacts"); 
        action.setParams({
            claimId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('doInit Contact : '+response.getReturnValue());
            console.log('doInit Contact : '+JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                component.set("v.listOfCaseContact", response.getReturnValue());
                var dataPromise = response.getReturnValue();

                component.set('v.data', dataPromise)
                component.set('v.rawData', dataPromise);
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        
        $A.enqueueAction(action);        
    },
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
        console.log('responseVal..@getTemplate ');
        var templId = component.get("v.selTemplate");
        console.log('responseVal..@getTemplate ',templId);
        if(!$A.util.isEmpty(templId)){            
            var action = component.get("c.getTemplateDetails");
            action.setParams({"templteId":templId});            
            action.setCallback(this,function(response){
                component.set("v.showLoader", false);
                var responseVal = response.getReturnValue();
                console.log('responseVal..@getTemplate ',responseVal);                
                if(!$A.util.isEmpty(responseVal)){                    
                    component.set("v.templDetail",responseVal);
                    component.set("v.subjTxt",responseVal.Subject);
                    if(!$A.util.hasClass(component.find("emailBodyDiv"), "slds-hide")){                        
                        $A.util.addClass(component.find("emailBodyDiv"), 'slds-hide'); 
                    }                    
                }
            });
            $A.enqueueAction(action);
        }
        else {
            if($A.util.hasClass(component.find("emailBodyDiv"), "slds-hide")){                
                $A.util.removeClass(component.find("emailBodyDiv"), 'slds-hide');
            }
        }
    },
    showExampleModal : function(component) {      
        var modal = component.find("FileModal");
        $A.util.removeClass(modal, 'slds-hide'); 
        //$A.util.addClass(spinner, "slds-show");
    },
    hideExampleModal : function(component) {
        var modal = component.find("FileModal");
        $A.util.addClass(modal, 'slds-hide');
    },
    sendEmails : function(component, event) {
        console.log('sendEmails In.. ');  
        var templateId = component.get("v.selTemplate");
        console.log('templateId ',templateId);      
        var subjMatter = component.get("v.subjTxt");//document.getElementById("subjMatter").value;
        console.log('subjMatter ',subjMatter);
        var bodyContent = component.get("v.BodyContent");
        console.log('BodyContent ',bodyContent);
        //var emailBody = !$A.util.isEmpty(component.get("v.Opportunity").SampleRichText__c) ? component.get("v.Opportunity").SampleRichText__c : '';
        //console.log('emailBody ',emailBody);        
        //if(!$A.util.isEmpty(selRec) && (!$A.util.isEmpty(emailBody) || !$A.util.isEmpty(templateId)) ){ 
        var itemsList=component.get("v.items");
        if(!$A.util.isEmpty(itemsList)){ 
            var conIdsList=component.get("v.conIds");
            if($A.util.isEmpty(templateId) && $A.util.isEmpty(subjMatter) && $A.util.isEmpty(bodyContent)){
            	component.set("v.shoMsg", true);
            	component.set("v.errorMsg", "Please provide Recipient Email Body and Subject");
            }else{
                console.log('---accIdStr--- ', conIdsList);                
                var action = component.get("c.sendAnEmailMsg");
                action.setParams({"templateId":templateId,
                                  "conIdsList":conIdsList,
                                  "subj" : !$A.util.isEmpty(subjMatter) ? subjMatter : '',
                                  "contentBody" : !$A.util.isEmpty(bodyContent) ? bodyContent : ''
                                  });                
                action.setCallback(this,function(response){                    
                    var emailMsgResp = response.getReturnValue();
                    console.log('--emailMsgResp--', emailMsgResp); //isSuccess  errMsg                    
                    if(emailMsgResp.isSuccess){
                        component.set("v.shoMsg", false);
                        component.set("v.shwSucesMsg", true);
                    }
                    else {
                        component.set("v.shoMsg", true);
                        component.set("v.errorMsg", emailMsgResp.errMsg);
                    }                    
                });
                $A.enqueueAction(action);
            }
        }else {
            component.set("v.shoMsg", true);
            component.set("v.errorMsg", "Please provide Recipient, Template or Email Body");
        }
        
    },
})