/*
 * Author : Mathew Jose
 * Date : 03/06/2018
 * Locker Service Ready code.
 */
({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    initiateData: function(component) {
        var parentId = component.get("v.parentId");
        var fileDescription = component.get("v.fileDescription");
        var attachmentList = component.get("v.attachmentList") || [];
        attachmentList.forEach(function(attachment) {
            if(fileDescription === attachment.ContentDocument.LatestPublishedVersion.Description
               	&& parentId === attachment.LinkedEntityId ) {
                component.set("v.recordId", attachment.ContentDocumentId);
                component.set("v.fileName", attachment.ContentDocument.LatestPublishedVersion.Title);
            }
        });
    },
    uploadHelper: function(component, event) {        
		console.log('Source Id'+component.getGlobalId())
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
               
        
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 			
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var attachList = component.get("v.attachmentList");
        var fileDesc = component.get("v.fileDescription");
        var getchunk = fileContents.substring(startPosition, endPosition);
        
        var ContentDocumentId='';
        if(component.get("v.recordId") != ''){
            ContentDocumentId = component.get("v.recordId");
        }
        console.log('Entered here 123'+ContentDocumentId);
        var action = component.get("c.saveChunk");        
        action.setParams({
            ContentDocumentId : ContentDocumentId,
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            fileId: ContentDocumentId,
            fileDescription: fileDesc
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id
            console.log('Entered here 123'+response.getReturnValue())
            attachId = response.getReturnValue();
            console.log('attachId'+attachId);
            //push the file into attachment list
            if(attachId){
	            attachList.push({
	                        Id: attachId,
	                        fileName: file.name,
	                        contentType: file.type,
	                        Description: fileDesc	                        
                });
            }            
            component.set("v.attachmentList", attachList);
           

            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {                    
					alert('your File is uploaded successfully');
                    component.set("v.recordId", response.getReturnValue());
                    component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }
})