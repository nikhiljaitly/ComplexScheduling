/* =====================================================================================
Type:       Test class
Purpose:    Test cases for ContentFileListController (For LightningFileUpload Component )
========================================================================================*/
@isTest
private class ContentFileListControllerTest{
    static testMethod void fetchContentDocumentAnduploadFileTest() {
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        Test.StartTest();
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);  
        Test.StopTest();
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id);
        ContentFileListController.fetchClaimContentDocument(wo.id);
        system.debug('wo'+wo);
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        String base64Data= EncodingUtil.base64encode(bodyBlob);
        HomeRepairTestDataFactory.addContentVersionToParent(cs.id);
        ContentFileListController.fetchContentDocument(cs.id);        
        ContentFileListController.fetchParentId(wo.id,'CaseId');
        ContentFileListController.fetchWorkOrderContentDocument(wo.id);
    }
}