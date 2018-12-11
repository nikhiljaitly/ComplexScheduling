({
	handleMessage: function (component, event, helper) {
        var message = event.getParams();
        console.log("***Message received from Gantt...");
        console.log(message);
        /*var navigationEvent = $A.get("e.force:navigateToSObject");
	    navigationEvent.setParams({
			"recordId": message.payload.id,
      		"slideDevName": "details"
    	});
	    navigationEvent.fire();*/
    },

    handleError: function (component, event, helper) {
        var error = event.getParams();
        console.log(error);
    }
})