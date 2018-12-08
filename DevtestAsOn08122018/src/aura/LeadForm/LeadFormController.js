({
	doRedirect : function(component, event, helper) {
		var leadId = helper.getJsonFromUrl()["LeadId"];
        console.log("leadId", leadId);
        if(leadId) {
            component.set("v.leadId", leadId);
        }
	}
})