({
	initiateAttachments : function(component, response) {
        var attachments = response.getReturnValue();
        component.set("v.attachments", attachments);
        var attachmentComps = component.find("attachment");
        attachmentComps.forEach(function(attachmentComp){
            attachmentComp.initiate();
        });
        attachments.forEach(function(attachment) {
            if(attachment.Description === "Bank Deposit Slip"){
                component.set("v.bankDepositDocAdded", true);
            }
            if(attachment.Description === "Work Cover Insurance Policy"){
                component.set("v.workCoverDocAdded", true);
            }
            if(attachment.Description === "Public Liability Insurance Policy"){
                component.set("v.publicLiabilityDocAdded", true);
            }
            if(attachment.Description === "Other Insurance Policy"){
                component.set("v.otherInsuranceDocAdded", true);
            }
            if(attachment.Description === "Police Check Document"){
                component.set("v.policeCheckDocAdded", true);
            }
        });
       component.find("compliance").initiateDocs(); 
	}
})