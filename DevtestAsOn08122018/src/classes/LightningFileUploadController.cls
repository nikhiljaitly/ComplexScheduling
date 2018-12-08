public class LightningFileUploadController {
    @AuraEnabled
    public static List<ContentDocumentLink> uploadFile(String fileName, String base64Data, String contentType,String parentId,String docType,Boolean sendDocToClaimHub,Boolean isActivityRequired,string claimId,string documentId) { 
        HomeRepairUtil.updateContentFile(docType,sendDocToClaimHub,parentId,isActivityRequired,documentId,claimId);    
        List<ContentDocumentLink> ContentDocumentLinkList;
        if(isActivityRequired){
            ContentDocumentLinkList=new List<ContentDocumentLink>();
        }else{
            ContentDocumentLinkList=fetchContentDocument(parentId);
        }         
        return ContentDocumentLinkList;
    }
    @AuraEnabled
    public static List<string> fetchCustomMetaDataValues(String platform) {
        List<String> platformList=new List<String>();
        List<Document_Type__mdt> DocumentTypeList = Database.query('SELECT MasterLabel FROM Document_Type__mdt WHERE Platform__c = \''+ platform + '\'');
        for(Document_Type__mdt dt : DocumentTypeList){
            platformList.add(dt.MasterLabel);
        }
        return platformList;
    }
    @AuraEnabled
    public static List<ContentDocumentLink> fetchContentDocument(String caseId) {
        List<ContentDocumentLink> ContentDocumentLinkList=new List<ContentDocumentLink>();
        if(caseId != null && caseId != ''){
            ContentDocumentLinkList=[SELECT id,ContentDocumentId,ContentDocument.LatestPublishedVersion.Title,ContentDocument.LatestPublishedVersion.LastModifiedBy.Name,ContentDocument.Description FROM ContentDocumentLink where LinkedEntityId =: caseId order by ContentDocument.LatestPublishedVersion.CreatedDate DESC limit 5];
        }
        return ContentDocumentLinkList;
    }
}