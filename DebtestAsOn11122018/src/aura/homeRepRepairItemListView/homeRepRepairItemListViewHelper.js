({
	fireRoomChangedEvent : function(component) {
		var roomChangedEvent = component.getEvent("roomChangedEvent"); 
		var currentRoom = component.get("{!v.selectedRoom}");
        
        roomChangedEvent.setParams({
            "_selected_room": currentRoom

        });
        console.log("[homeRepRepairItemListViewHelper] Firing Room Changed Event:");
        console.log(currentRoom);
        roomChangedEvent.fire();
	},
	// when a room is selected in the dropdown list, find
	// corresponding room object
	getCurrentSelectedRoom : function(component, roomId) {
		var roomList = component.get("{!v._rooms}");
		var room; 
		roomList.forEach(function(r) {
			if (r.Id === roomId) {
				room = r;
				return;
			}
		});
		return room;
	}
})