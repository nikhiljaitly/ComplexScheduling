/* =====================================================================================
Type:       Test class
Purpose:    Test cases for EOI_Controller (For LeadInitialForm Component )
========================================================================================*/
@isTest(SeeAllData=true)
private class EOI_ControllerTest{
    static testMethod void EOI_ControllerAllTest() {
        Lead ld=new Lead();
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Painter');
        
        EOI_Controller.getAbnCalloutResponseContents('33007457141');
        EOI_Controller.getLeadInitialForm();
        
        EOI_Controller.getselectOptions(ld,'Industry');
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        String base64Data= EncodingUtil.base64encode(bodyBlob);
        
        //Check for Lead Exists condition for createLeadAndTradeCompliances
        //ld = HomeRepairTestDataFactory.createLead('Test','Test')[0];
        
        Lead ldTest = new Lead();
        ldTest.company='Test';
        ldTest.LastName='Test';
        ldTest.ABN__c='33007457141';
        ldTest.Email='test123@test.com';        
        String leadDetail=JSON.serializePretty(ldTest);        
        system.debug(leadDetail);
        Trade_Type__c tt=new Trade_Type__c();
        tt.Trade_Type__c='Painter';
        List<Trade_Type__c> ttList=new List<Trade_Type__c>();
        ttList.add(tt);
        String tradeCompliances=JSON.serializePretty(ttList);
        EOI_Controller.createLeadAndTradeTypes(leadDetail,tradeCompliances);
        List<Lead> ldlst = HomeRepairTestDataFactory.createLead('Test','LastTest','FirstTest');
        Id fileId=EOI_Controller.saveTheFile(ldlst[0].Id,'Test',base64Data,'PNG','Quote');
        EOI_Controller.saveChunk(ldlst[0].Id,'Test',base64Data,'PNG',fileId,'Quote');
        EOI_Controller.getCacheTable();
        EOI_Controller.createLeadAndTradeCompliances(leadDetail,tradeCompliances);
        
        
        
        //Check for Lead NotExists condition for createLeadAndTradeCompliances
        List<Lead> ldlst1 = HomeRepairTestDataFactory.createLead('Test456','LastTest456','FirstTest456');
        Id fileId1=EOI_Controller.saveTheFile(ldlst1[0].Id,'Test',base64Data,'PNG','Quote');
        EOI_Controller.saveChunk(ldlst1[0].Id,'Test',base64Data,'PNG',fileId1,'Quote');
        Lead ldTest1 = new Lead();
        ldTest1.company='Test456';
        ldTest1.LastName='Test456';
        ldTest1.ABN__c='456';
        ldTest1.Email='test456@test.com';        
        String leadDetail1=JSON.serializePretty(ldTest1);        
        system.debug(leadDetail1);
        Trade_Type__c tt1=new Trade_Type__c();
        tt1.Trade_Type__c='Painter';
        List<Trade_Type__c> ttList1=new List<Trade_Type__c>();
        ttList1.add(tt1);
        String tradeCompliances1=JSON.serializePretty(ttList1);
        EOI_Controller.getCacheTable();
        EOI_Controller.createLeadAndTradeCompliances(leadDetail1,tradeCompliances1);
        
        
        //Check for Lead Exists condition for createLeadAndTradeTypes
        List<Lead> ldlst2 = HomeRepairTestDataFactory.createLead('Test234','LastTest234','FirstTest234');
        Id fileId2=EOI_Controller.saveTheFile(ldlst2[0].Id,'Test',base64Data,'PNG','Quote');
        EOI_Controller.saveChunk(ldlst2[0].Id,'Test',base64Data,'PNG',fileId2,'Quote');
        Lead ldTest2 = new Lead();
        ldTest2.company='Test234';
        ldTest2.LastName='Test234';
        ldTest2.ABN__c='234';
        ldTest2.Email='test234@test234.com';        
        String leadDetail2=JSON.serializePretty(ldTest2);        
        system.debug(leadDetail2);
        Trade_Type__c tt2=new Trade_Type__c();
        tt.Trade_Type__c='Painter';
        List<Trade_Type__c> ttList2=new List<Trade_Type__c>();
        ttList2.add(tt2);
        String tradeCompliances2=JSON.serializePretty(ttList2);
        EOI_Controller.getCacheTable();       
        EOI_Controller.createLeadAndTradeTypes(leadDetail2,tradeCompliances2);
        
        
         //Check for Lead NotExists condition for createLeadAndTradeTypes
        List<Lead> ldlst11 = HomeRepairTestDataFactory.createLead('Test779','LastTest779','FirstTest779');
        Id fileId11=EOI_Controller.saveTheFile(ldlst11[0].Id,'Test',base64Data,'PNG','Quote');
        EOI_Controller.saveChunk(ldlst11[0].Id,'Test',base64Data,'PNG',fileId11,'Quote');
        Lead ldTest11 = new Lead();
        ldTest11.company='Test779';
        ldTest11.LastName='Test779';
        ldTest11.ABN__c='779';
        ldTest11.Email='test779@test779.com';        
        String leadDetail11=JSON.serializePretty(ldTest11);        
        system.debug(leadDetail11);
        Trade_Type__c tt11=new Trade_Type__c();
        tt11.Trade_Type__c='Painter';
        List<Trade_Type__c> ttList11=new List<Trade_Type__c>();
        ttList11.add(tt11);
        String tradeCompliances11=JSON.serializePretty(ttList11);
        EOI_Controller.getCacheTable();        
        EOI_Controller.createLeadAndTradeTypes(leadDetail11,tradeCompliances11);
     
    }
}