/***************************************************************** 
Purpose: Test class for ContentVersionFileUploadController 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          20/02/2018      Created      Home Repair Claim System  
*******************************************************************/
@istest 
public class ContentVersionFileUploadControllerTest {    
    static testmethod void test_ContentVersionFileUploadController() {
        List<Account> accList=HomeRepairTestDataFactory.createAccounts('Test');
        HomeRepairTestDataFactory.addContentVersionToParent(accList[0].Id);
        ContentVersion cnt = [SELECT Id, ContentDocumentId,VersionData,Title FROM ContentVersion limit 1];
        ContentVersionFileUploadController.saveChunk(cnt.ContentDocumentId,accList[0].Id,cnt.Title,EncodingUtil.base64Encode(cnt.VersionData),'',cnt.Title);     
        ContentVersionFileUploadController.saveChunk(cnt.ContentDocumentId,accList[0].Id,cnt.Title,EncodingUtil.base64Encode(cnt.VersionData),cnt.ContentDocumentId,cnt.Title);   
        ContentVersionFileUploadController.saveChunk(null,accList[0].Id,cnt.Title,EncodingUtil.base64Encode(cnt.VersionData),'',cnt.Title); 
        ContentVersionFileUploadController.saveChunk(null,accList[0].Id,cnt.Title,EncodingUtil.base64Encode(cnt.VersionData),cnt.ContentDocumentId,cnt.Title); 
        ContentVersionFileUploadController.deleteContentFile(cnt.ContentDocumentId);      
    }
}