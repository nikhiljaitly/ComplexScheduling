({
    init : function(component, event, helper) {
        
        console.log('***[HRGanttChartChildController.init] Initialising HRGanttChartChildController...');
        
        // populate the Gantt Chart
        helper.getClaimScheduledAppointments(component);
        
		// var jsonGanttData = [{"y":"STEPHEN","x":[{"start":7,"duration":2,"color":"#46615e","task":"Task #1"},{"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":2,"color":"#8dc49f","task":"Task #3"}]},{"y":"MOSS","x":[{"start":10,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":1,"color":"#8dc49f","task":"Task #3"},{"duration":4,"color":"#46615e","task":"Task #1"}]},{"y":"VASU","x":[{"start":12,"duration":2,"color":"#727d6f","task":"Task #2"},{"start":16,"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"GORAKATI","x":[{"start":9,"duration":6,"color":"#46615e","task":"Task #1"},{"duration":4,"color":"#727d6f","task":"Task #2"}]},{"y":"KAY","x":[{"start":8,"duration":1,"color":"#8dc49f","task":"Task #3"},{"duration":4,"color":"#46615e","task":"Task #1"}]},{"y":"ROBINSON","x":[{"start":15,"duration":3,"color":"#727d6f","task":"Task #2"}]},{"y":"Julia","x":[{"start":9,"duration":2,"color":"#46615e","task":"Task #1"},{"duration":1,"color":"#727d6f","task":"Task #2"},{"duration":8,"color":"#8dc49f","task":"Task #3"}]},{"y":"Bob","x":[{"start":9,"duration":8,"color":"#727d6f","task":"Task #2"},{"duration":7,"color":"#8dc49f","task":"Task #3"}]},{"y":"Kendra","x":[{"start":11,"duration":8,"color":"#727d6f","task":"Task #2"},{"start":16,"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"Tom","x":[{"start":9,"duration":4,"color":"#46615e","task":"Task #1"},{"duration":3,"color":"#727d6f","task":"Task #2"},{"duration":5,"color":"#8dc49f","task":"Task #3"}]},{"y":"Kyle","x":[{"start":6,"duration":3,"color":"#727d6f","task":"Task #2"}]},{"y":"Anita","x":[{"start":12,"duration":2,"color":"#727d6f","task":"Task #2"},{"start":16,"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"Jack","x":[{"start":8,"duration":10,"color":"#46615e","task":"Task #1"},{"duration":2,"color":"#727d6f","task":"Task #2"}]},{"y":"Kim","x":[{"start":12,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":3,"color":"#8dc49f","task":"Task #3"}]},{"y":"Aaron","x":[{"start":18,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"Alan","x":[{"start":17,"duration":2,"color":"#46615e","task":"Task #1"},{"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":2,"color":"#8dc49f","task":"Task #3"}]},{"y":"Ruth","x":[{"start":13,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":1,"color":"#8dc49f","task":"Task #3"},{"duration":4,"color":"#46615e","task":"Task #1"}]},{"y":"Simon","x":[{"start":10.5,"duration":3,"color":"#727d6f","task":"Task #2"},{"start":17,"duration":4,"color":"#FFE4C4","task":"Task #4"}]}];
        // var jsonGanttData = [{"y":"STEPHEN","x":[{"start":7,"duration":2,"color":"#46615e","task":"Task #1"},{"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":2,"color":"#8dc49f","task":"Task #3"}]},{"y":"MIKE","x":[{"start":10,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":1,"color":"#8dc49f","task":"Task #3"},{"duration":4,"color":"#46615e","task":"Task #1"}]},{"y":"VASU","x":[{"start":12,"duration":2,"color":"#727d6f","task":"Task #2"},{"start":16,"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"BEN","x":[{"start":9,"duration":6,"color":"#46615e","task":"Task #1"},{"duration":4,"color":"#727d6f","task":"Task #2"}]},{"y":"KAY","x":[{"start":8,"duration":1,"color":"#8dc49f","task":"Task #3"},{"duration":4,"color":"#46615e","task":"Task #1"}]},{"y":"JUSTIN","x":[{"start":15,"duration":3,"color":"#727d6f","task":"Task #2"}]},{"y":"Julia","x":[{"start":9,"duration":2,"color":"#46615e","task":"Task #1"},{"duration":1,"color":"#727d6f","task":"Task #2"},{"duration":8,"color":"#8dc49f","task":"Task #3"}]},{"y":"VINCENT","x":[{"start":9,"duration":8,"color":"#727d6f","task":"Task #2"},{"duration":7,"color":"#8dc49f","task":"Task #3"}]},{"y":"KATE","x":[{"start":11,"duration":8,"color":"#727d6f","task":"Task #2"},{"start":16,"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"Tom","x":[{"start":9,"duration":4,"color":"#46615e","task":"Task #1"},{"duration":3,"color":"#727d6f","task":"Task #2"},{"duration":5,"color":"#8dc49f","task":"Task #3"}]},{"y":"CHLOE","x":[{"start":6,"duration":3,"color":"#727d6f","task":"Task #2"}]},{"y":"JESS","x":[{"start":12,"duration":2,"color":"#727d6f","task":"Task #2"},{"start":16,"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"BRANDON","x":[{"start":8,"duration":10,"color":"#46615e","task":"Task #1"},{"duration":2,"color":"#727d6f","task":"Task #2"}]},{"y":"Kim","x":[{"start":12,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":3,"color":"#8dc49f","task":"Task #3"}]},{"y":"ALICE","x":[{"start":18,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":2,"color":"#FFE4C4","task":"Task #4"}]},{"y":"WILLIAM","x":[{"start":17,"duration":2,"color":"#46615e","task":"Task #1"},{"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":2,"color":"#8dc49f","task":"Task #3"}]},{"y":"RUSSELL","x":[{"start":13,"duration":2,"color":"#727d6f","task":"Task #2"},{"duration":1,"color":"#8dc49f","task":"Task #3"},{"duration":4,"color":"#46615e","task":"Task #1"}]},{"y":"CHRIS","x":[{"start":10.5,"duration":3,"color":"#727d6f","task":"Task #2"},{"start":17,"duration":4,"color":"#FFE4C4","task":"Task #4"}]}]; 
        
        /*var jsonGanttData = [{
    							"category": "Electrician",
    							"segments": [{
                                    				"start": "2018-08-15",
      												"end": "2018-08-15",
      												"color": "#46615e",
      												"task": "Disconnect Lights"
    											}]
  							}];*/
        
        /*var jsonGanttData = [ {
    "category": "Electrician",
    "segments": [ {
        "start": "2018-08-01 07:00",
        "end": "2018-08-01 08:00",
      "color": "#b9783f",
      "task": "Disconnect Lights"
    }, {
        "start": "2018-08-01 15:00",
      "end": "2018-08-01 16:00",
      "task": "Reconnect Lights"
    }]
        }, {
      		"category": "Plasterer",
    "segments": [ {
        "start": "2018-08-01 08:00",
        "end": "2018-08-01 13:00",
      "color": "#448e4d",
      "task": "Repair Wall"
    }, {
        "start": "2018-08-02 07:00",
      "end": "2018-08-02 11:00",
      "task": "Final Sanding"
    }]      
        }, {
      		"category": "Painter",
    "segments": [ {
        "start": "2018-08-02 13:00",
        "end": "2018-08-02 17:00",
      "color": "#2f4074",
      "task": "Paint Repaired Wall"
    }]      
        }, {
            "category": "Solar Technician",
    "segments": [ {
        "start": "2018-08-03 09:00",
        "end": "2018-08-03 12:00",
      "color": "#cc4748",
      "task": "Repair Solar Panels"
    }] 
        }];
        
        component.set('v.ganttData', jsonGanttData);*/
        
    },
    handleSelectAll : function(component, event, helper) {
      let isAllSelected = component.get("v.selAll");
      let allValues = [];
      if(isAllSelected === true) {
        let options = component.get("v.options");
        for(let opt = 0 ; opt < options.length ; opt++) {
          allValues.push(options[opt].value);
        }
        component.set("v.value", allValues);
      } else {
        component.set("v.value", []);
      }
    },
    // verification script to fire after moment.js library loaded
    afterMomentScriptsLoaded: function(component, event, helper) {
        var testDate = moment("2018-08-09T12:00:00.000Z");
        console.log("***[HRGanttChartChildController.afterMomentScriptsLoaded] moment.js scripts successfully loaded...");
        console.log("***[HRGanttChartChildController.afterMomentScriptsLoaded] Test Date:" + moment(testDate).format('llll'));
    },
    handleSvcApptMgrScheduledEvent: function(component, event, helper) {
        console.log("[HRGanttChartChildController.handleSvcApptMgrScheduledEvent] Handling SvcApptMgrScheduledEvent...");
        // re-populate the Gantt Chart
        helper.getClaimScheduledAppointments(component);
        //this.init(component, event, helper);
    },
    handleHideModalBox : function(component, event, helper) {
      helper.hideModalBox(component);
    },
    handleShowModalBox : function(component, event, helper) {
      helper.showModalBox(component);
    },
    handleGetTentativeAppointment : function(component, event, helper) {
      component.set("v.modalTitle", "Tentative Appointments");
      component.set("v.isTentativeConfirm", true);
      helper.getTentativeAppointment(component);
    },
    handleGetConfirmAppointment : function(component, event, helper) {
      component.set("v.modalTitle", "Confirmed Appointments");
      component.set("v.isTentativeConfirm", false);
      helper.getConfirmAppointment(component);
    },
    handleConfirmAppointment : function(component, event, helper) {
      helper.confirmAppointment(component);
    },
    handleUnscheduleAppointment : function(component, event, helper) {
      helper.unscheduleAppointment(component);

    }
})