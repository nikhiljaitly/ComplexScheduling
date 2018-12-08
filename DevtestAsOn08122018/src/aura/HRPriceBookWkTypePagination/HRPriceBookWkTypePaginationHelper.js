({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.getpbe");
      // set param to method  
        action.setParams({
            'searchWorkType' : component.get("v.WOWorkType"),
            'searchState' : component.get("v.woState"),
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'woRecordId' : component.get("v.woRecordId")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);    
	},
    
    getPriceBookEntries : function(component,next,prev,offset,getInputkeyWord) {
        offset = offset || 0;
        console.log('offset1 ' +offset);
         console.log('##searchKeyWordHelper ' + getInputkeyWord);
        var action = component.get("c.getpbe");
        action.setParams({
            "next" : next,
            "prev" : prev,
            "off" : offset,
            "searchKeyWord": getInputkeyWord
			            
        });
        action.setCallback(this,function(res){
            var state = res.getState();            
            if(state=="SUCCESS"){
                var result = res.getReturnValue();
                component.set('v.offset',result.offst);
                component.set('v.pricebookentry',result.pbe);
                component.set('v.next',result.hasnext);
                component.set('v.prev',result.hasprev);
                console.log('##pricebookentry ' + JSON.stringify(component.get('v.pricebookentry')));
            }
        });        
        $A.enqueueAction(action);
    }
     
})