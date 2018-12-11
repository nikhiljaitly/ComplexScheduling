({
	init : function(cmp, event, helper) {
        
        // row level actions
        var actions = [
            { label: 'Edit', name: 'sa_edit' },
            { label: 'Schedule', name: 'sa_schedule' },
            { label: 'Dependency', name: 'sa_dependency' }
        ];
		 cmp.set('v.tableColumns', [
               {label: 'App #', fieldName: 'AppointmentNumber', type: 'text'},
               //{label: 'Work Type', fieldName: 'WorkType', type: 'text'},
               {label: 'Subject', fieldName: 'Subject', type: 'text'},
               // {label: 'Earliest Start', fieldName: 'EarliestStartTime', type: 'text'}
               { type: 'action', typeAttributes: { rowActions: actions } }
            ]);
        
        cmp.set('v.schedTableColumns', [
               {label: 'Start Time', fieldName: 'slotStartTime', type: 'text'},
               {label: 'Finish Time', fieldName: 'slotFinishTime', type: 'text'},
               {label: 'Grade', fieldName: 'slotGrade', type: 'double'},
               // {label: 'Earliest Start', fieldName: 'EarliestStartTime', type: 'text'}
               // { type: 'action', typeAttributes: { rowActions: actions } }
            ]);
        
        /*cmp.set('v.claimAppointments', [{
                id: 'a',
                AppointmentNumber: 'SA-1795',
                WorkType: 'Electrician',
                Subject: 'Disconnect Downlight',
                EarliestStartTime: '16/07/2018 07:00' 
            },
            {
                id: 'a',
                AppointmentNumber: 'SA-1796',
                WorkType: 'Electrician',
                Subject: 'Re-connect Downlight',
                EarliestStartTime: '16/07/2018 07:00'
            }]);*/
        
        // get the service appointments attached to claim
        var recordId = cmp.get("v.recordId");
		console.log("***Record Id = " + recordId);
        var getAppointments = cmp.get("c.getCaseServiceAppointments");
		getAppointments.setParams(
			{
				"appointmentId": recordId
			}
		);
		getAppointments.setCallback(this, function(response){
			console.log("***Executing getAppointments.setCallback()");
			var state = response.getState();
			if(cmp.isValid() && state === "SUCCESS"){
				//component.set("v.claimAppointments", response.getReturnValue());
				console.log("***Received Response:");
				console.log(response.getReturnValue());
                // do a simple transformation and assign return value to
                // datatable data source
                var returnedRecords = response.getReturnValue();
                var transformedRecords = [];
                var x;
                for (x=0; x < returnedRecords.length; x++) {
                    //console.log(returnedRecords[x]);
                    var transformedRecord = {
                        Id: returnedRecords[x].Id,
                        AppointmentNumber: returnedRecords[x].AppointmentNumber,
                        WorkType: returnedRecords[x].WorkType.Name,
                        Subject: returnedRecords[x].Subject,
                        EarliestStartTime: $A.localizationService.formatDate(returnedRecords[x].EarliestStartTime, "DD MMM YYYY, hh:mm:ss a"),
                        EarliestStartTimeRaw: returnedRecords[x].EarliestStartTime,
                        DueDate: $A.localizationService.formatDate(returnedRecords[x].DueDate, "DD MMM YYYY, hh:mm:ss a"),
                        DueDateRaw: returnedRecords[x].DueDate,
                        Status: returnedRecords[x].Status,
                        SchedStartTime: $A.localizationService.formatDate(returnedRecords[x].SchedStartTime, "DD MMM YYYY, hh:mm:ss a"),
                        SchedStartTimeRaw: returnedRecords[x].SchedStartTime,
                        SchedEndTime: $A.localizationService.formatDate(returnedRecords[x].SchedEndTime, "DD MMM YYYY, hh:mm:ss a"),
                        SchedEndTimeRaw: returnedRecords[x].SchedEndTime,
                        Address: returnedRecords[x].Address
                    };
                    transformedRecords.push(transformedRecord);
                }
                console.log("***Transformed Records");
                console.log(transformedRecords);
                cmp.set('v.claimAppointments', transformedRecords);
			}else{
				console.log("Failed with state: "+ state);
			}
		});
		$A.enqueueAction(getAppointments);
	},
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'sa_edit':
                cmp.set("v.currentRow", row);
                cmp.set("v.isEditOpen", true);
                //alert('Editing Service Appointment: ' + JSON.stringify(row));
                break;
            case 'sa_schedule':
                //var rows = cmp.get('v.mydata');
                //var rowIndex = rows.indexOf(row);
                //rows.splice(rowIndex, 1);
                //cmp.set('v.mydata', rows);
                //alert('Scheduling Service Appointment: ' + JSON.stringify(row));
                cmp.set("v.currentRow", row);
                cmp.set("v.isSchedOpen", true);
                break;
            case 'sa_dependency':
                alert('Adding a New Dependency...');
        }
    },
    openEditModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isEditOpen", true);
   },
 
   closeEditModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isEditOpen", false);
      component.set("v.currentRow", null);
   },
 
   saveAppt: function(component, event, helper) {
      alert('Appointment Successfully Saved');
      component.set("v.isEditOpen", false);
      component.set("v.currentRow", null);
   },
   closeSchedModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isSchedOpen", false);
      component.set("v.srvAppointmentSlots", null);
   },
 
   scheduleAppt: function(component, event, helper) {
      //alert('Appointment Successfully Scheduled');
      //component.set("v.isSchedOpen", false);
      //component.set("v.currentRow", null);
      
      var getAppointmentSlots = component.get("c.getAppointmentSlots");
		getAppointmentSlots.setParams(
			{
				"appointmentId": component.get("v.currentRow.Id")
			}
		);
		getAppointmentSlots.setCallback(this, function(response) {
			console.log("***Executing getAppointmentSlots.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				//component.set("v.claimAppointments", response.getReturnValue());
				//console.log("***Received Response:");
				//console.log(response.getReturnValue());
                //alert('Retrieved Best Appointment Slot: ' + JSON.stringify(response.getReturnValue()[0]));
                var returnedAppts = response.getReturnValue();
                var transformedAppts = [];
                var x;
                for (x=0; x < returnedAppts.length; x++) {
                    //console.log(returnedRecords[x]);
                    var transformedAppt = {
                        slotNumber: returnedAppts[x].slotNumber,
                        slotGrade: returnedAppts[x].slotGrade.toString(),
                        //slotStartTime: $A.localizationService.formatDate(returnedAppts[x].slotStartTime, "DD MMM YYYY, hh:mm:ss a"),
                        slotStartTime: returnedAppts[x].slotStartTime,
                        slotStartTimeRaw: returnedAppts[x].slotStartTime,
                        //slotFinishTime: $A.localizationService.formatDate(returnedAppts[x].slotFinishTime, "DD MMM YYYY, hh:mm:ss a"),
                        slotFinishTime: returnedAppts[x].slotFinishTime,
                        slotFinishTimeRaw: returnedAppts[x].slotFinishTime,
                    };
                    transformedAppts.push(transformedAppt);
                }
                console.log("***Transformed Appointments");
                console.log(transformedAppts);
                component.set("v.srvAppointmentSlots", transformedAppts);
                } else {
				console.log("Failed with state: "+ state);
                console.log(response.getError());   
				}
        	});
			$A.enqueueAction(getAppointmentSlots);
   	  },
})