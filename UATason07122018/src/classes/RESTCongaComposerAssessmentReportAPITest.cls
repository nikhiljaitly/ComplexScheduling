/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTCongaComposerAPI
========================================================================================*/
@isTest
private class RESTCongaComposerAssessmentReportAPITest{
    @testSetup 
    static void setup(){
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        HomeRepairTestDataFactory.addContentVersionToParent(cs.id);
    }   
    static testMethod void RESTCongaComposerAssessmentReportAPIGetTest() {
        Case cs = [SELECT ID FROM Case LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('claimId', cs.id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/congaassessmentreport';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        RESTCongaAttachmentResponseHandler results = RESTCongaComposerAssessmentReportAPI.GET();
        Test.stopTest();
        
        General_Settings__c genSetting= new General_Settings__c();
        genSetting.Value__c='uat';
    }
    static testMethod void RESTCongaComposerAssessmentReportAPIGetDevTestTest() {
        General_Settings__c genSetting= new General_Settings__c();
        genSetting.Value__c='DevTest';
        insert genSetting;
        Case cs = [SELECT ID FROM Case LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('claimId', cs.id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/congaassessmentreport';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        RESTCongaAttachmentResponseHandler results = RESTCongaComposerAssessmentReportAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTCongaComposerAssessmentReportAPIGetUATTest() {
        General_Settings__c genSetting= new General_Settings__c();
        genSetting.Value__c='uat';
        insert genSetting;
        Case cs = [SELECT ID FROM Case LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('claimId', cs.id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/congaassessmentreport';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        RESTCongaAttachmentResponseHandler results = RESTCongaComposerAssessmentReportAPI.GET();
        Test.stopTest();
    }
    
}