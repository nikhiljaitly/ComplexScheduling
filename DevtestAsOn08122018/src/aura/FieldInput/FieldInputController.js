({
	updateValueMap : function(component, event, helper) {
        var type = component.get("v.type");
        if(type === "number" || type === "email" 
           || type === "currency" || type === "richTextarea" 
           || type === "textarea" || type === "text"
           || type === "datetime" || type === "multiPicklist"
           || type === "date" || type === "phone" 
           || type === "abn" ){
           helper.checkIsRequired(component);
        }
        var onchange = component.get('v.onchange');
        // Invoke onchange function if it is provided
        if (onchange) {
            onchange(component, event, helper);
        }
        if(component.get("v.type") === "date" && component.get("v.value") === "") {
            component.set("v.value", undefined);
        }
		var fieldInfoEvent = component.getEvent ("fieldInfo");
        fieldInfoEvent.setParams({"type": "fieldValueUpdate", "payload": {"fieldComp": component}});
		fieldInfoEvent.fire();
        
	},
    checkIsRequired : function(component, event, helper) {
        helper.checkIsRequired(component);
    },
    updateValueMapForSelect : function(component, event, helper) {
        helper.checkIsRequired(component);
		var fieldInfoEvent = component.getEvent ("fieldInfo");
        fieldInfoEvent.setParams({"type": "fieldValueUpdate", "payload": {"fieldComp": component}});
		fieldInfoEvent.fire();
    },
    addErrors : function(component, event, helper) {
		var params = event.getParam('arguments');
        if(params){
            var message = params.message;
            helper.setErrorMessage(component, message);
            console.log("message", message);
        }
    }
})