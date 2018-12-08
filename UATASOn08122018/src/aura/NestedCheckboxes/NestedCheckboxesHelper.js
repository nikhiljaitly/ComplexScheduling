({
	informDataChange : function(component, dataMap) {
		var dataChangeEvent = component.getEvent("dataChanged");

        dataChangeEvent.setParams({"type": "dataChanged", "payload": dataMap});
        dataChangeEvent.fire();
	},
    updateValues : function(component, item, children, value) {
        if(item.children){
            var cmp = this.findChildren(children, item);
            if(cmp){
                cmp.updateChildDisabled(value); 
            }
        }
        
        // fire event.
        var dataChangeMap = {}; 
        dataChangeMap[item.label] = value;
        console.log("dataChangeMap ", dataChangeMap); 
        this.informDataChange(component, dataChangeMap);
    },
    cleanData : function(data) {
        if(!data){
            return [];
        }
        if(!data.length){
            return [data];
        }
        return data;
    },
    findChildren : function(children, item) {
        var cmp;
        children.forEach(function(childCMP) {
            if(childCMP.get("v.options")[0].label === item.children[0].label) {
                cmp = childCMP;
            } 
        });
        return cmp;
    }
})