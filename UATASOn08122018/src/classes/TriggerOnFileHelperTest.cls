@isTest
public class TriggerOnFileHelperTest {
    
    @testSetup
    private static void prepareData(){
        List<Account> accList=HomeRepairTestDataFactory.createAccounts('Test');
        HomeRepairTestDataFactory.addContentVersionToParent(accList[0].Id);
        
    }
    private static testmethod void testCreate(){
        List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
        Account acc=[select Id from Account limit 1];
        ContentVersion cnt = [SELECT Id, ContentDocumentId,VersionData,Title FROM ContentVersion limit 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cnt.ContentDocumentId;
        cdl.LinkedEntityId = acc.Id;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
        contentLinkToBeCreated.add(cdl);
        String recordStr = JSON.serialize(contentLinkToBeCreated);
        Test.startTest();
        File_Helper__e helper = new File_Helper__e();
        helper.Raw_Request__c = recordStr;
        helper.Action__c = 'create';
        EventBus.publish(helper);
        Test.stopTest();
        
    }
    
    private static testmethod void testDelete() {
        List<ContentVersion> cr = [SELECT Id, ContentDocumentId,VersionData,Title FROM ContentVersion limit 1];
        String fileId = cr.get(0).contentDocumentId;
        ContentDocument[] documentFiles = [SELECT Id FROM ContentDocument WHERE Id =: fileId]; 
        String recordStr = JSON.serialize(documentFiles);
        Test.startTest();
        File_Helper__e helper = new File_Helper__e();
        helper.Raw_Request__c = recordStr;
        helper.Action__c = 'delete';
        EventBus.publish(helper);
        Test.stopTest();
    }

}