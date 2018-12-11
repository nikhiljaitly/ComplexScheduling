({
    upload: function(component, file, base64Data,parentId,docType,sendDocToClaimHub,IsActivityRequired,claimId,callback) {
        var action = component.get("c.uploadFile");
        action.setParams({
            fileName: file.name,
            base64Data: base64Data,
            contentType: file.type,
            parentId:parentId,
            docType:docType,
            sendDocToClaimHub:sendDocToClaimHub,
            isActivityRequired:IsActivityRequired,
            claimId:claimId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                component.set("v.listOfDocuments", a.getReturnValue());
                callback(true);
            }else{
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Unknown error"+errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    uploadContentVersion: function(component, file, base64Data,parentId,docType,sendDocToClaimHub,IsActivityRequired,claimId,documentId) {
        console.log('All Values :'+file+'--'+base64Data+'--'+parentId+'--'+docType+'--'+sendDocToClaimHub+'--'+claimId+'--'+documentId);
        if(claimId==''){
            claimId = parentId;
        }
        var action = component.get("c.uploadFile");
        action.setParams({
            fileName:'',
            base64Data:'',
            contentType:'',
            parentId:parentId,
            docType:docType,
            sendDocToClaimHub:sendDocToClaimHub,
            isActivityRequired:IsActivityRequired,
            claimId:claimId,
            documentId : documentId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                component.set("v.listOfDocuments", a.getReturnValue());
            }else{
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Unknown error"+errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    show: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    onChangeCheckboxHelper : function(component, event) {
        var onChangevalue = component.find("sendDocToClaimHub").get("v.checked");
        console.log('onChangevalue: ' + onChangevalue);
        component.set("v.isFileUpload", onChangevalue);
	},
    hide:function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})