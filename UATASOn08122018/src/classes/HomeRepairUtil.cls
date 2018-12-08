public without sharing class HomeRepairUtil{
    public static ServiceAppointment createServiceAppointment(String workOrderId){
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=workOrderId;
        sa.Status='New';
        sa.SchedEndTime=System.today().addDays(+2);
        sa.SchedStartTime=System.now();
        return sa;
    }
    public static Map<string,List<RESTAttachmentWrapper>> getContentDocuments(Set<string> roomIds) {
         System.Debug(LoggingLevel.DEBUG, 'Entering HomeRepairUtil with Param roomIds : '+roomIds);
         Map<string,List<RESTAttachmentWrapper>> attachmentMap=new Map<string,List<RESTAttachmentWrapper>>();
         List<RESTAttachmentWrapper> attWrapperList=new List<RESTAttachmentWrapper>();
         for (ContentDocumentLink att: [SELECT id,ContentDocument.FileType,ContentDocument.FileExtension,ContentDocument.LatestPublishedVersion.VersionData, LinkedEntity.Name, ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.CreatedDate,
                                        ContentDocument.LatestPublishedVersion.LastModifiedBy.Name,ContentDocument.LatestPublishedVersion.Description From ContentDocumentLink
                                        where linkedEntityID IN: roomIds]) {
            
            if(attachmentMap.containsKey(att.linkedEntityID)) {                
                attWrapperList.add(new RESTAttachmentWrapper(att,false));
                attachmentMap.put(att.linkedEntityID, attWrapperList);
            }else{
                attWrapperList=new List<RESTAttachmentWrapper>();
                attWrapperList.add(new RESTAttachmentWrapper(att,false));
                attachmentMap.put(att.linkedEntityID, attWrapperList);
            }
        }
        system.debug('Exiting HomeRepairUtil return AttachmentMap: '+attachmentMap);
        return attachmentMap;
    }
    private static void createTaskTradePortal(string objectId,string docType,string claimId){
        // New Task object to be created
        Task[] newTask = new Task[0];
        string taskDescription='';
        List<User> userList=[Select Id,Name,Email 
                                        FROM User
                                        WHERE Name = 'HR Claims'
                                        Limit 1];
        List<Document_Type__mdt> documentTypeList = new List<Document_Type__mdt>();
        documentTypeList=Database.query('SELECT Activity_Description__c FROM Document_Type__mdt WHERE MasterLabel = \''+ docType + '\'');    
        if(documentTypeList.size() > 0){
            taskDescription=documentTypeList[0].Activity_Description__c;
        }
        
        String objectType = String.valueOf(Id.valueOf(objectId).getsobjecttype());
		system.debug('objectType :' + objectType);
        if(objectType == 'WorkOrder'){
            WorkOrder wo = new WorkOrder();
            wo = [select Id, WorkOrderNumber, Service_Resource__r.name from WorkOrder where Id = :objectId  Limit 1];
            taskDescription = taskDescription + ' from ' + wo.Service_Resource__r.name + ' for Work Order ' + wo.WorkOrderNumber;
            system.debug('taskDescription ' +taskDescription);
        }
        newTask.add(new Task(priority = 'Low',
                             status = 'Not Started',
                             subject =taskDescription,
                             IsReminderSet = true,
                             Type = 'Email',
                             Description=taskDescription,
                             OwnerId = userList[0].id,
                             ActivityDate=System.Today()+1,
                             ReminderDateTime = System.now()+1,
                             WhatId =  claimId));
                insert newTask; 
    }
    public static List<ContentDocumentLink> contentDocumentList(Set<String> objectIds) {
        return [SELECT id,ContentDocumentId,ContentDocument.LatestPublishedVersion.Title,ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.LastModifiedBy.Name,ContentDocument.Description,ContentDocument.CreatedDate FROM ContentDocumentLink where LinkedEntityId IN: objectIds order by ContentDocument.LatestPublishedVersion.CreatedDate DESC limit 5];
    }
    public static List<ContentDocumentLink> upsertContentAttachment(String parentId,List<RESTAttachmentWrapper> attachments) {
        System.Debug(LoggingLevel.DEBUG, 'Entering HomeRepairUtil with Param attachments : '+attachments);
        Map<string,string> attachmentRoomMap=new Map<string,string>();
        List<ContentVersion> contentToBeCreated = new List<ContentVersion>();
        List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
        Set<string> cvIds=new Set<string>();
        Set<String> contentDocumentIds=new Set<String>();
        Map<string,string> contentDocumentMap=new Map<string,string>();
        
        for(RESTAttachmentWrapper att : attachments){
            if(att.attachmentId != null) { 
                cvIds.add(att.contentDocumentId);
            }
        }
        system.debug('cvIds ' +cvIds);
        if(cvIds.size() > 0){
            for(ContentVersion cv : [SELECT Id,contentDocumentId from ContentVersion where contentDocumentId IN : cvIds]){
                contentDocumentMap.put(cv.contentDocumentId,cv.Id);
            }
        }
        
        for(RESTAttachmentWrapper att : attachments){
            ContentVersion cv = new ContentVersion();
            if(att.attachmentId == null) {                            
                cv.ContentLocation = 'S';
                cv.VersionData = EncodingUtil.base64Decode(att.fileData); //Blob.valueOf(att.fileData);                            
                cv.Title = att.name;
                cv.IsMajorVersion = false;
                cv.PathOnClient = '/' + att.name+'.'+att.fileType;
                contentToBeCreated.add(cv);
                attachmentRoomMap.put(att.name,parentId);                               
            }else{                
                if(contentDocumentMap.containsKey(att.contentDocumentId)){
                    if(att.isDeleted == false){
                         cv.Id=contentDocumentMap.get(att.contentDocumentId);
                         cv.VersionData = EncodingUtil.base64Decode(att.fileData); 
                         cv.Title = att.name;
                    }else{
                        contentDocumentIds.add(att.contentDocumentId);
                    }
                 }               
            }
        }
        
        if(!contentToBeCreated.isEmpty()){
          try{
                upsert contentToBeCreated;
           }Catch(DMLException de){
               system.debug('The following exception has occurred: '+de.getMessage()); 
           }
        }
        
        
        //get all inserted Ids
        Set<Id> cIds = new Set<Id>();
        for(ContentVersion c:contentToBeCreated){
            if(attachmentRoomMap.containsKey(c.Title)){
                cIds.add(c.Id);
            }
        } 
        
        //query the content document ids and form content links to be inserted
        for(ContentVersion cnt : [SELECT Id,Title, ContentDocumentId FROM ContentVersion WHERE Id IN: cIds]){
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cnt.ContentDocumentId;
            cdl.LinkedEntityId = parentId; 
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            contentLinkToBeCreated.add(cdl);
        }
        system.debug('contentLinkToBeCreated : '+contentLinkToBeCreated);
        //Delete content
        if(!contentDocumentIds.isEmpty()){
            deleteContentVersion(contentDocumentIds);
        }
        system.debug('Exiting HomeRepairUtil return ContentDocumentLink : '+contentLinkToBeCreated);
        return contentLinkToBeCreated;
    }
 
    public static String deleteContentVersion(Set<String> contentDocumentIds) {
        System.Debug(LoggingLevel.DEBUG, 'Entering HomeRepairUtil with Param contentDocumentIds : '+contentDocumentIds);
        String returnMessage = '';
        //check if content document Ids are not empty
        if(!contentDocumentIds.isEmpty()){  
            ContentDocument[] documentFiles = [SELECT Id FROM ContentDocument WHERE Id IN: contentDocumentIds]; 
            try {
                //delete content
                delete documentFiles;
                returnMessage = 'Success';
            } catch (DmlException e) {
                // Process exception here
                returnMessage = 'Error';
            }
        }
        system.debug('Exiting HomeRepairUtil with returnMessage: '+returnMessage);
        return returnMessage;
    }
    public static String deleteRepairItems(Set<String> deleteIds,String objectName) {
        System.Debug(LoggingLevel.DEBUG, 'Entering HomeRepairUtil with Param deleteIds : '+deleteIds+' objectName:'+objectName);
        String returnMessage = '';
        if(objectName=='Room__c'){
            List<WorkOrderLineItem> woliList=new List<WorkOrderLineItem >();
            Set<String> claimIds=new Set<String>();
            List<WorkOrder> workOrderList =new List<WorkOrder>();
            List<Room__c> roomList = Database.query('SELECT Id,Claim__c,(Select id from Work_Order_Line_Items__r) FROM  Room__c WHERE Id IN : deleteIds');
            for(Room__c rm : roomList){
                if(rm.Work_Order_Line_Items__r.size() > 0){
                    woliList.addAll(rm.Work_Order_Line_Items__r);
                }
                claimIds.add(rm.Claim__c);
            }
            try {
                delete roomList;
            } catch (DmlException e) {
                // Process exception here
                returnMessage = 'Delete Room failure : '+e.getMessage();
            }
            try {
                delete woliList;
            } catch (DmlException e) {
                // Process exception here
                returnMessage = 'Delete WorkOrderLineItems failure : '+e.getMessage();
            }
            List<WorkOrder> workOrderClaimList = [select id,CaseId,WorkTypeId,WorkType.Name,TotalPrice,Sort_Order__c,(select id,WorkTypeId,WorkType.Name,Room__c,Room__r.Name,PricebookEntryId,PricebookEntry.Name,Cash_Settled__c,Contents_Type__c,UnitPrice,TotalPrice,Quantity,Description from WorkOrderLineItems) from WorkOrder where WorkOrder.RecordType.Name='Home Repair Trades' and CaseId IN : claimIds];
            for(WorkOrder wo : workOrderClaimList){            
                if(wo.WorkOrderLineItems.size() == 0){
                    workOrderList.add(wo);
                }
            }
            //insert content
            if(!workOrderList.isEmpty()){                
                try {
                    delete workOrderList;
                } catch (DmlException e) {
                    // Process exception here
                    returnMessage = 'Delete WorkOrder failure : '+e.getMessage();
                }
            }
        }else{
            List<sObject> sobjList = Database.query('SELECT Id FROM '+ objectName +' WHERE Id IN : deleteIds');
            try {
                delete sobjList;
            } catch (DmlException e) {
                // Process exception here
                returnMessage = 'failure : '+e.getMessage();
            }
        }
        returnMessage = 'success';
        system.debug('Exiting HomeRepairUtil with returnMessage: '+returnMessage);
        return returnMessage;
    }
    public static string updateContentFile(String docType, Boolean sendDocToClaimHub,String parentId,Boolean isActivityRequired, string documentId, string claimId) {
        String ContentDocumentId=[select id from ContentVersion where ContentDocumentId=:documentId].Id;
        ContentVersion cv = new ContentVersion();
		cv.Id=ContentDocumentId;
        cv.Send_to_ClaimHub__c = sendDocToClaimHub;
        cv.Description=docType;
        try {
            update cv;
            if(isActivityRequired){
                createTaskTradePortal(parentId,docType,claimId);
            }
            return 'Success';
        } catch (DmlException e) {
            return 'Failed';
        }        
    }
    public static string uploadContentFile(String fileName, String base64Data, String contentType,String parentId,String docType, Boolean sendDocToClaimHub,Boolean isActivityRequired, string claimId) { 
        System.Debug(LoggingLevel.DEBUG, 'Entering HomeRepairUtil with Param fileName : '+fileName+' contentType:'+contentType+' parentId:'+parentId+' docType:'+docType+' isActivityRequired : '+isActivityRequired+' claimId :'+claimId);
        List<ContentVersion> contentToBeCreated = new List<ContentVersion>();
        List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
        String returnMessage = '';
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.Send_to_ClaimHub__c = sendDocToClaimHub;
        cv.Description=docType;
        contentToBeCreated.add(cv);
        
        //insert content
        if(!contentToBeCreated.isEmpty()){            
            try {
                insert contentToBeCreated;
                if(isActivityRequired){
                    createTaskTradePortal(parentId,docType,claimId);
                }
            } catch (DmlException e) {
                return 'Failed';
            }
        }
        //get all inserted Ids
        Set<Id> cIds = new Set<Id>();
        for(ContentVersion c:contentToBeCreated){
            if(c.ContentDocumentId == null){
                cIds.add(c.Id);
            }
        }  
        //query the content document ids and form content links to be inserted
        for(ContentVersion cnt : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: cIds]){
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cnt.ContentDocumentId;
            cdl.LinkedEntityId = parentId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            contentLinkToBeCreated.add(cdl);
        }
        //insert content links
        if(!contentLinkToBeCreated.isEmpty()){
            try {
                insert contentLinkToBeCreated;
            } catch (DmlException e) {
                return 'Failed';
            }            
        }     
        system.debug('Exiting HomeRepairUtil');   
        return 'success';        
    }
    public static String doUploadContentFromAttachment(List<Attachment> attachments,Set<String> conIds) {
        List<ContentVersion> contentToBeCreated = new List<ContentVersion>();
        List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
        if (attachments.size() == 0) {
            return 'success';
        }
        Map<string,String> leadToAccountIdMap = new Map<string,String>();
        //check if parent is present
        if(attachments.size() > 0) {
            //for each attachment record, create a content object record to be inserted
            for(Attachment att: attachments){
                if(att.Body != null) {
                    ContentVersion cv = new ContentVersion();
                    cv.ContentLocation = 'S';
                    cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(att.Body));
                    cv.Title = att.Name;
                    cv.Description=att.Description;
                    String fileType='';
                    if(att.ContentType != null){ 
                        fileType=att.ContentType;                   
                        fileType=fileType.SubString(fileType.indexOf('/')+1,fileType.length());
                    }
                    cv.PathOnClient = att.Name+'.'+fileType;  
                    leadToAccountIdMap.put(cv.PathOnClient,att.ParentId);                  
                    contentToBeCreated.add(cv);
                }                   
            }
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
            //query the content document ids and form content links to be inserted
            for(ContentVersion cnt : [SELECT Id, ContentDocumentId,PathOnClient FROM ContentVersion WHERE Id IN: cIds]){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cnt.ContentDocumentId;
                if(leadToAccountIdMap.containsKey(cnt.PathOnClient)){
                    cdl.LinkedEntityId = leadToAccountIdMap.get(cnt.PathOnClient);
                }
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                contentLinkToBeCreated.add(cdl);
            }
            //insert content links
            if(!contentLinkToBeCreated.isEmpty()){
                insert contentLinkToBeCreated;
                List<Attachment> attList = [SELECT Body, Id, ParentId, Name, Description,ContentType FROM Attachment where ParentId IN : conIds];
                if(!attList.isEmpty()){
                    delete attList;
                }
            }
            return 'success';   
        } else {
            system.debug('Exiting HomeRepairUtil'); 
            return 'No Attchment Found';
        }
        
    }
    public static String doUploadContent(String parentId,List<contentWrapper> attachments) {
        
        System.Debug(LoggingLevel.DEBUG, 'Entering HomeRepairUtil with Param parentId : '+parentId);
        List<ContentVersion> contentToBeCreated = new List<ContentVersion>();
        List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
        if (attachments.size() == 0) {
            return 'success';
        }
        //check if parent is present
        if(parentId != null) {
            //for each attachment record, create a content object record to be inserted
            for(contentWrapper attach: attachments){
                if(attach.attachmentBody != null) {
                    ContentVersion cv = new ContentVersion();
                    cv.ContentLocation = 'S';
                    cv.ContentDocumentId = attach.ContentDocumentId;
                    cv.VersionData = EncodingUtil.base64Decode(attach.attachmentBody);
                    cv.Title = attach.attachmentName;
                    cv.PathOnClient = attach.attachmentName;
                    contentToBeCreated.add(cv);
                }                   
            }
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
            //query the content document ids and form content links to be inserted
            for(ContentVersion cnt : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: cIds]){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cnt.ContentDocumentId;
                cdl.LinkedEntityId = parentId;
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                contentLinkToBeCreated.add(cdl);
            }
            //insert content links
            if(!contentLinkToBeCreated.isEmpty()){
                insert contentLinkToBeCreated;
            }
            return 'success';   
        } else {
            system.debug('Exiting HomeRepairUtil'); 
            return 'Parent Id was null';
        }
        
    }
 @AuraEnabled  
    public static Map<String,List<String>> getDependentOptions(string objApiName , string contrfieldApiName , string depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
           
        String objectName = objApiName.toLowerCase();
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
            //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
         
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
         }
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
         objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contrIndex);
        }
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
               Schema.PicklistEntry depentry = depEntries[dependentIndex];
               objEntries.add(depentry);
        } 
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        List<Integer> indexes;
        for (PicklistEntryWrapper objJson : objJsonEntries){
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
            for (Integer idx : indexes){                
                String contrLabel = contrEntries[idx].getLabel();
                objResults.get(contrLabel).add(objJson.label);
            }
        }
        objEntries = null;
        objJsonEntries = null;
        system.debug('objResults--->' + objResults);
        return objResults;
    }
    //wrapper class to store content information
    public class contentWrapper {
        public String attachmentBody {get; set;}
        public String attachmentName {get; set;}
        public String ContentDocumentId {get; set;}
        //constructor method. 
        public contentWrapper(String a, String b, String c) {
            attachmentBody = a;
            attachmentName = b;
            ContentDocumentId = c;
        }
    }
   }