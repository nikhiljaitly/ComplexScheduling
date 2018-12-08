@isTest
public class GenerateCreditMemoWoTest {
    @isTest static void testCreditMemoWOGeneration(){
        //Create Account
        List<Account> testAccountNew = homeRepairTestDataFactory.createAccounts('TestAccount45');
        string AccId = testAccountNew[0].Id;
        
        //Create Contact
        Contact testContactNew = homeRepairTestDataFactory.createContact('TestContact45');
        string conId = testContactNew.Id;
        
        //create policy
        policy__c testPolicy = homeRepairTestDataFactory.createPolicy();
        string policyId = testPolicy.Id;
        //System.debug('policy: ' + testPolicy);
        
        //create case associated to policy       
        Case testCasenew = homeRepairTestDataFactory.createCaseWithOriginAndPolicy(policyId, conId);          
        String testCaseID = testCasenew.id;
        
        //Create claim job & associate to claim
        Claim_Job__c testClaimJob = new Claim_Job__c();
        testClaimJob.Claim__c = testCaseID;
        testClaimJob.Job_Type__c = 'doAndCharge';
        insert testClaimJob;
        
             
        //create service resource Account relatable to work order
        Account testSerResAcc = homeRepairTestDataFactory.createTradeAccount();          
        String testSerResAccID = testSerResAcc.Id;          
        
        
        //Create WorkType
        WorkType testWorkType = homeRepairTestDataFactory.createWorkType('Repair Items','Cabinetmaker');          
        String testWkTypeId = testWorkType.Id;          
        
        //Generate CreditMemo workOrder
        workOrder testCrMemoWo = new workOrder();
        testCrMemoWo.Claim_Job__c = testClaimJob.id;
        testCrMemoWo.Subject = 'repair';
        testCrMemoWo.WorkTypeid = testWkTypeId;
        testCrMemoWo.caseid = testCaseID;
        testCrMemoWo.Customer_Invoice_Ref__c = 'INVREF1234';
        //testWo.RCTI__c = true;
        testCrMemoWo.Call_Invoice_Gen_Srvc_for_Non_RCTI__c = true;
        //testWo.Service_Resource__c = testResource.id;
        testCrMemoWo.Service_Resource_Company__c = testSerResAccID;
        testCrMemoWo.Invoice_Type__c = 'Credit Memo';
        insert testCrMemoWo;
        
        //generate gst chargeable products for woli's
        Product2 testProduct = new Product2();
        testProduct.Name = 'testProduct';
        testProduct.GST_Exempt_Labour__c = false;
        testProduct.GST_Exempt_Material__c = false;
        insert testProduct;
        
 
        //generate woli's associated to workOrder and product
        workOrderLineItem testWOLI = new workOrderLineItem();
        //testWOLI.PricebookEntryId = testProduct.id;
        testWOLI.WorkOrderId = testCrMemoWo.Id;
        testWOLI.WorkTypeId = testWkTypeId;
        testWOLI.Description = 'abc';
        testWOLI.Site_Visit_Number__c = 1;
        testWOLI.Labour_Cost__c = 100.00;
        testWOLI.Labour_Time__c = 1.00;
        testWOLI.Material_Cost__c = 100.00;
        //testWOLI.Quantity = 1;
        testWOLI.Status = 'closed';
        insert testWOLI;

        
        //calculate for a GST value above zero        
        //get work order 
        workOrder x = [SELECT id, LineItemCount, Do_Not_Invoice_AP__c, Work_Type_Name__c,
                       Internal_Resource__c, Invoice_Type__c, Status, SupplierInvCheck__c, 
                       RCTI__c, Call_Invoice_Gen_Srvc_for_Non_RCTI__c
                       FROM workOrder
                       WHERE id = :testCrMemoWo.id];
        
        
        test.startTest();
        AP_Invoice__c testAPInv = homeRepairTestDataFactory.createAP_Invoice(x);
        test.stopTest();
        
        
        AP_Invoice__c Inv = [SELECT id, Labour_Distribution_Set__c, Material_Distribution_Set__c, GST_Distribution_Set__c
                             FROM AP_Invoice__c
                             WHERE id = :testAPInv.id];
        
        String expectedLabourResult = ('11.303.51300.220.000');
    }
}