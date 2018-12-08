/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTRepairItemProductLevelAPI
========================================================================================*/
@isTest
private class RESTRepairItemProductLevelAPITest {  
    static testMethod void RESTRepairItemProductLevelAPIGetTest() {
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        HomeRepairTestDataFactory.createProductsWithPricebookEntryAndWorkCodes('Test',wt.Id,700,'NSW');
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/repairitemproductslevels'; 
        req.params.put('state', 'NSW'); 
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairProductLevelResponseHandler results = RESTRepairItemProductLevelAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTRepairItemProductLevelAPIBlankGetTest() {
        List<WorkType> workTypeList=[select id from WorkType];
        if(workTypeList.size() > 0){
            delete workTypeList;
        }       
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