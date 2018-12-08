({
	// helper method to retrieve Service Appointment Details
	// to be used by Component
    populateServiceAppointment : function(component) {
        
        // display the spinner
        component.set("v.isProcessing",true);
        
		// set up and execute call to Apex Controller
        var apptId = component.get("v.srvApptId");
        console.log("***[ServiceAppointmentManagerHelper.populateServiceAppointment] Retrieving Details for Appt Id: " + apptId);
        var getAppointmentDetails = component.get("c.getSADetails");
		getAppointmentDetails.setParams(
			{
				"srvAppointmentId": apptId
			}
		);
		getAppointmentDetails.setCallback(this, function(response){
			console.log("***[ServiceAppointmentManagerHelper.populateServiceAppointment] Executing getAppointmentDetails.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				//console.log("***[ServiceAppointmentManagerHelper.populateServiceAppointment] Received Response:");
				//console.log(response.getReturnValue());
                //
                var servAppWrap = response.getReturnValue()
                component.set("v.currSrvAppointment", servAppWrap);

                component.set("v.isTimeBound", servAppWrap.isTimeBound);
                if(servAppWrap.isTimeBound === true) {
                    component.set("v.valueInTimeBound", servAppWrap.isTimeBound);
                }
                console.log("***[ServiceAppointmentManagerHelper.populateServiceAppointment] Current Appointment:");
				console.log(component.get("v.currSrvAppointment"));
			}else{
				console.log("***[ServiceAppointmentManagerHelper.populateServiceAppointment] Failed with state: "+ state);
			}
            // hide the spinner
        	component.set("v.isProcessing",false);
		});
		$A.enqueueAction(getAppointmentDetails);
	},
    saveInstruction : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        
        // set up and execute call to Apex Controller
        var saveInstructions = component.get("c.updateWorkOrder");
        var timeBoundSet = component.get("v.isTimeBound");
        saveInstructions.setParams(
            {
                "woId": component.get("v.currSrvAppointment.workOrderId"),
                "claimId" : component.get("v.currSrvAppointment.claimId"),
                "specIns" : component.get("v.currSrvAppointment.wo.Special_Instructions_New__c"),
                //"specIns" : component.get("v.currSrvAppointment.wo.Special_Instructions__c"),
                "descr" : component.get("v.currSrvAppointment.wo.Description"),
                "applyAll" : component.get("v.appAllWorkOrder"),
                "saId" : component.get("v.srvApptId"),
                "isTimeBound" : component.get("v.isTimeBound"),
                "commStartTime" : component.get("v.currSrvAppointment.timeBoundCommittedStartTime"),
                "commEndTime" : component.get("v.currSrvAppointment.timeBoundCommittedFinishTime")
            }
        );
        saveInstructions.setCallback(this, function(response){
            console.log("***[ServiceAppointmentManagerHelper.saveInstructions] Executing saveInstructions.setCallback()");
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
              if(timeBoundSet === true) {
                component.set("v.valueInTimeBound", timeBoundSet);
              }
            }else{
                console.log("***[ServiceAppointmentManagerHelper.saveInstructions] Failed with state: "+ state);
            }
            // hide the spinner
            component.set("v.isProcessing",false);
        });
        $A.enqueueAction(saveInstructions);
    },
    // helper method to retrieve Service Appointment Details
	// to be used by Component
    getAppointmentCandidates : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        
		// set up and execute call to Apex Controller
        var apptId = component.get("v.srvApptId");
        console.log("***[ServiceAppointmentManagerHelper.getAppointmentCandidates] Retrieving Candidates for Appt Id: " + apptId);
        var getAppointmentCandidates = component.get("c.getSACandidates");
		getAppointmentCandidates.setParams(
			{
				"srvAppointmentId": apptId,
                "workOrderId" : component.get("v.currSrvAppointment.workOrderId"),
                "workType" : component.get("v.currSrvAppointment.workTypeName")
			}
		);
		getAppointmentCandidates.setCallback(this, function(response){
			console.log("***[ServiceAppointmentManagerHelper.getAppointmentCandidates] Executing getAppointmentCandidates.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				// console.log("***[ServiceAppointmentManagerHelper.getAppointmentCandidates] Received Response:");
				// console.log(response.getReturnValue());
				 
                // transform the candidates returned from FSL into format suitable for
                // lightning:tree component
                var candidateTreeItems = this.transformCandidates(response.getReturnValue());
                component.set("v.currSrvAppointmentCandidates", candidateTreeItems);
                console.log("***[ServiceAppointmentManagerHelper.getAppointmentCandidates] Transformed Candidates:");
                console.log(candidateTreeItems);                
			}else{
				console.log("***[ServiceAppointmentManagerHelper.getAppointmentCandidates] Failed with state: "+ state);
			}
            // hide the spinner
        	component.set("v.isProcessing",false);
		});
		$A.enqueueAction(getAppointmentCandidates);
    },
    validateAppointment : function(component) {
        var that = this;
        let earDt = component.get("v.currSrvAppointment.earliestStart");
        let dueDt = component.get("v.currSrvAppointment.dueDate");
        var earStartComp = component.find("earStart");
        let isValid = true;
        if(earDt > dueDt) {
            isValid = false;
            that.displayError(component,"Error", "Due date cannot be less than earliest start date");
        } else {
            isValid = true;
            that.clearError(component);
        }
        return isValid;
    },
    searchAccounts : function(component) {
        component.set("v.isProcessing",true);
        
        // set up and execute call to Apex Controller
        var searchAcc = component.get("c.findTempCandidates");
        searchAcc.setParams(
            {
                "workOrderId" : component.get("v.currSrvAppointment.workOrderId"),
                "tradeType": component.get("v.tradeType"),
                "servArea" : component.get("v.servArea"),
                "nme" : component.get("v.selName")
            }
        );
        searchAcc.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var searchResponse = response.getReturnValue();
                var candidatesTree = [];
                for (var x = 0; x < searchResponse.length; x++) {
                    var currCandidate = searchResponse[x];
                    var newTreeItem = {};
                    newTreeItem.label = currCandidate.Name + '-' + currCandidate.Service_Areas__c;
                    newTreeItem.name = currCandidate.Id;
                    newTreeItem.expanded = false;
                    candidatesTree.push(newTreeItem);
                }
                component.set("v.tempAccounts", candidatesTree);
            }else{
                console.log("***[ServiceAppointmentManagerHelper.getTempMetadata] Failed with state: "+ state);
            }
            // hide the spinner
            component.set("v.isProcessing",false);
        });
        $A.enqueueAction(searchAcc);
    },
    getTempMetadata : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        
        // set up and execute call to Apex Controller
        var apptId = component.get("v.srvApptId");
        var getTempCandidatesMetadata = component.get("c.initTempCandidates");
        getTempCandidatesMetadata.setParams(
            {
                "srvAppointmentId": apptId
            }
        );
        getTempCandidatesMetadata.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var tempMetaRes = response.getReturnValue();
                component.set("v.tempMeta", tempMetaRes);
                component.set("v.tradeType", tempMetaRes.workType);
                component.set("v.servTerrit", tempMetaRes.servTerritory);
                component.set("v.servArea", "");
                component.set("v.selName", "");
                component.set("v.selTempCandidate", "");
                component.set("v.isTempSelected", false);
                component.set("v.tempAccounts", []);

            }else{
                console.log("***[ServiceAppointmentManagerHelper.getTempMetadata] Failed with state: "+ state);
            }
            // hide the spinner
            component.set("v.isProcessing",false);
        });
        $A.enqueueAction(getTempCandidatesMetadata);
    },
    scheduleTempCandidate : function(component) {
        component.set("v.isProcessing",true);
        var that = this;
        // set up and execute call to Apex Controller
        var currAppt = component.get("v.currSrvAppointment");
        console.log(JSON.stringify(currAppt));
        var scheTempCandidate = component.get("c.scheduleTempCandidate");
        scheTempCandidate.setParams(
            {
                "servAppId": currAppt.Id,
                "accId": component.get("v.selTempCandidate"),
                "commStartTime": currAppt.committedStartTime,
                "commEndTime": currAppt.committedFinishTime,
                "workOrderId" : currAppt.workOrderId
            }
        );
        scheTempCandidate.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                component.set("v.schedulingReponseMessage", response.getReturnValue());

                var appEvent = $A.get("e.c:SvcApptMgrScheduledEvent");
                appEvent.setParams({
                    "messageType" : "APPOINTMENT_SCHEDULED"
                });
                appEvent.fire();
                that.showScheduleSuccess(component);

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        that.displayError(component,"Error", errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            // hide the spinner
            component.set("v.isProcessing",false);
        });
        $A.enqueueAction(scheTempCandidate);
    },
    // helper method to transform candidates returned
    // by FSL into a suitable format for lightning:tree
    transformCandidates : function(candidates) {
        // populate first level in tree
        var candidatesTree = [];
        for (var x = 0; x < candidates.length; x++) {
            var currCandidate = candidates[x];
            var newTreeItem = {};
            newTreeItem.label = currCandidate.isCapacityBased ? currCandidate.serviceResourceName + " - (Capacity) - " + currCandidate.percentCapacityUsed + "% Used" : currCandidate.serviceResourceName + " - (Calendar)";
            newTreeItem.name = currCandidate.serviceResourceId;
            newTreeItem.metatext = currCandidate.appointmentSlots.length + " Options, Starting ";
            if(currCandidate.appointmentSlots.length > 0 && currCandidate.appointmentSlots[0].slotStart) {
            	newTreeItem.metatext += moment(this.dateGMTHelper(currCandidate.appointmentSlots[0].slotStart)).format('llll');
            }
            newTreeItem.expanded = false;
            // populate 2nd level in tree
            newTreeItem.items = [];
            for (var y = 0; y < currCandidate.appointmentSlots.length; y++) {
                var currSlot = currCandidate.appointmentSlots[y];
                var newSlotTreeItem = {};
                newSlotTreeItem.label = moment(this.dateGMTHelper(currSlot.slotStart)).format('llll');
                newSlotTreeItem.name = currCandidate.serviceResourceId + "|" + this.dateGMTHelper(currSlot.slotStart);
                newSlotTreeItem.metatext = "Grade: " + parseFloat(currSlot.slotGrade).toPrecision(2);
                newSlotTreeItem.expanded = false;
                newTreeItem.items.push(newSlotTreeItem);
            }
            candidatesTree.push(newTreeItem);
        }
        return candidatesTree;
    },
    // helper function to convert dates returned by the FSL Engine back to GMT
    // this is required to format dates correctly in Javascript as the GMT
    // offset of the local timezone re-adds the GMT offset, in effect doubling
    // the GMT offset for each date/time returned
    dateGMTHelper : function(dateString) {
        
        // get Javascript date representation (moment converts to milliseconds by default)
        var origDate = moment(dateString);
        // console.log("***[ServiceAppointmentManagerHelper.dateGMTHelper] moment.js parsed date: "+ origDate);
        // get the timezone offset in milliseconds
        var origDateOffsetMs = moment().utcOffset()*60000;
        // console.log("***[ServiceAppointmentManagerHelper.dateGMTHelper] moment.js utc date offset: "+ origDateOffsetMs);
        // calculate the original GMT Date
        var convertedDate = moment(origDate - origDateOffsetMs);
        
        return convertedDate;
    },
    showEditScreen : function(component) {
        component.set("v.isEditing", true);
        component.set("v.isScheduling", false);
        component.set("v.isScheduled", false);
        component.set("v.isTempScheduling", false);

    },
    showScheduleScreen : function(component) {
        component.set("v.isEditing", false);
        component.set("v.isScheduling", true);
        component.set("v.isScheduled", false);
        component.set("v.isTempScheduling", false);

    },
    showTempScheduleScreen : function(component) {
        component.set("v.isEditing", false);
        component.set("v.isScheduling", false);
        component.set("v.isTempScheduling", true);

        component.set("v.isScheduled", false);
    },
    showScheduleSuccess : function(component) {
        component.set("v.isTempScheduling", false);
        component.set("v.isEditing", false);
        component.set("v.isScheduling", false);
        component.set("v.isScheduled", true);
    },
    displayError : function(component, title, messg) {
        component.set("v.showError", true);
        component.set("v.errorTitle", title);
        component.set("v.errorMesg", messg);
    },
    clearError : function(component) {
        component.set("v.showError", false);
        component.set("v.errorTitle", "");
        component.set("v.errorMesg", "");

    },
    displaySuccess : function(component, title, messg) {
        component.set("v.showSuccess", true);
        component.set("v.successTitle", title);
        component.set("v.successMesg", messg);
    },
    // helper method to schedule the Service Appointment
	// once candidate has been selected
    scheduleAppointmentCandidate : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        var that = this;
        var currSelection = component.get("v.currSelectedCandidate");
        var currApptId = component.get("v.srvApptId");
        console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Scheduling Appointment for Selection: " + currSelection + " (Appt Id: " + currApptId + ")");
        
        // extract out the scheduling components from selection
        var selectedComponents = currSelection.split("|");
        var srvResourceId = selectedComponents[0];
        var srvTimeStart = selectedComponents[1];
        console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Service Resource Id: " + srvResourceId);
        console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Start (ms): " + srvTimeStart);
        
        console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Booking Resource for Appt Id: " + currApptId);
        var scheduleAppointmentCandidate = component.get("c.scheduleAppointmentForCandidate");
		scheduleAppointmentCandidate.setParams(
			{
				"srvAppointmentId": currApptId,
                "srvResourceId": srvResourceId,
                "apptStartTime": srvTimeStart
			}
		);
        scheduleAppointmentCandidate.setCallback(this, function(response){
			console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Executing scheduleAppointmentCandidate.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Received Response:");
				console.log(response.getReturnValue());	
                // fire an event to indicate a service appointment has been scheduled
        		// Get the application event by using the
        		// e.<namespace>.<event> syntax
        		var appEvent = $A.get("e.c:SvcApptMgrScheduledEvent");
        		appEvent.setParams({
            		"messageType" : "APPOINTMENT_SCHEDULED"
        		});
        		appEvent.fire();
                that.showScheduleSuccess(component);

			}else{
				console.log("***[ServiceAppointmentManagerHelper.scheduleAppointmentCandidate] Failed with state: "+ state);
			}
            // set reponse property on Component
            component.set("v.schedulingReponseMessage", response.getReturnValue());
            // navigate to Scheduling Complete Screen

            // hide the spinner
        	component.set("v.isProcessing",false);
		});
		$A.enqueueAction(scheduleAppointmentCandidate);
    },
    // helper method to schedule the Service Appointment
	// once candidate has been selected
    updateAppointment : function(component, isFindCandidates) {
        console.log("***[ServiceAppointmentManagerHelper.updateAppointment] Updating Appointment...");
        // display the spinner
        component.set("v.isProcessing",true);
        var that = this;
		// set up and execute call to Apex Controller
        var currAppt = component.get("v.currSrvAppointment");
        console.log("***[ServiceAppointmentManagerHelper.updateAppointment] Updating Appt Id: " + currAppt.Id);
        var updateAppointment = component.get("c.updateSADetails");
		updateAppointment.setParams(
			{
				"srvAppointmentId": currAppt.Id,
                "srvSubject": currAppt.subject,
                "srvEarlyStart": currAppt.earliestStart,
                "srvDueDate": currAppt.dueDate
			}
		);
		updateAppointment.setCallback(this, function(response){
			console.log("***[ServiceAppointmentManagerHelper.updateAppointment] Executing getAppointmentCandidates.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				console.log("***[ServiceAppointmentManagerHelper.updateAppointment] Received Response:");
				console.log(response.getReturnValue());
                component.set("v.currSrvAppointment", response.getReturnValue().updatedAppointment);
                // fire an event to indicate a service appointment has been scheduled
        		// Get the application event by using the
        		// e.<namespace>.<event> syntax
        		// Note this should be a separate event type in a
        		// Production implementation
        		var appEvent = $A.get("e.c:SvcApptMgrScheduledEvent");
        		appEvent.setParams({
            		"messageType" : "APPOINTMENT_SCHEDULED"
        		});
        		appEvent.fire();
                if(isFindCandidates === true) {
                    that.showScheduleScreen(component);
                    that.getAppointmentCandidates(component, false);
                } else {
                    that.showTempScheduleScreen(component);
                    that.getTempMetadata(component);
                }
			}else{
				console.log("***[ServiceAppointmentManagerHelper.updateAppointment] Failed with state: "+ state);
                console.log(response.getReturnValue());
			}
            // hide the spinner
        	component.set("v.isProcessing",false);
		});
		$A.enqueueAction(updateAppointment);
    }
})