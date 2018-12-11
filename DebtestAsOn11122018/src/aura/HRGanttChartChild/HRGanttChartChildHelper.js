({
	// helper method to retrieve Service Appointment Details
	// to be used by Component
    getClaimScheduledAppointments : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        
		// set up and execute call to Apex Controller
        var claimId = component.get("v.claimId");
        
        console.log("***[HRGanttChartChildHelper.getClaimScheduledAppointments] Retrieving SA's for Claim Id: " + claimId);
        var getClaimScheduledAppointments = component.get("c.getClaimScheduledAppointments");
		getClaimScheduledAppointments.setParams(
			{
				"claimId": claimId
			}
		);
		getClaimScheduledAppointments.setCallback(this, function(response){
			console.log("***[HRGanttChartChildHelper.getClaimScheduledAppointments] Executing getClaimScheduledAppointments.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				console.log("***[HRGanttChartChildHelper.getClaimScheduledAppointments] Received Response:");
				console.log(response.getReturnValue());
				 
                // transform the appointments returned into format suitable for
                // gantt chart
                //var claimAppointmentsPayload = JSON.parse(response.getReturnValue(SAPayload));
                var candidateChartItems = this.transformAppointments(response.getReturnValue());
                component.set("v.ganttData", candidateChartItems);
                component.set("v.reRenderChartFlag", false);
                console.log("***[HRGanttChartChildHelper.getClaimScheduledAppointments] Transformed Appointments:");
                console.log(candidateChartItems);                
			}else{
				console.log("***[HRGanttChartChildHelper.getClaimScheduledAppointments] Failed with state: "+ state);
			}
            // hide the spinner
        	component.set("v.isProcessing",false);
		});
		$A.enqueueAction(getClaimScheduledAppointments);
    },
    confirmAppointment : function(component) {
        var selAppointments = component.get("v.value");
        component.set("v.isProcessing",true);
        var that = this;
        var confAppointments = component.get("c.confirmAppointments");
        confAppointments.setParams(
            {
                "appIds": selAppointments
            }
        );
        component.set("v.isInProcess", true);
        confAppointments.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.isInProcess", false);
            if(component.isValid() && state === "SUCCESS"){
               that.hideModalBox(component);
               component.set("v.selAll", false);
               var appEvent = $A.get("e.c:SvcApptMgrScheduledEvent");
               appEvent.setParams({
                    "messageType" : "APPOINTMENT_CONFIRMED"
               });
               appEvent.fire();
            }else if (state === "ERROR") {
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
        $A.enqueueAction(confAppointments);
    },
    unscheduleAppointment : function(component) {
        var selAppointments = component.get("v.value");
        component.set("v.isProcessing",true);
        var that = this;
        var unScheAppointments = component.get("c.unScheduleAppointments");
        unScheAppointments.setParams(
            {
                "appIds": selAppointments
            }
        );
        component.set("v.isInProcess", true);

        unScheAppointments.setCallback(this, function(response){
            component.set("v.isInProcess", false);

            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
               component.set("v.selAll", false);
               that.hideModalBox(component);
               var appEvent = $A.get("e.c:SvcApptMgrScheduledEvent");
               appEvent.setParams({
                    "messageType" : "APPOINTMENT_UNSCHEDULED"
               });
               appEvent.fire();
            }else if (state === "ERROR") {
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
        $A.enqueueAction(unScheAppointments);
    },
    displayError : function(component, title, messg) {
        component.set("v.showError", true);
        component.set("v.errorTitle", title);
        component.set("v.errorMesg", messg);
    },
    getTentativeAppointment : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        var that = this;
        // set up and execute call to Apex Controller
        var claimId = component.get("v.claimId");
        var tentativeAppointments = component.get("c.getTentativeAppointments");
        tentativeAppointments.setParams(
            {
                "claimId": claimId
            }
        );
        tentativeAppointments.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var appointResponse = response.getReturnValue();
                var appoints = [];
                for(var cnt = 0 ; cnt < appointResponse.length ; cnt++) {
                    appoints.push({ label : appointResponse[cnt].servApp.Work_Type_Name__c+' - '+appointResponse[cnt].servApp.AppointmentNumber, 
                                    value : appointResponse[cnt].servApp.Id});
                }
                component.set("v.options",appoints);
                if(appoints.length === 0) {
                    component.set("v.modalError", "No Appointments to Confirm");
                    component.set("v.disableModalConfirm", true);
                } else {
                    component.set("v.modalError", "");
                    component.set("v.disableModalConfirm", false);                    
                }
                that.showModalBox(component);

            }else{
                console.log("***[ServiceAppointmentManagerHelper.getTempMetadata] Failed with state: "+ state);
            }
            // hide the spinner
            component.set("v.isProcessing",false);
        });
        $A.enqueueAction(tentativeAppointments);
    },
    getConfirmAppointment : function(component) {
        // display the spinner
        component.set("v.isProcessing",true);
        var that = this;
        // set up and execute call to Apex Controller
        var claimId = component.get("v.claimId");
        var confirmAppointments = component.get("c.getConfirmedAppointments");
        confirmAppointments.setParams(
            {
                "claimId": claimId
            }
        );
        confirmAppointments.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var appointResponse = response.getReturnValue();
                var appoints = [];
                for(var cnt = 0 ; cnt < appointResponse.length ; cnt++) {
                    appoints.push({ label : appointResponse[cnt].servApp.Work_Type_Name__c+' - '+appointResponse[cnt].servApp.AppointmentNumber + ' - ' + appointResponse[cnt].servApp.Status, 
                                    value : appointResponse[cnt].servApp.Id});
                }
                component.set("v.options",appoints);
                if(appoints.length === 0) {
                    component.set("v.modalError", "No Appointments to Unschedule");
                    component.set("v.disableModalConfirm", true);
                } else {
                    component.set("v.modalError", "");
                    component.set("v.disableModalConfirm", false);                    
                }
                that.showModalBox(component);

            }else{
                console.log("***[ServiceAppointmentManagerHelper.getTempMetadata] Failed with state: "+ state);
            }
            // hide the spinner
            component.set("v.isProcessing",false);
        });
        $A.enqueueAction(confirmAppointments);
    },

    hideModalBox : function(component) {
      component.set("v.showModal", false);
    },
    showModalBox : function(component) {
      component.set("v.showModal", true);
    },
    // helper method to transform appointments returned
    // into a suitable format for gantt
    transformAppointments : function(appointments) {
        // populate first level in tree
        console.log('Appointments:'+appointments);
        var ganttCategories = [];
        for (var x = 0; x < appointments.length; x++) {
            var newCategory = {};
            newCategory.category = appointments[x].workTypeName + "\n" + appointments[x].accName;
            //Added by Nikhil on 01/12/2018
          /*  if(appointments[0].assignedToName != null){
                newCategory.category = newCategory.category + "\n " + appointments[0].assignedToName+"\n "+"(Calendar)";
            }
            else if(appointments[0].assignedToName != null && appointments[0].capacityBased == true){
                        newCategory.category = newCategory.category + "\n " + appointments[0].assignedToName+"\n "+"(Capacity)";
                    }
                else 
                    newCategory.category = newCategory.category + "\n " + appointments[0].assignedToNameTier2+"\n "+"(Tier 2)";
          	*/
          
            // populate 2nd level in tree
            newCategory.segments = [];
            for (var y = 0; y < appointments[x].srvApptList.length; y++) {
                var currAppt = appointments[x].srvApptList[y];
                var newSegment = {};
                // newSegment.color = this.getGanttColor(appointments[x].workTypeName);
               // newSegment.task = currAppt.srvApptSubject;
                newSegment.status = currAppt.srvApptStatus;
                newSegment.apptNumber = currAppt.srvApptNumber;
                // if scheduled show scheduled dates
                // otherwise use earliest start and due date
    /* Comment Starts here for current assignment of Dates            
                if (currAppt.schedStart != null ) {
                    newSegment.start = moment(currAppt.schedStart).format("YYYY-MM-DD HH:mm");
                	newSegment.end = moment(currAppt.schedFinish).format("YYYY-MM-DD HH:mm");
                    newSegment.assignedToName = currAppt.assignedToName;
                    
                    // adding the Capacity flag to Identify Capacity Resources on the Gantt
                    if(currAppt.capacityBased == true){
                        newCategory.category = newCategory.category + "\n " + currAppt.assignedToName+"\n "+"(Capacity)";
                    }
                    else if (currAppt.assignedToName != null && currAppt.capacityBased == false) {
                    newCategory.category = newCategory.category + "\n " + currAppt.assignedToName+"\n "+"(Calendar)";    
                    }   
                    
                  
                 //   newCategory.category = newCategory.category + "\n " + currAppt.assignedToName;
                 //   newSegment.color = this.getGanttColor(appointments[x].workTypeName);
                    
                    newSegment.color = this.getGanttColor(currAppt.srvApptStatus);
                    
                    // For the logic of Tier 2 Trades on Gantt Chart
                } else if(currAppt.committedStartDate != null){
                    newSegment.start = moment(currAppt.committedStartDate).format("YYYY-MM-DD HH:mm");
                	newSegment.end = moment(currAppt.committedEndDate).format("YYYY-MM-DD HH:mm");
                    newSegment.assignedToName = currAppt.assignedToNameTier2;
                    
                    newCategory.category = newCategory.category + "\n " + currAppt.assignedToNameTier2+"\n "+"(Tier 2)";
                   // newSegment.color = this.getGanttColor(appointments[x].workTypeName);
                    
                    newSegment.color = this.getGanttColor(currAppt.srvApptStatus);
                    
                    
                } */
                
   // New code for current assignment of Dates       
   
                if(currAppt.committedStartDate != null){
                    newSegment.start = moment(currAppt.committedStartDate).format("YYYY-MM-DD HH:mm");
                    newSegment.end = moment(currAppt.committedEndDate).format("YYYY-MM-DD HH:mm");
                    newSegment.startDD = moment(currAppt.committedStartDate).format("DD-MM-YYYY HH:mm");
                    newSegment.endDD = moment(currAppt.committedEndDate).format("DD-MM-YYYY HH:mm");

        if (currAppt.assignedToName != null) {
                newSegment.assignedToName = currAppt.assignedToName;
                /*if (currAppt.capacityBased == true) {
                    newCategory.category = newCategory.category + "\n " + currAppt.assignedToName+"\n "+"(Capacity)";
                    }
                    else {
                        newCategory.category = newCategory.category + "\n " + currAppt.assignedToName+"\n "+"(Calendar)"; 
                }*/
        }
        else {
            newSegment.assignedToName = currAppt.assignedToNameTier2;
           // newCategory.category = newCategory.category + "\n " + currAppt.assignedToNameTier2+"\n "+"(Tier 2)";
        }

         newSegment.color = this.getGanttColor(currAppt.srvApptStatus);

       }         

        else if (currAppt.schedStart != null ) {

            newSegment.start = moment(currAppt.schedStart).format("YYYY-MM-DD HH:mm");
            newSegment.end = moment(currAppt.schedFinish).format("YYYY-MM-DD HH:mm");
            newSegment.startDD = moment(currAppt.schedStart).format("DD-MM-YYYY HH:mm");
            newSegment.endDD = moment(currAppt.schedFinish).format("DD-MM-YYYY HH:mm");
        if (currAppt.assignedToName != null) {
                newSegment.assignedToName = currAppt.assignedToName;
                /*if (currAppt.capacityBased == true) {
                    newCategory.category = newCategory.category + "\n " + currAppt.assignedToName+"\n "+"(Capacity)";
                    }
                    else {
                        newCategory.category = newCategory.category + "\n " + currAppt.assignedToName+"\n "+"(Calendar)"; 
                    }*/
        }
        else {
            newSegment.assignedToName = currAppt.assignedToNameTier2;
           // newCategory.category = newCategory.category + "\n " + currAppt.assignedToNameTier2+"\n "+"(Tier 2)"; 
            }
         
         newSegment.color = this.getGanttColor(currAppt.srvApptStatus);

         }

                
                else{
                    newSegment.start = moment(currAppt.earliestStart).format("YYYY-MM-DD HH:mm");
                	newSegment.end = moment(currAppt.dueDate).format("YYYY-MM-DD HH:mm");
                    newSegment.startDD = moment(currAppt.earliestStart).format("DD-MM-YYYY HH:mm");
                    newSegment.endDD = moment(currAppt.dueDate).format("DD-MM-YYYY HH:mm");

                    newSegment.color = this.getGanttColor(currAppt.srvApptStatus);
                    
                }
                //newSegment.start = moment(currAppt.schedStart).format("YYYY-MM-DD HH:mm");
                //newSegment.end = moment(currAppt.schedFinish).format("YYYY-MM-DD HH:mm");
                newCategory.segments.push(newSegment);
            }
            ganttCategories.push(newCategory);
        }
        return ganttCategories;
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
    // helper function to return a color for Gantt Chart segment(s)
  /*  getGanttColor: function(workTypeName) {
        var returnColor = "";
        switch(workTypeName) {
            case "Electrician":
                returnColor = "#b9783f"
                break;
                
            case "Plasterer":
                returnColor = "#448e4d";
                break;
                
            case "Painter":
                returnColor = "#2f4074"
                break;
                
            case "Unscheduled":
                returnColor = "#8b8878"
                break;
                
            default:
                returnColor = "#cc4748";
                break;
        }
        return returnColor;
    } */

    getGanttColor: function(srvApptStatus) {
        var returnColor = "";
        switch(srvApptStatus) {
            case "Tentative":
                returnColor = "#F4D03F"
                break;
                
            case "New":
                returnColor = "#A2D9CE";
                break;
                
            case "Confirmed":
                returnColor = "#85C1E9"
                break;
                
            case "Awaiting Confirmation":
                returnColor = "#1132D5"
                break;
                
            case "Cannot Complete":
                returnColor = "#EC7063"
                break; 
            
             case "Completed":
                returnColor = "#58D68D"
                break;     
                
            case "Cancelled":
               returnColor = "#18090E"
                
            default:
                returnColor = "#cc4748";
                break;
        }
        return returnColor;
    }


})