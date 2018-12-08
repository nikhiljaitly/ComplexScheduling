/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTRoomRepairItemsAPI
========================================================================================*/
@isTest
private class RESTRoomRepairItemsAPITest{
    @testSetup 
    static void setup(){
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Painter');
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id);       
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair',cs.id,wt.Id,wo.Id,1);
        woliList.addAll(HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair',cs.id,wt.Id,wo.Id,1));
        Room__c rm=HomeRepairTestDataFactory.createRoom(cs.id,woliList);
        HomeRepairTestDataFactory.addContentVersionToParent(rm.id);
    }   
    static testMethod void RESTRoomRepairItemsAPIGetParamTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairItemsResponseHandler results = RESTRoomRepairItemsAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTRoomRepairItemsAPIPutParamTest() {
        Case cs = [SELECT id FROM Case LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('claimId', cs.Id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairItemsResponseHandler results = RESTRoomRepairItemsAPI.GET();            
        Test.stopTest();
        system.debug(JSON.serializePretty(results.Data));
        
        req = new RestRequest();
        req.params.put('claimId', cs.Id); 
        res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serializePretty(results.Data));
        RestContext.request = req;
        RestContext.response = res;        
        RESTRepairItemsResponseHandler resultsPut = RESTRoomRepairItemsAPI.PUT();
         
    }
    static testMethod void RESTRoomRepairItemsAPIPutDeleteTest() {
        Case cs = [SELECT id FROM Case LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('claimId', cs.Id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairItemsResponseHandler results = RESTRoomRepairItemsAPI.GET();            
        Test.stopTest();
        system.debug(JSON.serializePretty(results.Data));
        String reqJson = JSON.serializePretty(results.Data).replaceAll('"isDeleted" : false,', '"isDeleted" : true,');
        req = new RestRequest();
        req.params.put('claimId', cs.Id); 
        res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(reqJson);
        RestContext.request = req;
        RestContext.response = res;        
        RESTRepairItemsResponseHandler resultsPut = RESTRoomRepairItemsAPI.PUT();
         
    }
    
}