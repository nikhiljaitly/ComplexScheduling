({
	initiateFiles : function(component, event, helper) {
        var fileRows = component.find("ttFile");
        fileRows.forEach(function(fileRow) {
            fileRow.initiate();
        });
	}
})