({
	init : function(component, event, helper) {
		console.log('***[ServiceAppointmentManagerController.init] Initialising Service Manager Component...');
        //helper.populateServiceAppointment(component);
	},
    // get Candidates for an Appointment
    getCandidates : function(component, event, helper) {
        let isValid = helper.validateAppointment(component);
        if(isValid === true) {
            helper.updateAppointment(component, true);
        }
    },
    // get Temp Candidates for an Appointment
    getTempCandidates : function(component, event, helper) {
        let isValid = helper.validateAppointment(component);
        if(isValid === true) {
            helper.updateAppointment(component, false);   
        }
    },
    // handle selection of a candidate in tree
    handleCandidateSelect: function (component, event) {
        event.preventDefault();
        var treeSelection = event.getParam('name');
        var isCandidateSelected = treeSelection.includes("|");
        console.log('***[ServiceAppointmentManagerController.handleCandidateSelect] Candidate Selected: ' + isCandidateSelected);
        if (isCandidateSelected == true) {
            component.set("v.currSelectedCandidate", treeSelection);
            component.set("v.isSchedBtnDisabled",false);
        	console.log('***[ServiceAppointmentManagerController.handleCandidateSelect] Selected Candidate:' + event.getParam('name'));    
        } else {
            component.set("v.currSelectedCandidate", '');
            component.set("v.isSchedBtnDisabled",true);
        	console.log('***[ServiceAppointmentManagerController.handleCandidateSelect] Selected:' + event.getParam('name'));    
        }
        console.log('***[ServiceAppointmentManagerController.handleCandidateSelect] Schedule Button Disabled:' + component.get("v.isSchedBtnDisabled"));
        console.log('***[ServiceAppointmentManagerController.handleCandidateSelect] Current Selected Candidate:' + component.get("v.currSelectedCandidate"));   
    },
    // schedule an appointment after a candidate has been selected
    scheduleAppointment: function(component, event, helper) {
        helper.scheduleAppointmentCandidate(component);
    },
    // verification script to fire after moment.js library loaded
    afterMomentScriptsLoaded: function(component, event, helper) {
        var testDate = moment("2018-08-09T12:00:00.000Z");
        console.log("***[ServiceAppointmentManagerController.afterMomentScriptsLoaded] moment.js scripts successfully loaded...");
        console.log("***[ServiceAppointmentManagerController.afterMomentScriptsLoaded] Test Date:" + moment(testDate).format('llll'));
    },
    handleSaveInstruction : function (component, event, helper) {
        helper.saveInstruction(component);
    },
    // Close Scheduling Finished Screen
    closeSchedulingScreen : function(component, event, helper) {
        component.set("v.isEditing", true);
        component.set("v.isScheduling", false);
        component.set("v.isScheduled", false);
        component.set("v.schedulingReponseMessage",{});
        helper.populateServiceAppointment(component);
    },
    // handle appointment selection in another component
    handleClaimSrvApptManagerSelectionEvent: function(component, event, helper) {
        console.log("***[ServiceAppointmentManagerController.handleClaimSrvApptManagerSelectionEvent] Handling SA Selection Event...");
        var eventMessageType = event.getParam("messageType");
        if (eventMessageType === "APPOINTMENT_SELECTED") {
            var srvApptSelectedId = event.getParam("selectedAppt");
            // to do: reset current Service Appointment on Component and call helper.populateServiceAppointment(component);
            component.set("v.isApptSelected", true);
            component.set("v.srvApptId", srvApptSelectedId);
            helper.showEditScreen(component);
            helper.populateServiceAppointment(component);
            console.log("***[ServiceAppointmentManagerController.handleClaimSrvApptManagerSelectionEvent] Selected Appointment: " + srvApptSelectedId);
        } else if (eventMessageType === "NON_APPOINTMENT_SELECTED") {
            console.log("***[ServiceAppointmentManagerController.handleClaimSrvApptManagerSelectionEvent] Non Selectable Item Detected... Ignoring...");
        } else {
            console.log("***[ServiceAppointmentManagerController.handleClaimSrvApptManagerSelectionEvent] Unknown Message Detected... Ignoring...");
        }
    },
    // close Candidates Screen
    backFromCandidates: function(component, event, helper) {
        helper.showEditScreen(component);
    },
    updateAppt: function(component, event, helper) {
        console.log('***[ServiceAppointmentManagerController.updateAppt] Updating Appointment...');
    },
    handleSearchAccounts : function(component, event, helper) {
        component.set("v.isTempSelected", false);
        helper.searchAccounts(component);
    },
    handleTempSelect : function(component, event, helper) {
        component.set("v.isTempSelected", true);
        var accId = event.getParam("name");
        component.set("v.selTempCandidate", accId);

    },
    handleScheduleTempCandidates : function(component, event, helper) {
        helper.scheduleTempCandidate(component);
    }
})