({
    doInit : function(component, event, helper) {
        var valueMap = component.get("v.valueMap");
        valueMap = valueMap || {};
        component.set("v.valueMap", valueMap);
        helper.getInitForm(component).then(
            function(response) {
                helper.handleFormResults(component, response);
            }
        );
    },
    updateWorkTypeOptions : function(component, event) {
      	var params = event.getParams();
        var workTypes = params.arguments.workTypes;
        var workTypeList = [];
        if(workTypes) {
            workTypeList = workTypes.split(";");
        }
        var options = workTypeList.reduce(function(results, item){ results.push({"label":item, "value": item}); return results;}, [])
        var card = component.find("card");
        var sections = card.find("sections");
        sections.find("fieldInput").forEach(function(fieldInput){
            if(fieldInput.get("v.apiName") === "Trade_Type__c.Trade_Type__c"){
                fieldInput.set("v.options", options);
            }
        });
        
    },
    handleUploadFinished: function (component, event) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    }
})