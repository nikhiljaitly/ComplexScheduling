/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTCongaComposerAPI
========================================================================================*/
@isTest
private class TestRESTCongaComposerAssessmentReportAPI{
    @testSetup 
    static void setup(){
        Case cs=HomeRepairTestDataFactory.createCase();
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
    }
}