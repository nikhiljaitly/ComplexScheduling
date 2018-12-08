/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTTradeItemsAPI
========================================================================================*/
@isTest
private class TestRESTTradeItemsAPI {
    @testSetup 
    static void setup(){
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        HomeRepairTestDataFactory.createProductForWorkType('Test',wt.Id);
        wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Painter');
    }   
    static testMethod void RESTTradeItemsAPIGetTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/tradeitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTTradeItemsResponseHandler results = RESTTradeItemsAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTTradeItemsAPIBlankGetTest() {
        List<WorkType> workTypeList=[select id from WorkType];
        delete workTypeList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/tradeitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTTradeItemsResponseHandler results = RESTTradeItemsAPI.GET();
        Test.stopTest();
    }
}