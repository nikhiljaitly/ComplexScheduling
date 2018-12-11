/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RESTReportItemsAPI
========================================================================================*/
@isTest
private class TestRESTReportItemsAPI{
    @testSetup 
    static void setup(){
        Case cs=HomeRepairTestDataFactory.createCase();
        HomeRepairTestDataFactory.addContentVersionToParent(cs.id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair Trades',cs.id,wt.Id);
        HomeRepairTestDataFactory.createServiceAppointment(woliList[0].workOrderId);
        system.debug([SELECT id,WorkType.Name FROM WorkOrderLineItem where id IN:woliList]);
        Room__c rm=HomeRepairTestDataFactory.createRoom(cs.id,woliList);
        HomeRepairTestDataFactory.addContentVersionToParent(rm.id);
    }   
    static testMethod void RESTReportItemsAPIGetTest() {
        ServiceAppointment app = [SELECT ID FROM ServiceAppointment LIMIT 1];
        RestRequest req = new RestRequest(); 
        req.params.put('apptId', app.id);
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTReportItemResponseHandler results = RESTReportItemsAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTReportItemsAPIPutBodyTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'PUT';
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTReportItemResponseHandler results = RESTReportItemsAPI.GET();
        Test.stopTest();
    }
    static testMethod void RESTReportItemsAPIPutParamTest() {
        Room__c rm=[SELECT id FROM Room__c LIMIT 1];
        Case cs = [SELECT id FROM Case LIMIT 1];
        String jsonRoom= '{"WorkOrderId":"0WO5D000000AG6LWAW","selectOptions":{"Maintenance_Required__c":["Yes","No"],"Insurable__c":["Yes","No"],"Temporary_Accommodation_Reason__c":["Repair complexity","Home unliveable"],"Temporary_Accommodation_Required__c":["Yes","No"],"Safety_Repair_Working_Heights__c":["Safety Harness","Safety Barrier","Scaffolding","Risk of a fall greater than 2 meters","Other"],"Repair_OH_S__c":["Yes","No"],"Job_Readiness__c":["Yes","No"],"Report_Type__c":["Roof","Leak","Mould","Other"],"Roof_Type__c":["Cement","Metal","Slate","Terra Cotta","Other"],"Potential_Risks_To_Trades__c":["Road","Pools/Water","Animal","Electrical","Gas","Mould","Sewerage","Walkways","Lead paint","Other"],"Decline_Type__c":["General","Specific"],"Claim_Proceeding__c":["Awaiting Report","Maintenance to be Completed","Decline","Non fit","Cancelled"],"Cause_Detail__c":["Accidental Loss or Damage","Damage by animals","Electrical Motor Burnout","Fire","Glass Breakage (Property)","Impact (Non Storm)","Malicious damage","Theft"],"Cash_Settlement_Reason__c":["Shared Fence","Partial","Repair issue","Full cash details"],"Contents_Damaged__c":["Carpet","Other"],"Cash_Settlement__c":["Yes","No"],"Cause__c":["Natural Hazard","Working Loss"],"Building_Height__c":["Single","Double","Triple","Split","High Set","Other"],"Asbestos__c":["Home built before 1990","Removal and disposal","Asbestos not removing"],"Appoint_Repair_Link_Assessor__c":["Yes","No"],"Decline_Specific_Reasons__c":["Theft","Accidental loss or damage","Damage by an animal","Earthquake and Tsunami","Electric Motor Burnout","Escape of Liquid","Explosion","Fire","Flood","Impact damage","Lightning","Malicious acts and vandalism","Riot, civil commotion or public disturbance","Storm"]},"Phone":"0384849595","Mobile":"0413329396","Excess":1700.00,"ContactName":"Kz Contact","ContactId":"0035D000006tFwKQAU","claimDetails":{"attributes":{"type":"Case","url":"/services/data/v42.0/sobjects/Case/5005D000002HyeMQAS"},"Id":"5005D000002HyeMQAS","Description":"Roof blew off and damaged plaster in loungeroom1234567","Status":"Assessor Assigned","Building_Height__c":"High Set","Roof_Type__c":"Cement","Insurable__c":"Yes","Cause__c":"Working Loss","Cause_Detail__c":"Glass Breakage (Property)","Contents_Damaged__c":"Other","Contents_Damaged_Comments__c":"Contents were damaged in the rain","Appoint_Repair_Link_Assessor__c":"Yes","Maintenance_Required__c":"Yes","Maintenance_Details__c":"Please maintain","Cash_Settlement__c":"Yes","Cash_Settlement_Reason__c":"Partial","Cash_Settlement_Comments__c":"Cash for fence","Temporary_Accommodation_Required__c":"Yes","Temporary_Accommodation_Reason__c":"Home unliveable","Repair_OH_S__c":"Yes","Asbestos__c":"Removal and disposal","Safety_Repair_Working_Heights__c":"Safety Harness","Potential_Risks_To_Trades__c":"Animal","Job_Readiness__c":"No","Claim_Proceeding__c":"Awaiting Report","Report_Type__c":"Roof","Awaiting_Report_Comments__c":"Yes we are awaiting report comments","Decline_Type__c":"Specific","Decline_Specific_Reasons__c":"Earthquake and Tsunami","Non_Fit_Reason__c":"The assesson cant even access roof","Cancelled_Reason__c":"Cancelled eating","Report_Item_Comments__c":"Reports are fine","Other_Building_Height__c":null,"Other_Roof_Type__c":null,"Appoint_Restorer__c":null},"BrandName":"Vero","BrandImage":"https://homerepair--devtest--c.cs72.content.force.com/servlet/servlet.ImageServer?id=0155D0000000pqj&oid=00D5D0000004boP","attachments":[{"parentId":"'+cs.id+'","name":"Bris","isDeleted":false,"fileType":"jpg","fileData":"iVBORw0KGgoAAAANSUhEUgAABEEAAABFCAYAAAClv/jRAAAD9klEQVR4nO3dW27rIBAA0KzF+99j7pevKofHDJDEds6RovoBzOD2hxFOHw8AAAAAAAAAAAAAAAC4lm3bnsfz47VP+xs/ksu3811lZh61ZxYdc6QPAAAAXMoZF7/ZPM6S96xV85gtggAAAMAt7YvffQdIaWdI7XykTyl+L0amfSteL9/eLphau1q/Wrze+K1rrdxLbaLPPvLMM3NsPdPe856NV5svAAAAP663YI4uNnuL6EzsVceReezH0TGi/TKFoFabdxVBVsxj9Jl+Ih4AAAC8yCyYVyxWs9dH8+vFWpHvijEzcWs/o8cjuWcKC6uKGa08o/0AAADgxV2KIL2dAN8oghw/tdyicb9RBDnOpTRO6f7sjo5azGg8AAAAeHGXIkg21qd3gkSctQgSbfeOeytyBgAAgMfjsWYB2htnptgxc/zOfFeNGW0zGnv2eWTa9c6j90bjleYJAAAA/40WQfZr2dckau2iOfXat+bResUi2j97HonXu56NnfmdlnKMzuPvvVrc1vwjfzvZeL05AwAAQJeF5Tq/8CyzBTUAAAA4BYvWtX7heSqCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC3sm3bc/+U7pWOW2Otzu+MfmWeAAAAcBvHxXzvPDveXf3KPAEAAOAWagv52u6PUoFkpIiyXzv2b+1Gqd3rtcvkl+mvCAIAAAAXkn29Zeb4OGar+JEpYvTaRYsgs9cBAACAE1tVBCm1b42d3Z2Rzbk2Ru1ntn8mDwAAAOAE3lUE6b26MvqKSmTc1istvSJItH9r/gAAAMAJzXwnSLZvK25mJ0hNZIxWESTTP5MXAAAAcBKjBYlVhZJMzOiYpR0jI7tPInEBAACAC2m9atIrSGSLDZE2rddUIvMYibGiPwAAAMDlKXoAAAAAt6cAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADww7Zte+6f0r3ScWus1flFrIj7rdwBAACADzgu/Hvn2fE+RREEAAAAqKot+mu7P0oFkpEiyn7t2L+1G6V2r3a/t7slkjsAAABwE9nXW2aOj2O2ih+9wksmz5l7AAAAwE2sKoKU2rfGzuweUQQBAAAApr2rCNJ6daXUt1eYOH4yec7cAwAAAG5i5jtBRooRtesrChOKIAAAAEDTaEFiVaEkEzM65orxAAAAgBvq/SeV0vHffrX2pfNIm1qc3is2/jsMAAAAAAAAAAAAAAAAAAAAABf2DzWGEfTIeVgMAAAAAElFTkSuQmCC","description":null,"contentDocumentId":"0695D000000A9K2QAK","attachmentId":null}],"Address":"1 7 QUEENS BRIDGE ST   SOUTHBANK VIC 3006"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();          
        req.requestURI = '/homerepair/api/v1/roomrepairitems';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jsonRoom);
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
            RESTReportItemResponseHandler results = RESTReportItemsAPI.PUT();
        Test.stopTest();        

    }
}