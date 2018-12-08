/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTRepairItemProductLevelAPI
========================================================================================*/
@isTest
private class TestRESTRepairItemProductLevelAPI {
    @testSetup 
    static void setup(){
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        HomeRepairTestDataFactory.createProductForWorkType('Test',wt.Id);
    }   
    static testMethod void RESTRepairItemProductLevelAPIGetTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/repairitemproductslevels';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairProductLevelResponseHandler results = RESTRepairItemProductLevelAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTRepairItemProductLevelAPIBlankGetTest() {
        List<WorkType> workTypeList=[select id from WorkType];
        delete workTypeList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/tradeitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairProductLevelResponseHandler results = RESTRepairItemProductLevelAPI.GET();
        Test.stopTest();
    }
}