({
	toggleAttachmentModal: function(component, event, helper) {
		var modal = component.find("attachmentModal");
        $A.util.toggleClass(modal, 'slds-hide');
	},
    handleUploadFinished: function(component, event, helper) {        
        var uploadedFiles = event.getParam("files");
        console.log(uploadedFiles[0].documentId);
        var documentId=uploadedFiles[0].documentId;
        var docType='WorkOrder';
        component.set("v.uploadedAttachments", uploadedFiles);
        helper.loadExistingAttachments(component,documentId,docType);
    },
    doInit : function(component, event, helper) {
        helper.loadExistingAttachments(component,'','');
    },
    updateSelectedText: function(component, event, helper){
        console.log("selected rows", component.get("v.selectedAttachments"));
    }
})