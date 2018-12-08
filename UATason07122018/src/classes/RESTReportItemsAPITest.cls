/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTReportItemsAPI
========================================================================================*/
@isTest
private class RESTReportItemsAPITest{
    @testSetup 
    static void setup(){
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);                
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id);
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair',cs.id,wt.Id,wo.Id,1);
        serviceResource sr = HomeRepairTestDataFactory.createNewServiceResource(userInfo.getUserId());
        ServiceAppointment sa = HomeRepairTestDataFactory.createNewServiceAppointment(woliList[0].workOrderId,'New', cs.Id,sr.Id);
        Room__c rm=HomeRepairTestDataFactory.createRoom(cs.id,woliList);
        Home_Repairs_Trigger_Switch__c hrts = HomeRepairTestDataFactory.createHomeRepairsTriggerSwitch();
        cs.Asbestos_Present__c = 'Yes';
        Update cs;
        HomeRepairTestDataFactory.addContentVersionToParent(cs.id);
    }   
    static testMethod void RESTReportItemsAPIGetAndPutTest() {
        ServiceAppointment app = [SELECT ID FROM ServiceAppointment LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('apptId', app.id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/reportitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        RESTReportItemResponseHandler results = RESTReportItemsAPI.GET();
        Test.stopTest();
        req = new RestRequest();
        res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/reportitems';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serializePretty(results.Data));
        RestContext.request = req;
        RestContext.response = res;        
        RESTReportItemResponseHandler resultsPut = RESTReportItemsAPI.PUT();
    }
    static testMethod void RESTReportItemsAPIPutBodyTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/reportitems';  
        req.httpMethod = 'PUT';
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        RESTReportItemResponseHandler results = RESTReportItemsAPI.GET();
        Test.stopTest();
    }
}