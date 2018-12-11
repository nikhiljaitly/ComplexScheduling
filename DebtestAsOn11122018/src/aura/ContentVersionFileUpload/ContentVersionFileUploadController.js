/*
 * Author : Mathew Jose
 * Date : 06/03/2018
 * Locker Service Ready code.
 */
({
    init : function(component, event, helper) {
            console.log ('entered Init');
        	var comunitityName = window.location.pathname.substring(1,window.location.pathname.indexOf('/s'));
        	component.set("v.comunitityName",comunitityName);        
    },
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0 && component.get("v.fileName") != 'No File Selected..') {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
 	handleUploadFinished: function(component, event, helper) {
        var attachList = component.get("v.attachmentList");
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles',uploadedFiles);
        var documentId=uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var docType = component.get("v.fileDescription");
        console.log(documentId+'---'+fileName+'---'+docType);
       	var action = component.get("c.updateFile");        
        action.setParams({
            docType: docType,
            documentId:documentId
        }); 		
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.getEvent("UpdateContentEvt").setParams({"isUploaded" : true}).fire();
	        console.log('state',state);  
            console.log('in...'+documentId+'---'+fileName+'---'+docType); 
            if(component.isValid() && state == "SUCCESS"){
                attachList.push({
	                        Id: documentId,
	                        fileName: fileName,
	                        contentType: '',
	                        Description: docType	                        
                });
                //test attachlist to show/hide the file upload component.
                console.log('attachList',attachList);
            for (var i = 0; i < attachList.length; i++) { 
                if(attachList[i].Description == 'Work Cover Insurance Policy'){
                    console.log('Work Cover Insurance Policy present');
                    component.set("v.workCoverInsurance", true);
                    //document.getElementById("workCoverUpload").style.display = 'none';
				}
                if(attachList[i].Description == 'Public Liability Insurance Policy'){
                    console.log('Public Liability Insurance Policy present');
                    component.set("v.publicLiabilityInsurance", true);
                    //document.getElementById("publicLiabUpload").style.display = 'none';

                }
                if(attachList[i].Description == 'Other Insurance Policy'){
                    console.log('Other Insurance Policy present');
                    component.set("v.otherInsurance", true);
                    component.set("v.recordId",attachList[i].Id);
                    component.set("v.fileName",attachList[i].fileName);
                    //document.getElementById("otherInsureUpload").style.display = 'none';

                }
                if(attachList[i].Description == 'Bank Deposit Slip'){
                    console.log('Bank Deposit Slip present');
                    component.set("v.bankDeposit", true);
                    //document.getElementById("otherInsureUpload").style.display = 'none';

                }
                if(attachList[i].Description == 'Police Check Document'){
                    console.log('Police Check Document');
                    component.set("v.policeCheck", true);
                    //document.getElementById("otherInsureUpload").style.display = 'none';

                }                
			}  
            component.set("v.attachmentList", attachList);
            }
        }); 
         // enqueue the action
        $A.enqueueAction(action);
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
                if(delMsg == 'Success'){
                    component.set("v.showLoadingSpinner", false);
                    component.getEvent("UpdateContentEvt").setParams({"isUploaded" : true}).fire();
                }
            }
        }); 
         // enqueue the action
        $A.enqueueAction(action);
    }

})