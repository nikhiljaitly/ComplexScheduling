({
    doInit: function(component, event, helper) {
        var valueMap = component.get("v.valueMap");
        var options = component.get("v.options");
        var index = 0;
        var checkboxes = helper.cleanData(component.find("checkbox"));
        var children = helper.cleanData(component.find("child"));
        
        options.forEach(function(item) {
            if(valueMap[item.label]){
                var check = checkboxes[index];
                check.set("v.value", true);
                helper.updateValues(component, item, children, true);
            }
            index ++;
        });
        
         children.forEach(function(child){
           child.initiate() 
        });
    },
    onCheck: function(component, event, helper) {
        var name = event.getSource().get("v.name") || 0;
        var value = event.getSource().get("v.value");
        var children = helper.cleanData(component.find("child"));
        var options = component.get("v.options");
        var item = options[name];
        helper.updateValues(component, item, children, value);
    },
    toggle: function(component, event, helper) {
        var index = event.currentTarget.tabIndex;
        var options = component.get("v.options");
        var hideChildren = options[index].hideChildren;
        options[index].hideChildren = !hideChildren;
        component.set("v.options", options);
        
    },
    toggleChildrenDisable: function(component, event, helper) {
        var params = event.getParam('arguments');
        var dataChangeMap;
        if(params) {
            var disabled = params.disabled;
            var checkboxes = helper.cleanData(component.find("checkbox"));
            var options = component.get("v.options");
            
            checkboxes.forEach(
                function(check){
                    check.set("v.disabled", disabled);
                    if(check.get("v.value") && disabled) {
                        dataChangeMap = dataChangeMap || {};
                        check.set("v.value", !disabled);
                        dataChangeMap[options[check.get("v.name")].label] = !disabled;
                    }
                });
            var children = helper.cleanData(component.find("child"));
            children.forEach(function(child) {
                child.updateChildDisabled(disabled);
            });
            if(dataChangeMap){
                console.log("dataChangeMap ", dataChangeMap);
                helper.informDataChange(component, dataChangeMap);
            }
        }
    }
})