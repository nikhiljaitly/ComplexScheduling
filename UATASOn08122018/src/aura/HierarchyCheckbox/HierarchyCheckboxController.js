({
    doInit: function(component, event, helper) {
        var valueStr = component.get('v.value');
        var valueMap = {};
        if(!valueStr){
            
        } else {
            var values = valueStr.split(";");
            
            values.forEach(function(value) {
                if(value.length)
                    valueMap[value] = true;
            });  
        }
        var nestedOptions = component.find("nestedOptions");
        
        component.set("v.valueMap", valueMap);
        if(nestedOptions){
            nestedOptions.initiate();
        }
    },
    updateOptions : function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params) {
            var options = params.options;
            component.find("nestedOptions").set("v.options", options);
        }
    }, 
    updateValue : function(component, event, helper) {
        var valueMap = component.get("v.valueMap") || {};
        var params = event.getParams();
        if(params && params.type === "dataChanged") {
            var payload = params.payload;
            for(var key in payload){
                valueMap[key] = payload[key];
            }
        }
        component.set("v.valueMap", valueMap);
        helper.convertMapToString(component);
        $A.enqueueAction(component.get("v.change"));
    }
})