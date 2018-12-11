/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTRoomRepairItemsAPI
========================================================================================*/
@isTest
private class TestRESTRoomRepairItemsAPI{
    @testSetup 
    static void setup(){
        Case cs=HomeRepairTestDataFactory.createCase();
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair Trades',cs.id,wt.Id);
        system.debug([SELECT id,WorkType.Name FROM WorkOrderLineItem where id IN:woliList]);
        Room__c rm=HomeRepairTestDataFactory.createRoom(cs.id,woliList);
        HomeRepairTestDataFactory.addContentVersionToParent(rm.id);
    }   
    static testMethod void RESTRoomRepairItemsAPIGetTest() {
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
        Room__c rm=[SELECT id FROM Room__c LIMIT 1];
        Case cs = [SELECT id FROM Case LIMIT 1];
        String jsonRoom='{"totalPrice":null,"rooms":[{"workOrders":[{"workTypeName": "Painter","workTypeId": "08q5D00000001QAQAY","workOrderLineItems": [{"workTypeName": "Painter","workTypeId": "08q5D00000001QAQAY","workOrderLineItemId": null,"unitPrice": 0,"totalPrice": 0,"roomName": "Bathroom","roomId": null,"quantity": 100,"productName": "Skirting/Architraves - KD Hardwood - 90 x 19mm (Nom size) - Remove, supply & install - Select grade","productId": "01u5D000002s74sQAA","isDeleted": false,"description": null,"contentsType": null,"cashSettled": false}],"workOrderId": null,"totalPrice": 0,"sortOrder": null}],"width":4.00,"wall":32.00,"roomId":null,"perimeter":16.00,"name":"Bathroom","length":4.00,"isDeleted":false,"height":2.00,"floor":16.00,"claimId":"5005D000001kF7oQAE","attachments":[]},{"workOrders":[],"width":4.00,"wall":32.00,"roomId":"'+rm.id+'","perimeter":16.00,"name":"Bathroom","length":4.00,"isDeleted":true,"height":2.00,"floor":16.00,"claimId":"5005D000001kF7oQAE","attachments":[]}],"otherRoofType":null,"otherBuildingHeight":null,"estimatedCostofCashSettlement":null,"claimName":"400001","claimId":"'+cs.id+'","claimDescription":null,"assessmentReportCreated":false,"appointRestorer":null}';
        RestRequest req = new RestRequest();
        req.params.put('claimId', cs.Id); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jsonRoom);
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTRepairItemsResponseHandler results = RESTRoomRepairItemsAPI.PUT();
        Test.stopTest();        

    }
}