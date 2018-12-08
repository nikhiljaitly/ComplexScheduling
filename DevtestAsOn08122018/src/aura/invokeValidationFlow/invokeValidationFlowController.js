({
    init : function (component) {
        // Find the component whose aura:id is "flowId"
           var flow = component.find("flowId");
        
        console.log('recordId' + component.get("v.recordId"));
        var inputVariables = [
            {
                name : "sWorkOrderId",
                type : "String",
                value : component.get("v.recordId")
            }
        ];
        
        console.log(inputVariables);
        
        // In that component, start your flow. Reference the flow's Unique Name.
        flow.startFlow("WorkOrder_Validations",inputVariables); 
   
    },
})