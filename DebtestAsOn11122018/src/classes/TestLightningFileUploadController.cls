/* =====================================================================================
Type:       Test class
Purpose:    Test cases for LightningFileUploadController (For LightningFileUpload Component )
========================================================================================*/
@isTest
private class TestLightningFileUploadController{
    static testMethod void fetchContentDocumentAnduploadFileTest() {
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        // Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        String base64Data= EncodingUtil.base64encode(bodyBlob);
        //String fileName, String base64Data, String contentType,String parentId,String docType,Boolean sendDocToClaimHub
        LightningFileUploadController.uploadFile('Test',base64Data,'Text',String.valueOf(cs.id),'Report',false,false,'');
        LightningFileUploadController.fetchContentDocument(cs.id);
        LightningFileUploadController.fetchCustomMetaDataValues('WorkOrder');
        
    }
}