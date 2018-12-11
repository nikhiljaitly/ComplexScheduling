({
	sendRoomSelection : function(component, event) {
		var roomId = component.get("v.selectedRecordId");
        console.log(roomId[0]);
        
        var action = component.getEvent("sendRoomId");
        
        action.setParams({"roomId" : roomId[0]});
        
        action.fire();
	}
})