({
	handleOnChange : function(component, event, helper) {
        component.set( "v.selectedRecordId", event.getParams( "fields" ).value );
        //component.set( "v.recordId", event.getParams( "sWorkOrder" ).value );
        helper.sendRoomSelection(component);
    },
})