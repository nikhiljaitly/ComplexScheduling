({
	removeItem : function(component, event, helper) {
        var removeLabel = event.getSource().get("v.label");
        var items = component.get("v.items");
        component.set("v.items",
                      items.filter(function(item) {
                          return item !== removeLabel;
                      }));
	},
    initValues : function(component, event, helper) {
        var initOnce = component.get("v.initOnce");
        if(!initOnce) {
            component.set("v.initOnce", true);
            var value= component.get("v.value");
            if(!value){
                return;
            }
            var valueList = value.split(";");
            var items = [];
            valueList.forEach(function(item){
                if(item){
                    items.push(item.trim());
                }
            });
            component.set("v.items", items);
            
        } else {
            $A.enqueueAction(component.get("v.change"));
        }
    },
    updateValues : function(component, event, helper) {
        var initOnce = component.get("v.initOnce");
        if(!initOnce) {
            return;
        }
      	var items = component.get("v.items");
        var value = "";
        items.forEach(function(item) {
            value = item + ";" +value;
        });
        component.set("v.value", value);
    },
    addItem : function(component, event, helper) {
		var stateSelection = component.find("states");
        var state = stateSelection.get("v.value");
        var otherInput = component.find("otherInput");
        var otherValue = otherInput.get("v.value");
        if(otherValue === "" || !otherValue) {
            return;
        }
        var value = state + "-" + otherValue;
        var items = component.get("v.items");
        items.push(value);
        component.set("v.items", items);
        otherInput.set("v.value", "");
	}
})