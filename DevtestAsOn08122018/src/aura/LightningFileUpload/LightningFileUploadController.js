({
    onFileUploaded:function(component,event,helper){
        var MAX_FILE_SIZE = 1551859712;
        var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            helper.show(component,event);
            var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            if (file.size > MAX_FILE_SIZE) {
                    alert('File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' +
                      'Selected file size: ' + file.size);
                    return;
            }else{
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                var parentId = component.get("v.recordId");
                var docType = component.get("v.selectedValue");
                var sendDocToClaimHub=false;
                var IsActivityRequired=component.get("v.IsActivityRequired");
                var claimId=component.get("v.claimId");
                console.log('IsActivityRequired',IsActivityRequired);
                if(!$A.util.isUndefined(component.find("sendDocToClaimHub"))){
                    var sendDocToClaimHub = component.find("sendDocToClaimHub").get("v.checked");
                }                
                console.log('sendDocToClaimHub :'+sendDocToClaimHub);
                    helper.upload(component, file, content,parentId,docType,sendDocToClaimHub,IsActivityRequired,claimId, function(answer) {
                    console.log(answer);
                        if (answer) {
                            helper.hide(component,event);
                            // Success
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "type" : "success",
                                "message":"files has been uploaded successfully!"
                            });
                            toastEvent.fire();                             
                            $A.get('e.force:refreshView').fire();
                        }
                        else{
                            // Failure
          
                        }
                    });
            	}
                
            }
            reader.readAsDataURL(file);
        }
        else{
            helper.hide(component,event);
        }
        } else {
            //alert('Please update the invalid form entries and try again.');
        }
        
    },
    handleUploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var documentId=uploadedFiles[0].documentId;
        var parentId = component.get("v.recordId");
        var docType = component.get("v.selectedValue");
        var sendDocToClaimHub=false;
        var IsActivityRequired=component.get("v.IsActivityRequired");
        var claimId=component.get("v.claimId");
        console.log('IsActivityRequired',IsActivityRequired);
        if(!$A.util.isUndefined(component.find("sendDocToClaimHub"))){
            var sendDocToClaimHub = component.find("sendDocToClaimHub").get("v.checked");
        }
        console.log('IsActivityRequired call Update');
        helper.uploadContentVersion(component, '','',parentId,docType,sendDocToClaimHub,IsActivityRequired,claimId,documentId);
        component.set("v.uploadedAttachments", uploadedFiles);
        $A.get('e.force:refreshView').fire();
    },
    onChangeSendDocToClaimHub : function(component, event, helper) {
          helper.onChangeCheckboxHelper(component, event);
    },
    onChange: function (cmp, evt, helper) {
        if(cmp.find('fieldId').get('v.value') == ''){
            cmp.set('v.disabled',true);
        }else{
            cmp.set('v.disabled',false);
        }
    },
    doInit : function(component, event, helper){
        console.log('doInit:');
        component.set("v.selectedValue",'');
        if(!$A.util.isUndefined(component.find("sendDocToClaimHub"))){
            component.find("sendDocToClaimHub").set("v.checked",false);
        }
        //Fetch Picklist Values
        var actionPickList = component.get("c.fetchCustomMetaDataValues"); 
        actionPickList.setParams({
            platform : component.get("v.Platform")
        });
        actionPickList.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                console.log('platform :',component.get("v.Platform"))
                console.log('doInit:',response.getReturnValue());
                if(!$A.util.isEmpty(response.getReturnValue())){ 
                    component.set("v.docType", response.getReturnValue());                    
                    var action = component.get("c.fetchContentDocument"); 
                    action.setParams({
                        caseId : component.get("v.recordId")
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                             if(!$A.util.isEmpty(response.getReturnValue())){                    
                                component.set("v.listOfDocuments", response.getReturnValue());
                             }
                        }
                        else if(state === "ERROR"){
                            console.log('A problem occurred: ' + JSON.stringify(response.error));
                        }
                    });        
        			$A.enqueueAction(action);
                    
                }
            }else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(actionPickList);
    }
})