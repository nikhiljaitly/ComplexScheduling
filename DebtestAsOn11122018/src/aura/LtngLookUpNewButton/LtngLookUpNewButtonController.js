({
createRoom : function(component, event, helper) {
    var action = component.get("c.createNewRoom");
    var room = component.get("v.room");
    var woRecordId = component.get("v.woRecordId");
    console.log(room);
    
    var roomNameval = component.get("v.room.Name");
    console.log('roomNameval ' + roomNameval);
    if(roomNameval == ''){ 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type" : "error",
            "message": "Room Name required. Please complete Room Name field."
        });
        toastEvent.fire();
        
    }
    
    action.setParams({
        "room":room,
        "worecordId":woRecordId
    });
    action.setCallback(this,function(response){
        var state = response.getState();
        console.log('CompState ' + state);
        var toastEvent = $A.get("e.force:showToast");
        if(component.isValid() && state === "SUCCESS"){
            toastEvent.setParams({
                "title": "Success!",
                "message": "The record has been created successfully."
            });
           // toastEvent.fire();
            component.set("v.room",{'sobjectType':'Room__c',
                                    'Name':'',
                                    'Floor__c':'',
                                    'Height__c':'0',
                                    'Length__c':'0',
                                    'Width__c':'0'                                   
                                   });
        }
    });

   $A.enqueueAction(action);
  
    // call the event   
    if(roomNameval != ''){   
        var compEvent = component.getEvent("HRHideCreateRoomComp");    
        // set the clearance flag to the event attribute.  
        compEvent.setParams({"roomCreatedFlag" : "Yes" });    
        // fire the event  
        compEvent.fire();
    }
    
},

    cancelRoom : function(component, event, helper) {
        var compEvent = component.getEvent("HRHideCreateRoomComp");
        // set the clearance flag to the event attribute.  
        compEvent.setParams({"roomCreatedFlag" : "NOT" });    
        // fire the event  
        compEvent.fire();    
    }  

})