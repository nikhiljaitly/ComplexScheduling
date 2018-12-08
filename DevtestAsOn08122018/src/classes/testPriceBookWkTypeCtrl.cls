@isTest
public class testPriceBookWkTypeCtrl {
    @isTest static void testPriceBookWkTypeCtrl(){
        //create policy
        policy__c testPolicy = homeRepairTestDataFactory.createPolicy();
        //System.debug('policy: ' + testPolicy);
        
        //create case associated to policy
        case testCase = new Case();
		testCase.Origin = 'Web';
		testCase.Status = 'Suncorp';
		testCase.Priority = 'Medium';        
        testCase.Policy__c = testPolicy.id;
        //testCase.Policy__r.State__c = 'VIC';
        testCase.Total_Price__c = 200.00;
        insert testCase;
        //System.debug('testCase: ' + testCase);
        
        String caseID = testCase.id;
        
        //claim job associated to claim
        Claim_Job__c testClaimJob = new Claim_Job__c();
        testClaimJob.Claim__c = testCase.id;
        testClaimJob.Job_Type__c = 'doAndCharge';
        insert testClaimJob;
        //system.debug('testClaimJob: ' + testClaimJob);
        
        //create profile for user to be assigned
        
        
        //create user to be service resource
        /*User testUser = new User();
        testUser.Username = 'testUser@fakemail.com';
        testUser.LastName = 'User';
        testUser.Alias = 'tUser';
        testUser.Email = 'tUser@fakemail.com';
        testUser.CommunityNickname = 'tUser';
        testUser.ProfileId = '2F00e5D000000Drjd';
        
        insert testUser;
        
        //service resource relatable to work order
        serviceResource testResource = new serviceResource();
        testResource.Name = 'bob';
        testResource.RelatedRecordId = testUser.id;
        //testResource.ResourceType = 'Technician';
        insert testResource;
        System.debug('testResource: ' + testResource);*/
        
        //create service resource Account relatable to work order
		Account testAccount = new Account();
        //business details
		testAccount.Name = 'testAccount';
		testAccount.ABN__c = '1234';
		testAccount.ABN_Status__c = 'Active';
		testAccount.GST_Status__c = 'Active';
		testAccount.Phone = '0404040404';
		testAccount.When_did_your_business_commence_trading__c = date.newInstance(2011,11,11);
		testAccount.Business_Structure__c = 'sample structure';
        testAccount.RCTI__c = true;
        //business work type
		testAccount.Work_Type__c = 'CabinetMaker';
		testAccount.Service_Areas__c = 'VIC';
		testAccount.Jobs_Per_Week__c = 40;
        //insurance
		testAccount.Public_Liability_Insurance_Provider__c = 'sample insurer';
		testAccount.Public_Liability_Cover_Amount__c = 100.00;
		testAccount.Public_Liability_Expiry__c = date.newInstance(3000, 3, 3);
        testAccount.Work_Cover_Amount__c = 100.00;
        testAccount.Work_Cover_Expiry__c = date.newInstance(3000, 3, 3);
        testAccount.Work_Cover_Insurance_Provider__c = 'sample insurer';
        testAccount.Work_Cover_Insurance_State__c = 'VIC';
        //safe work agreement
        testAccount.Safe_Work_Method_Statement_Agreement__c = 'Yes';
        //bank details
        testAccount.Bank_Account_Name__c = 'sample bank';
        testAccount.BSB__c = '123123';
        testAccount.Account_Number__c = '22221111';
        //accounts contact
        testAccount.Accounts_First_Name__c = 'john';
        testaccount.Accounts_Last_Name__c = 'tron';
        testAccount.Accounts_Phone__c = '2424242424';
        testAccount.Accounts_Email_Address__c = 'jtron@fakemail.com';
        testAccount.AC_Position_in_Company__c = 'cc';
        //jobs related contact
        testAccount.Job_Related_First_Name__c = 'john';
        testAccount.Job_Related_Last_Name__c = 'Gong';
        testAccount.Job_Related_Phone__c = '4545454545';
        testAccount.Job_Related_Position_in_Company__c = 'ff';
        testAccount.Job_Email_Address__c = 'jgong@fakemail.com';
        //License, Authorities, certs and rego's
        testAccount.Any_previous_complaints__c = 'No';
        //other work
        testAccount.Any_current_work_orders__c = 'No';
        testAccount.Any_previous_work__c = 'No';
        //referred?
        testAccount.Referred__c = 'No';
        
        insert testAccount;
        //system.debug('testAccount: ' + testAccount);
		        
        
        String workTypeID = '08q5D00000001Q5';//Cabinetmaker
        
        //generate AP workOrder
        workOrder testWo = new workOrder();
        testWo.Claim_Job__c = testClaimJob.id;
        testWo.Subject = 'repair';
        testWo.WorkTypeid = workTypeID;
        testWo.caseid = caseID;
        testWo.Customer_Invoice_Ref__c = 'INVREF1234';
        //testWo.RCTI__c = true;
        testWo.Call_Invoice_Gen_Srvc_for_Non_RCTI__c = true;
        //testWo.Service_Resource__c = testResource.id;
        testWo.Service_Resource_Company__c = testAccount.id;
        insert testWo;
        //system.debug('testWo: ' + testWo);

        //generate gst chargeable products for woli's
  		Product2 testProduct = new Product2();
        
        testProduct.Name = 'testProduct';
        testProduct.GST_Exempt_Labour__c = false;
        testProduct.GST_Exempt_Material__c = false;
        insert testProduct;
        //system.debug('testProduct: ' + testProduct);
        
        List <PricebookEntry> pbList = new List <PricebookEntry> ();      
        pbList = [select id, Name, ProductCode from PricebookEntry limit 1];
        string sPricebookEntryId = pbList[0].Id;
        string woRecId = testWo.Id;
        string searchWorkType = 'Electrician';
        String searchState = 'VIC';
        String searchKeyWord = 'smoke';
        String pbObjectName = 'PricebookEntry';
        String WkOrderObjectName = 'WorkOrder';
        String SAOrderObjectName = 'ServiceAppointment';
        String roomOrderObjectName = 'Room__c';
        String woRecordId = testWo.Id;
        
        
        //generate woli's associated to workOrder and product
        workOrderLineItem testWOLI = new workOrderLineItem();
        testWOLI.PricebookEntryId = sPricebookEntryId;
        testWOLI.WorkOrderId = testWo.Id;
        testWOLI.WorkTypeId = workTypeID;
        testWOLI.Description = 'abc';
        testWOLI.Site_Visit_Number__c = 1;
        testWOLI.Labour_Cost__c = 100.00;
        testWOLI.Labour_Time__c = 1.00;
        testWOLI.Material_Cost__c = 100.00;
        //testWOLI.Quantity = 1;
        // testWOLI.Status = 'closed';
      	// insert testWOLI;

        test.startTest();
		HRPriceBookWkTypeController.fetchLookUpValues(searchWorkType, searchState, searchKeyWord, pbObjectName, woRecordId);
        HRPriceBookWkTypeController.fetchLookUpValues(searchWorkType, searchState, searchKeyWord, WkOrderObjectName, woRecordId);
        HRPriceBookWkTypeController.fetchLookUpValues(searchWorkType, searchState, searchKeyWord, SAOrderObjectName, woRecordId);
        HRPriceBookWkTypeController.fetchLookUpValues(searchWorkType, searchState, searchKeyWord, roomOrderObjectName, woRecordId);
        HRPriceBookWkTypeController.getWorkOrderWorkType(woRecordId);
        test.stopTest();
      
    }
}