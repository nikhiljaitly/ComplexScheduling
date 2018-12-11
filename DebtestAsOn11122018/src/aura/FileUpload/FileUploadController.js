/*
 * Author : Mathew Jose
 * Date : 06/03/2018
 * Locker Service Ready code.
 */
({
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0 && component.get("v.fileName") != 'No File Selected..') {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        console.log('Entered file change')
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];

        }
        component.set("v.fileName", fileName);
        if (component.find("fileId").get("v.files").length > 0 && component.get("v.fileName") != 'No File Selected..') {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }

        
    },

    /*handleFilesChange: function(component, event, helper) {
        //var fileName = 'No File Selected..';
        console.log('Entered on change')
        var filesList = event.getSource().get("v.files");
        console.log('File Name'+filesList[0]['name']);
        component.set("v.fileName", filesList[0]['name']);
        var filesList = event.getSource().get("v.files");
        if (filesList.length > 0 && filesList[0]['name'] != 'No File Selected..') {
            fileName = event.getSource().get("v.files")[0]['name'];
            console.log('File Name :'+fileName);
            helper.uploadHelper(component, event);
            //component.set("v.fileName", fileName);

        }else {
            alert('Please Select a Valid File');    
        }
        
    },*/

})