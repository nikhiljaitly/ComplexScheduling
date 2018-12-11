({
	init : function(component, event, helper) {
		console.log("***Initialising homeRepRepairItemListView...");
	},
	// update dropdown list when list of rooms against case changes
	roomsChanged : function(component, event, helper) {
		console.log("***[homeRepRepairItemListView] roomsChanged callback");

		var rmList = component.get("{!v._rooms}");
		console.log("***Received Rooms: ");
		console.log(rmList);

		if (rmList.length > 0) {
			// dynamically generate rooms picklist
			var roomList = component.find("RoomSelectList");
			var selectOptions = [];
			roomList.set("v.options", []);
			rmList.forEach(function(room) {
				var opt = {
					"class": "optionClass", 
					label: room.Name, 
					value: room.Id
				}
				selectOptions.push(opt);
			});
			component.find("RoomSelectList").set("v.options", selectOptions);		
			var currValue = roomList.get("v.value");
			console.log("***Current Room Value = " + currValue);
			component.set("v.selectedRoom", helper.getCurrentSelectedRoom(component, currValue));
			console.log("***Initial Selected Room:");
			console.log(component.get("{!v.selectedRoom}"));
			// fire event for selected room
			helper.fireRoomChangedEvent(component);
		}	
	},
	// update current selected room when dropdown list selection changes
	onChange: function(component, event, helper) {
		var roomList = component.find("RoomSelectList");
		var currValue = roomList.get("v.value");
		component.set("v.selectedRoom", helper.getCurrentSelectedRoom(component, currValue));
		console.log("***Changed Selected Room:");
		console.log(component.get("{!v.selectedRoom}"));
		// fire event for selected room
		helper.fireRoomChangedEvent(component);

	}
		
})