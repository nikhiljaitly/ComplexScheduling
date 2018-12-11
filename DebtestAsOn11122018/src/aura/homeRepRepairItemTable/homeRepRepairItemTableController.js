({
	cancel: function(component, event, helper){
        component.set("v._error", '');
		helper.fireHandleRepairItemsEvent(component, "cancel");
    },
    save: function(component, event, helper){
        if(helper.validateRequiredField(component)){
            helper.fireHandleRepairItemsEvent(component, "save");        
        }
    },
    handleErrors: function(component, event, helper){

        var response =event.getParam('arguments')._server_response;
        helper.handleErrorOfRepairItemsCreation(response, component);
    },
    deleteItem: function(component, event, helper) {
        // Remove selected Row from Repair Items
        console.log("***Handling Row Delete...");
        var source = event.getSource().get("v.name");
        console.log("***Pressed Button: " + source);
        var components = component.get("v._repair_items");
        components.splice(source, 1);
        component.set("v._repair_items", components);
        console.log(components);
    },
    useFloor: function(component, event, helper) {
        // adjust quantity to value of Room Floor
        var source = event.getSource().get("v.name");
        var components = component.get("v._repair_items");
        components[source].Quantity = components[source].room.Floor__c;
        component.set("v._repair_items", components);
    },
    useWall: function(component, event, helper) {
        // adjust quantity to value of Room Floor
        var source = event.getSource().get("v.name");
        var components = component.get("v._repair_items");
        components[source].Quantity = components[source].room.Wall__c;
        component.set("v._repair_items", components);
    },
    usePerimeter: function(component, event, helper) {
        // adjust quantity to value of Room Floor
        var source = event.getSource().get("v.name");
        var components = component.get("v._repair_items");
        components[source].Quantity = components[source].room.Perimeter__c;
        component.set("v._repair_items", components);
    },
    priceChanged: function(component, event, helper) {
        console.log("***Handling Price Changed Event");
        var source = event.getSource();
        console.log("Source:");
        console.log(source);
    }
})