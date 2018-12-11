({
	doInit: function(component, event, helper) {
        var getList = component.get('v.items'); 
        //console.log('getList'+getList);
        var getElement = component.get('v.element');
        //console.log('getElement'+getElement);
        var getElementIndex = getList.indexOf(getElement);
       
        if(getList.length > 0 && getList != undefined){
            for (var i = 0; i < getList.length; i++) {                               
                if((getList[i].ContentDocument.LatestPublishedVersion.Description == getElement)){
                    component.set('v.condition',false);
                }               
            }            
        }
        
    }
})