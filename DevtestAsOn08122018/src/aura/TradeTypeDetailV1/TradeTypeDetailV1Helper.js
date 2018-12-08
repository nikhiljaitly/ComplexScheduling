({
	renderRatesByArea: function(component, event, areas) { 
		console.log('Enetred Helper yay renderRatesByArea');
		//alert('Areas'+areas);
		for(var opt in areas){
			var tempArea = areas[opt];
			console.log('tempArea'+tempArea);
			var tempAreaComp = component.find(tempArea);
		    if(tempAreaComp){
                console.log('Entered tempAreaComp'+tempAreaComp);
                $A.util.removeClass(tempAreaComp, 'hideModal');
            }
        	         	
		}


	},

	unRenderRatesByArea: function(component, event, areas) { 
		console.log('Entered Helper unRenderRatesByArea yay');
		//alert('Areas'+areas);

		for(var opt in areas){

			var tempArea = areas[opt];
			//alert(tempArea);
			console.log('tempAreatoHide'+tempArea);
			var tempAreaComp = component.find(tempArea);
		    if(tempAreaComp){
                console.log('Entered tempAreaComptoHide'+tempAreaComp);
                $A.util.addClass(tempAreaComp, 'hideModal');
                tempAreaComp.set("v.value",'');
				
				//var tt = component.get("v.tradeTypeDet");
				//alert(tt);
				//alert('trade val'+tt[tempArea]);
				//alert('trade val'+tt["Brisbane"]);				                
            }
         	
        	         	
		}


	},

	unRenderRatesByChangedValue: function(component, event, options, changes) { 
		console.log('Entered Helper unRenderRatesByChangedValue yay');
		//alert('changes'+changes);
		var areaUnChecked = [];
		var areaChecked = [];
		for(var opt in options){
			var tempVal = options[opt];
			if(!changes.includes(tempVal)){
				//alert('Value Changed'+tempVal);
				areaUnChecked.push(tempVal);
			}else{
				//alert('Value Changed'+tempVal);
				console.log('Entered Unchecked');
				areaChecked.push(tempVal);
				//alert('Value Not Changed'+tempVal);
			}
         	       	         	
		}
		if(areaChecked.length > 0){
			this.renderRatesByArea(component, event, areaChecked);
		}
		if(areaUnChecked.length > 0){
			this.unRenderRatesByArea(component, event, areaUnChecked);	
		}


	},

})