/*
 * Author : Mathew Jose
 * Date : 06/03/2018
 * Locker Service Ready code.
 */
({
    doInit: function(component, event, helper) {
      helper.initiateData(component);
    },
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0 && component.get("v.fileName") != 'No File Selected..') {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        console.log('Entered file change')
        var fileName;//='No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        console.log('length '+component.find("fileId").get("v.files").length);
        console.log('file '+component.get("v.fileName"));
        component.set("v.fileName", fileName);
        if (component.find("fileId").get("v.files").length > 0 && component.get("v.fileName") != 'No File Selected..') {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }       
    },
    removeRow: function(component, event, helper) {
         // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        var ContentDocumentId='';
        if(component.get("v.recordId") != ''){
            ContentDocumentId = component.get("v.recordId");
        }
        console.log('Entered here 123'+ContentDocumentId);
        var action = component.get("c.deleteContentFile");        
        action.setParams({
            fileId: ContentDocumentId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var delMsg = response.getReturnValue();
                console.log('Entered here delMsg '+delMsg);
                if(delMsg == 'Success') {
                    component.set("v.recordId", null);
                    component.set("v.fileName", '');
                    component.set("v.showLoadingSpinner", false);
                }
            }
        }); 
         // enqueue the action
        $A.enqueueAction(action);
    }

})