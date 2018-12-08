/***************************************************************** 
Purpose: Retreives Email Tempalte and Sent Custom Email with CC                                                         
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          02/08/2018      Created      Home Repair Claim System  
*******************************************************************/   
public class LightningFileUploadModelController {  
    /***************************************************************** 
    Purpose: getFiles method to fetch Content Version File 
    Parameters: recordId (CaseId or All_Service_AppointmentId)
    Returns: ContentVersion
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/ 
    @AuraEnabled 
    public static List<ContentVersion> getFiles(string recordId,string documentId,string docType){
        system.debug('Entering  getFiles: ' + 'claim Id: ' + recordId+'documentId : '+documentId+' docType: '+docType);
        if(documentId != ''){
           List<ContentVersion> contentVersionList = [SELECT Id,contentDocumentId from ContentVersion where contentDocumentId =: documentId];
            for(ContentVersion cv : contentVersionList){
                cv.Description=docType;
            }
            update contentVersionList;
        }
        EmailTemplate emailTemp = new EmailTemplate();
        Set<String> objectIds=new Set<String>();
        objectIds.add(recordId);
        List<ContentDocumentLink> contents = [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersion.Title, 
               ContentDocument.LatestPublishedVersion.LastModifiedBy.Name, 
               ContentDocument.Description FROM ContentDocumentLink 
               where LinkedEntityId =: recordId];
        List<String> contentDocumentIds = new List<String>();
        for(ContentDocumentLink link: contents) {
            contentDocumentIds.add(link.ContentDocumentId);
        }
        List<ContentVersion> versions 
            = [SELECT Id, Title, FileType, VersionData, 
               isLatest, ContentDocumentId
               FROM ContentVersion
               WHERE isLatest = true AND ContentDocumentId IN :contentDocumentIds];
        system.debug('Exiting  getFiles: ' + 'ContentVersion : ' + versions);
        return versions;
    }
}