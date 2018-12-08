({
    upload: function(component, file, fileContents) {
        var action = component.get("c.saveTheFile"); 

        action.setParams({
            //parentId: component.get("v.parentId"),
            parentId: 'a0e5D00000153gK',
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });

        action.setCallback(this, function(a) {
           var attachId = a.getReturnValue();
            console.log(attachId);
        });
            
     //   $A.run(function() {
            $A.enqueueAction(action); 
       // });
    }
})