({
	navigateToMyComponent : function(component, event, helper) {
		console.log('Entered Redirect');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:FileUpload",
            componentAttributes: {
                parentId : component.get("v.recordId"),
                fileDescription : component.get("v.description"),
                quickActionCreated : true
            }
        });
        evt.fire();
    }
})