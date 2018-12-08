/************************************************************************************************************
Name:  ContentVersionFileUploadController
=============================================================================================================
Purpose: Create and updates ContentVersion for Trade
Called by: ContentVersionFileUpload.cmp (Trade Portal component)
===============================================================================================================
History
-----------
VERSION    AUTHOR       DATE             DETAIL        DESCRIPTION
1.0        Vasu         09/02/2018      Created      Home Repairs Claims system
*************************************************************************************************************/

public without sharing class ContentVersionFileUploadController {    
    @AuraEnabled
    public static String saveChunk(string ContentDocumentId, Id parentId, String fileName, String base64Data, String fileId, string fileDescription) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks  
        //
      try{
           system.debug('Entering  saveChunk : ' + 'ContentDocumentId: ' + ContentDocumentId+' parentId: '+parentId+' fileName:'+fileName+' fileId:'+' fileDescription:'+fileDescription);   
           if (fileId == '' || fileId == null) {
               fileId = saveTheFile(ContentDocumentId,parentId, fileName, base64Data, fileDescription);
            }else {
                if(ContentDocumentId != null){
                    updateContentFile(ContentDocumentId, base64Data,fileName);
                    fileId=ContentDocumentId;
                }else{
                    appendToFile(fileId, base64Data);
                }
            } 
        }catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
            system.debug('Exiting  saveChunk : ' + 'Id : ' + Id.valueOf(fileId));      
        
        return fileId;
    }
 
    public static Id saveTheFile(string ContentDocumentId,Id parentId, String fileName, String base64Data, string fileDescription) {
        system.debug('Entering  saveTheFile : ' + 'ContentDocumentId: ' + ContentDocumentId+' parentId: '+parentId+' fileName:'+fileName+' fileId:'+' fileDescription:'+fileDescription);   
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); 
        ContentVersion cv = new ContentVersion();
        List<ContentVersion> cvsUpdated = new List<ContentVersion>();
        if(ContentDocumentId != null && ContentDocumentId != ''){
             cv = [
                SELECT Id,contentDocumentId,VersionData from ContentVersion
                WHERE ContentDocumentId =: ContentDocumentId limit 1
            ]; 
            cv.VersionData = EncodingUtil.base64Decode(base64Data); 
            update cv;
            cvsUpdated = [
                SELECT Id,contentDocumentId,VersionData from ContentVersion
                WHERE ContentDocumentId =: ContentDocumentId limit 1
            ]; 
        }else{
            List<ContentVersion> contentToBeCreated = new List<ContentVersion>();
            List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
            String returnMessage = '';            
            cv.ContentLocation = 'S';
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.Description=fileDescription;
            cv.IsMajorVersion=false;
            contentToBeCreated.add(cv);
    
            //insert content
            if(!contentToBeCreated.isEmpty()){            
            
                insert contentToBeCreated;
                
            }
            //get all inserted Ids
            Set<Id> cIds = new Set<Id>();
            for(ContentVersion c:contentToBeCreated){
                if(c.ContentDocumentId == null){
                    cIds.add(c.Id);
                }
            }
            cvsUpdated = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: cIds];
            //query the content document ids and form content links to be inserted
            for(ContentVersion cnt : cvsUpdated){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cnt.ContentDocumentId;
                cdl.LinkedEntityId = parentId;
                cdl.Visibility = 'AllUsers';
                cdl.ShareType = 'V';
                contentLinkToBeCreated.add(cdl);
            }
            //insert content links
            if(!contentLinkToBeCreated.isEmpty()){
                try{
                    insert contentLinkToBeCreated;
                }catch(Exception ex) {
                    String recordStr = JSON.serialize(contentLinkToBeCreated);
                    File_Helper__e helper = new File_Helper__e();
                    helper.Raw_Request__c = recordStr;
                    helper.Action__c = 'create';
                    EventBus.publish(helper);
                }
                        
            }             
        }
        system.debug('Exiting  saveTheFile : ' + ' cv.Id : ' + cvsUpdated.get(0).ContentDocumentId); 
        return cvsUpdated.get(0).ContentDocumentId;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        system.debug('Entering  appendToFile : ' + 'fileId: ' + fileId);   
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); 
        ContentVersion cv = [
            SELECT Id,contentDocumentId,VersionData from ContentVersion
            WHERE ContentDocumentId =: fileId
        ]; 
        String existingBody = EncodingUtil.base64Encode(cv.VersionData);
        cv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data); 
        system.debug('Exiting  appendToFile: ' + ' cv : ' + cv); 
        update cv;
    }
    @AuraEnabled
    public static string updateFile(String docType,string documentId){
        String ContentDocumentId=[select id from ContentVersion where ContentDocumentId=:documentId].Id;
        ContentVersion cv = new ContentVersion();
		cv.Id=ContentDocumentId;
        cv.Description=docType;
        try {
            update cv;
            return 'Success';
        } catch (DmlException e) {
            return 'Failed';
        } 
    }
    private static void updateContentFile(Id fileId, String base64Data,string fileName) {
        system.debug('Entering  updateContentFile : ' + 'fileId: ' + fileId+' fileName:'+fileName);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); 
        ContentVersion cv = [
            SELECT Id,contentDocumentId,VersionData from ContentVersion
            WHERE ContentDocumentId =: fileId limit 1
        ];
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        system.debug('Exiting  appendToFile: ' + ' cv : ' + cv); 
        update cv;
    }
    @AuraEnabled
    public static string deleteContentFile(string fileId) {
        system.debug('Entering  updateContentFile : ' + 'fileId: ' + fileId);
        String returnMessage = '';
        ContentDocument[] documentFiles = [SELECT Id FROM ContentDocument WHERE Id =: fileId]; 
        try {
            //delete content
            delete documentFiles;
            returnMessage = 'Success';
        } catch (DmlException e) {
            // Process exception here
            returnMessage = 'Success';
            String recordStr = JSON.serialize(documentFiles);
            File_Helper__e helper = new File_Helper__e();
            helper.Raw_Request__c = recordStr;
            helper.Action__c = 'delete';
            EventBus.publish(helper);
        }
        system.debug('Exiting deleteContentFile returnMessage: '+returnMessage);
        return returnMessage;
    }
}