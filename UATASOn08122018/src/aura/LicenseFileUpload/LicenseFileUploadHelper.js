({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        //var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
		var attachList = component.get("v.attachmentList");
		console.log('Attach List'+attachList);
		console.log('Attach List Length'+attachList.length);

        attachList.push({
                        fileDetail: file,
                        Description: component.get("v.fileDescription")
                        });

        component.set("v.attachmentList", attachList);
        alert('your File is added successfully');
        //document.getElementById("licenseUpload").style.display = 'none';
        component.set("v.showLoadingSpinner", false);       
    },
})