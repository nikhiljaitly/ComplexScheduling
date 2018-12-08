/* =====================================================================================
Type:       Test class
Purpose:    Test cases for ContentVersionFileUploadController
========================================================================================*/
@isTest
private class ContentVersionFileUploadControllerTest{
    @testSetup 
    static void setup(){
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);                
        
    }   
    static testMethod void ContentVersionFileUploadControllerAllTest() {
       Case cs=[SELECT id FROM Case LIMIT 1];
       Blob fileDescription = Blob.valueOf('Test Data');
       String base64Data = EncodingUtil.base64Encode(fileDescription);     
       Id ContentDocumentId= ContentVersionFileUploadController.saveTheFile(null,cs.id,'Test',base64Data,'Quote');
       ContentVersionFileUploadController.saveChunk(string.valueOf(ContentDocumentId),cs.id,'Test',base64Data,string.valueOf(ContentDocumentId),'Quote');
       string fileId=ContentVersionFileUploadController.saveChunk(null,cs.id,'Test',base64Data,string.valueOf(ContentDocumentId),'Quote');
       ContentVersionFileUploadController.updateFile('PNG',fileId);
       ContentVersionFileUploadController.deleteContentFile(fileId);
       ContentVersionFileUploadController.createEventBus(fileId,'create');
    }
    
}