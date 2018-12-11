({
    save : function(component,event, helper) {
         var MAXFILESIZE = 750000; /* 1 000 000 * 3/4 to account for base64 */
        var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];
        
        console.log('file '+ file);
        console.log('fileSize '+ file.size);
   
        if (file.size > MAXFILESIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    	          'Selected file size: ' + file.size);
    	    return;
        }
    
        var fr = new FileReader();
        
        var self = this;
       	fr.onload = function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);
            
            console.log('fileContents ' +encodeURIComponent(fileContents));         
            
            component.getEvent("selectedFileContent").setParams({"selectedfile" : fileContents }).fire();
        
    	    helper.upload(component, file, fileContents);
        }

        fr.readAsDataURL(file);
    },
        
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