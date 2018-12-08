@isTest
public class testGenerateCMFeesWo {
    @isTest static void testCMFeesWOGeneration(){
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
        
        
        //create user to be service resource
            /*User testUser = new User();
            testUser.Username = 'testUser@fakemail.com';
            testUser.LastName = 'User';
            testUser.Alias = 'tUser';
            testUser.Email = 'tUser@fakemail.com';
            testUser.CommunityNickname = 'tUser';
            testUser.ProfileId = '2F00e5D000000Drjd';        
            insert testUser;*/
        
        
        //create service resource Account relatable to work order
        Account testSerResAcc = homeRepairTestDataFactory.createServiceResource();          
        String testSerResAccID = testSerResAcc.Id;	        
        
        
        //Create WorkType
        WorkType testWorkType = homeRepairTestDataFactory.createWorkType('Other Items','Assessment');          
        String testWkTypeId = testWorkType.Id;	        
        
        //Generate CMFee workOrder
        workOrder testCMFeesWo = new workOrder();
        testCMFeesWo.Claim_Job__c = testClaimJob.id;
        testCMFeesWo.Subject = 'Assessment';
        testCMFeesWo.WorkTypeid = '08q5D00000001Pl';
        testCMFeesWo.caseid = testCaseID;
        testCMFeesWo.Customer_Invoice_Ref__c = 'INVREF1234';
        testCMFeesWo.RecordTypeId = '0125D000000CjECQA0';
        testCMFeesWo.Status = 'Assessment Scheduled';
        //testWo.RCTI__c = true;
        testCMFeesWo.Call_Invoice_Gen_Srvc_for_Non_RCTI__c = true;
        //testWo.Service_Resource__c = testResource.id;
      //  testCMFeesWo.Service_Resource_Company__c = testSerResAccID;
        //testCMFeesWo.Invoice_Type__c = 'CM Fees';
        insert testCMFeesWo;
        
        system.debug('testCMFeesWoKAN' + testCMFeesWo);
        
      
        //get work order 
        workOrder x = [SELECT id, Work_Type_Name__c, Recordtype.developername,
                       Internal_Resource__c, Invoice_Type__c, Status,  
                       RCTI__c, Claim_Job__c,Job_Type__c
                       FROM workOrder
                       WHERE id = :testCMFeesWo.id];
        
        
        test.startTest();
      	AR_Invoice__c testARInv = homeRepairTestDataFactory.createAR_Invoice(x);
        test.stopTest();
        
        AR_Invoice__c Inv = [SELECT id FROM AR_Invoice__c
                             WHERE id = :testARInv.id];
        
       // String expectedLabourResult = ('11.303.51300.220.000');
    }
}