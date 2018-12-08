({
    doInit : function(component, event, helper) {
        var pVals = [
            {text:"India", value: "India"},
            {text:"USA", value: "USA"}
        ];
 
        var dPick = {
            "India" : [
                {text:"Hyderabad", value: "Hyderabad"},
                {text:"Chennai", value: "Chennai"}
            ],
            "USA" : [
                {text:"San Francisco", value: "San Francisco"},
                {text:"Chicago", value: "Chicago"}
            ]
        };
 
        component.set('v.parentOptions', pVals);
        component.set('v.dependentPicklist', dPick);
 
    },
 
    PickChange : function(component, event, helper) {
        var parentValue = component.find('parentPicklist').get('v.value');
        component.set('v.dependentOptions', component.get('v.dependentPicklist')[parentValue]);
 
        if(parentValue != '')
        component.set('v.disabledPick',false);
        else
        component.set('v.disabledPick',true);
    },
    
    
})