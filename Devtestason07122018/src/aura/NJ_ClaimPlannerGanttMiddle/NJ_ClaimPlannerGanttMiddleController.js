({
	handleInit : function(component, event, helper) {
    helper.initClaimPlanner(component);     
	},
	handleSvcApptMgrScheduledEvent : function(component, event, helper) {
		helper.getClaimData(component);
	}

})