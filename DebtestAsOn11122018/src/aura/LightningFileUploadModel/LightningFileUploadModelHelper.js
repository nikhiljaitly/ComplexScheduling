({
	loadExistingAttachments : function(component,documentId,docType) {
        var action = component.get("c.getFiles"); 
        action.setParams({
            recordId: component.get("v.recordId"),
            documentId:documentId,
            docType:docType
        });
        action.setCallback(this, function(response) {
            var returnedValues = response.getReturnValue();
            console.log("returnedValues", returnedValues);
            component.set("v.attachments", returnedValues);
			var existingIds = component.find("attId").get("v.selectedRows");
            var uploadedAttachments = component.get("v.uploadedAttachments");
            uploadedAttachments.forEach(function(atta){
               existingIds.push(atta.documentId );
            });
            if(existingIds) {
                component.find("attId").set("v.selectedRows", existingIds);
            }
        });
        $A.enqueueAction(action);
	}
})