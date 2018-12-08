/* =====================================================================================
Type:       Test class
Purpose:    Test cases for FileUploadController
========================================================================================*/
@isTest
private class FileUploadControllerTest{
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
    static testMethod void FileUploadControllerAllTest() {
       Case cs=[SELECT id FROM Case LIMIT 1];
       Blob fileDescription = Blob.valueOf('Test Data');
       String base64Data = EncodingUtil.base64Encode(fileDescription);     
       Id ContentDocumentId=FileUploadController.saveChunk(cs.id,'Test',base64Data,'Quote','','Quote');
       FileUploadController.saveChunk(cs.id,'Test',base64Data,'Quote',ContentDocumentId,'Quote');
    }
}