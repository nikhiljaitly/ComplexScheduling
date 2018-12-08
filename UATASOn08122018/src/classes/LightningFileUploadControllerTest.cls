/* =====================================================================================
Type:       Test class
Purpose:    Test cases for LightningFileUploadController (For LightningFileUpload Component )
========================================================================================*/
@isTest
private class LightningFileUploadControllerTest{
    static testMethod void fetchContentDocumentAnduploadFileTest() {
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);  
        HomeRepairTestDataFactory.addContentVersionToParent(cs.Id);
        ContentVersion cnt = [SELECT Id, ContentDocumentId FROM ContentVersion limit 1]; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        String base64Data= EncodingUtil.base64encode(bodyBlob);
        LightningFileUploadController.uploadFile('Test',base64Data,'PNG',cs.id,'Report',false,false,cs.id,cnt.ContentDocumentId);
        LightningFileUploadController.fetchCustomMetaDataValues('Assessment Report');
        
    }
}