({
	convertMapToString : function(component) {
        var valueMap = component.get("v.valueMap");
        var valueStr = "";
        for(var key in valueMap) {
            if(valueMap[key]) {
                valueStr = key + ";" + valueStr;
            }
        }
        component.set("v.value", valueStr);
		
	}
})