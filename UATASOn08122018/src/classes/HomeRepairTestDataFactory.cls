/**
* Testdata factory for Home Repair
* 
* @author Vasu Gorakati
* @since   01 March 2018
*/
@isTest
public class HomeRepairTestDataFactory{
    /*
* * Description: To create test Accounts
* * Parameters: Record type
* * Return Type: List<Account>
*/
    public static List <Account> createAccounts(String accountName) {
        List <Account> accList = new List <Account> ();
        accList.add(new Account(Name = accountName));
        // Inserting Accounts
        insert accList;
        return accList;
    }
    
    public static List <Account> createRCTIAccounts(String accountName) {
        List <Account> accList = new List <Account> ();
        accList.add(new Account(Name = accountName,RCTI__c = true));
        insert accList;
        return accList;
    }
    
    public static Contact createContact(String contactName) {
        Contact con=new Contact();
        con.LastName=contactName;
        con.Phone='0265874111';
        con.MobilePhone='0465874111';
        insert con;
        return con;
    }
    
        public static Account createTradeAccount(){ 
        //create service resource Account related to work order
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
        return testAccount;
    }
    
    public static Contact createTradeContact(String contactName,Id accountId) {
        Contact con=new Contact();
        con.AccountId=accountId;
        con.LastName=contactName;
        con.Phone='0265874111';
        con.MobilePhone='0465874111';
        insert con;
        return con;
    }
    
    
    public static List<Lead> createLead(String companyName,String lastName, String  firstname) {
        
        List <Lead> leadList = new List <Lead> ();
        Lead l = new Lead(Company = companyName,
                          firstname =  firstname,
                          LastName = lastName);
        
        leadList.add(l);
        
        insert leadList;
        
        return leadList;
    }
    
    
    /*
* * Description: To create test Claim_Job_Ingestion_Staging__c
* * Parameters: ClaimNumber,InternalReferenceId,JobNumber,PolicyNumber
* * Return type: List<Claim_Job_Ingestion_Staging__c> 
*/
    public static List<Claim_Job_Ingestion_Staging__c> createClaimJobIngestionStaging(string ClaimNumber,string InternalReferenceId,string JobNumber,string PolicyNumber) {
        
        List <Claim_Job_Ingestion_Staging__c> claimJobIngestionStagingList = new List <Claim_Job_Ingestion_Staging__c> ();
        
        Claim_Job_Ingestion_Staging__c cjis=new Claim_Job_Ingestion_Staging__c(
            DateIssued__c=system.today(), 
            Brand__c='Test', 
            ClaimNumber__c=ClaimNumber, 
            ClaimType__c='ContentsRepair', 
            Claim_Description__c='Test Home Repair Ingestion #1', 
            DateReceived__c=system.today(), 
            HomeAge__c='1999', 
            Insured__c='Mr. TEST TEST', 
            InternalReferenceId__c=InternalReferenceId,  
            JobNumber__c=JobNumber, 
            JobSubType__c='doAndCharge', 
            JobType__c='authority', 
            Job_Description__c='Repair Carpets and Furniture', 
            LossDate__c=system.today(), 
            Policy_Number__c=PolicyNumber, 
            PrimaryContactHomePhone__c='03123232323', 
            PrimaryContactRelationshipToInsured__c='self', 
            PrimaryContact__c='TEST', 
            RiskAddressLine1__c='TEST', 
            RiskAddressPostcode__c='3006', 
            RiskAddressState__c='VIC', 
            RiskAddressSuburb__c='SOUTHBANK', 
            RoofType__c='Ironsteel', 
            Building_under_construction__c='notconstr', 
            StatusUpdateDate__c=system.today(), 
            Status__c='pending', 
            Process_Status__c='pending',
            Storeys__c='0');
        claimJobIngestionStagingList.add(cjis);
        
        insert claimJobIngestionStagingList;
        
        return claimJobIngestionStagingList;
    }
    /*
* * Description: To create test Claim_Job_Work_Items_Staging__c
* * Parameters: InternalReferenceId,JobNumber
* * Return type: List<Claim_Job_Work_Items_Staging__c> 
*/
    public static List<Claim_Job_Work_Items_Staging__c> createClaimJobWorkItemStaging(string InternalReferenceId,string JobNumber,string claimJobIngestionStagingId) {
        
        List <Claim_Job_Work_Items_Staging__c> claimJobWorkItemsList = new List <Claim_Job_Work_Items_Staging__c> ();
        
        Claim_Job_Work_Items_Staging__c cjwi=new Claim_Job_Work_Items_Staging__c(Category__c='furniture', 
                                                                                 Work_Item_Type__c='ContentsUnlistedItem', 
                                                                                 Item__c='loungesuite', 
                                                                                 Number_Of_Items__c=1, 
                                                                                 Source_Internal_Reference_Id__c=InternalReferenceId, 
                                                                                 Claim_Job_Ingestion_Staging__c=claimJobIngestionStagingId,
                                                                                 Job_Number__c=JobNumber);
        
        claimJobWorkItemsList.add(cjwi);
        
        insert claimJobWorkItemsList;
        
        return claimJobWorkItemsList;
    }
    public static WorkType createWorkType(String RecordTypeName,String workTypeName){
        WorkType wt=new WorkType();
        system.debug(RecordTypeName+'RecordType :'+retriveRecordTypeId(RecordTypeName,'WorkType'));
        wt.RecordTypeId=retriveRecordTypeId(RecordTypeName,'WorkType');
        wt.Name=workTypeName;
        wt.DurationType='Hours';
        wt.EstimatedDuration=1.0;
        Insert wt;
        return wt;
    }
        
    public static void createProductForWorkType(String productName,String workTypeId,decimal unitPrice,string priceBookName){
        Product2 Prod =  new Product2();
        Prod.Name=productName;
        Prod.IsActive=True;
        Prod.Work_Type__c=workTypeId;
        insert Prod;
        
        // Instantiate the Pricebook2 record first, setting the Id
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        // Run an update DML on the Pricebook2 record
        // This is the weird workaround that enables IsStandard to become true
        // on the PricebookEntry record
        update standardPricebook;
        
        // Re-Query for the Pricebook2 record, for debugging
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        Pricebook2 customPB = new Pricebook2(Name=productName+priceBookName, isActive=true,State__c=priceBookName);
        insert customPB;
        
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id=Prod.Id;
        pbe.IsActive=True;
        pbe.UnitPrice=unitPrice;
        pbe.Pricebook2Id = customPB.Id;
        pbe.UseStandardPrice=false;
        system.debug('pbe '+pbe);
        insert pbe;
    }
    public static AP_Invoice__c createAPInvoiceWithWorkOrder(String workOrderId){
        AP_Invoice__c ap=new AP_Invoice__c();
        ap.Work_Order__c=workOrderId;
        insert ap;
        return ap;
    }
    public static WorkOrder createWorkOrderWithCase(String RecordTypeName,String CaseId,String workTypeId, string claimJobId){ 
        WorkOrder wo = new WorkOrder();
        wo.subject ='title';
        wo.WorkTypeId=workTypeId;
        wo.CaseId=CaseId;
        wo.Status='New';
        wo.Claim_Job__c = claimJobId;
        if(RecordTypeName != ''){
            wo.RecordTypeId= retriveRecordTypeId(RecordTypeName,'WorkOrder');
            system.debug(retriveRecordTypeId(RecordTypeName,'WorkOrder'));
        }
        system.debug(wo);
        insert wo;

        Claim_Job__c clmJob = HomeRepairTestDataFactory.createClaimJob(CaseId);
        System.debug('Claim job:'+clmJob);
        wo.Claim_Job__c =  clmJob.Id;     
        update wo;
        
        return wo;
    }
    
     public static WorkOrder createWorkOrderWithCaseAR(String RecordTypeName,String CaseId,String workTypeId, string claimJobId, string accId){ 
        WorkOrder wo = new WorkOrder();
        wo.subject ='title';
        wo.WorkTypeId=workTypeId;
        wo.CaseId=CaseId;
        wo.Status='Closed';
        wo.Claim_Job__c = claimJobId;
        wo.Service_Resource_Company__c = accId;
        wo.RecordLocked__c = false;
        wo.Invoice_Type__c = 'Standard Invoice';
               
        if(RecordTypeName != ''){
            wo.RecordTypeId= retriveRecordTypeId(RecordTypeName,'WorkOrder');
            system.debug(retriveRecordTypeId(RecordTypeName,'WorkOrder'));
        }
        system.debug(wo);
        insert wo; 
         
         
         Claim_Job__c clmJob = HomeRepairTestDataFactory.createClaimJob(CaseId);
        System.debug('Claim job:'+clmJob);
        wo.Claim_Job__c =  clmJob.Id;     
        update wo;
        
        return wo;
         
     }  
    
    public static All_Service_Appointments__c createAllServiceAppointments(string caseId,string workOrderId){
        All_Service_Appointments__c asa=new All_Service_Appointments__c();
        asa.Claim__c=caseId;
        asa.Work_Order__c=workOrderId;
        insert asa;
        return asa;
    }
    public static List<WorkOrderLineItem> createWorkOrderLineItem(String RecordTypeName,String CaseId,String workTypeId){       
        WorkOrder wo = new WorkOrder();
        wo.subject ='title';
        wo.WorkTypeId=workTypeId;
        wo.CaseId=CaseId;
        if(RecordTypeName != ''){
            wo.RecordTypeId= retriveRecordTypeId(RecordTypeName,'WorkOrder');
            system.debug(retriveRecordTypeId(RecordTypeName,'WorkOrder'));
        }
        system.debug(wo);
        insert wo;
        List<WorkOrderLineItem> woliList=new List<WorkOrderLineItem>();
        WorkOrderLineItem woli = new WorkOrderLineItem();
        woli.workOrderId = wo.Id;
        woli.description = 'abcd';
        woli.workTypeId=workTypeId;
        woliList.add(woli);
        woli = new WorkOrderLineItem();
        woli.workOrderId = wo.Id;
        woli.description = 'cdba';
        woli.workTypeId=workTypeId;
        woliList.add(woli);
        insert woliList;
        return woliList;
    }
    public static List<WorkOrderLineItem> createWorkOrderLineItem(String RecordTypeName,String CaseId,String workTypeId, String workOrderId, Decimal siteVisitNumber){       
        List<WorkOrderLineItem> woliList=new List<WorkOrderLineItem>();
        WorkOrderLineItem woli = new WorkOrderLineItem();
        woli.workOrderId = workOrderId;
        woli.description = 'abcd';
        woli.Site_Visit_Number__c=2;
        woli.workTypeId=workTypeId;
        woliList.add(woli);
        insert woliList;
        return woliList;
    }
    public static void createProductWithPricebookEntry(String productName){
        Product2 Prod =  new Product2();
        Prod.Name=productName;
        Prod.IsActive=True;
        insert Prod;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id=Prod.Id;
        pbe.IsActive=True;
        pbe.UnitPrice=70;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.UseStandardPrice=false;
        insert pbe;
    }
    public static List<Product2> createProductWithPricebookEntryAndWorkCodes(String productName){
        List<Work_Code_Group__c> workCodeList=new List<Work_Code_Group__c>();
        Work_Code_Group__c wc1=new Work_Code_Group__c();
        wc1.Description__c='Level 1';
        wc1.Level__c='Level 1';
        workCodeList.add(wc1);
        
        Work_Code_Group__c wc2=new Work_Code_Group__c();
        wc2.Description__c='Level 2';
        wc2.Level__c='Level 2';
        workCodeList.add(wc2);
        
        Work_Code_Group__c wc3=new Work_Code_Group__c();
        wc3.Description__c='Level 3';
        wc3.Level__c='Level 3';
        workCodeList.add(wc3);
        
        Work_Code_Group__c wc4=new Work_Code_Group__c();
        wc4.Description__c='Level 4';
        wc4.Level__c='Level 4';
        workCodeList.add(wc4);
        
        Work_Code_Group__c wc5=new Work_Code_Group__c();
        wc5.Description__c='Level 5';
        wc5.Level__c='Level 5';
        workCodeList.add(wc5);
        
        insert workCodeList;
        
        List<Product2> proList=new List<Product2>();
        Product2 Prod =  new Product2();
        Prod.Name=productName;
        Prod.IsActive=True;
        Prod.Level_1__c=wc1.Id;
        Prod.Level_2__c=wc2.Id;
        Prod.Level_3__c=wc3.Id;
        Prod.Level_4__c=wc4.Id;
        Prod.Level_5__c=wc5.Id;
        Prod.RecordTypeId=retriveRecordTypeId('Repair Item','Product2');
        proList.add(Prod);
        insert proList;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id=proList[0].Id;
        pbe.IsActive=True;
        pbe.UnitPrice=70;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.UseStandardPrice=false;
        insert pbe;
        
        return proList;
    }
    public static List<Product2> createProductsWithPricebookEntryAndWorkCodes(String productName,String workTypeId,decimal unitPrice,string priceBookName){
        List<Work_Code_Group__c> workCodeList=new List<Work_Code_Group__c>();
        Work_Code_Group__c wc1=new Work_Code_Group__c();
        wc1.Description__c='Level 1';
        wc1.Level__c='Level 1';
        workCodeList.add(wc1);
        
        Work_Code_Group__c wc2=new Work_Code_Group__c();
        wc2.Description__c='Level 2';
        wc2.Level__c='Level 2';
        workCodeList.add(wc2);
        
        Work_Code_Group__c wc3=new Work_Code_Group__c();
        wc3.Description__c='Level 3';
        wc3.Level__c='Level 3';
        workCodeList.add(wc3);
        
        Work_Code_Group__c wc4=new Work_Code_Group__c();
        wc4.Description__c='Level 4';
        wc4.Level__c='Level 4';
        workCodeList.add(wc4);
        
        Work_Code_Group__c wc5=new Work_Code_Group__c();
        wc5.Description__c='Level 5';
        wc5.Level__c='Level 5';
        workCodeList.add(wc5);
        
        insert workCodeList;
        
        List<Product2> proList=new List<Product2>();
        Product2 Prod =  new Product2();
        Prod.Name=productName;
        Prod.Work_Type__c=workTypeId;        
        Prod.IsActive=True;
        Prod.Level_1__c=wc1.Id;
        Prod.Level_2__c=wc2.Id;
        Prod.Level_3__c=wc3.Id;
        Prod.Level_4__c=wc4.Id;
        Prod.Level_5__c=wc5.Id;
        Prod.RecordTypeId=retriveRecordTypeId('Repair Item','Product2');
        proList.add(Prod);
        insert proList;
        
        
        Pricebook2 customPB = new Pricebook2(Name=productName+priceBookName, isActive=true,State__c=priceBookName);
        insert customPB;
        
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id=proList[0].Id;
        pbe.IsActive=True;
        pbe.UnitPrice=700;
        pbe.Pricebook2Id = customPB.Id;
        pbe.UseStandardPrice=false;
        system.debug('pbe '+pbe);
        insert pbe;
        
        return proList;
    }
    public static Case createCase(){
        // Create the Case Record.
        Case cas = new Case(Status ='new', Priority = 'Medium', Origin = 'Web');
        
        insert cas;
        return cas;
    }
    public static Case createCaseWithOrigin(){
        // Create the Case Record.
        Case cas = new Case(Status ='new', 
                            Priority = 'Medium', 
                            Origin = 'Suncrop'); 
        insert cas;
        return cas;
    }
    public static Policy__c createPolicy(){
        Policy__c po=new Policy__c();
        po.Insured__c='Test';
        po.AddressLine1__c='Test';
        po.AddressLine2__c='Test';
        po.AddressLine3__c='Test';
        po.Suburb__c='Test';
        po.State__c='VIC';
        po.Postcode__c='3001';        
        insert po;
        return po;
    }
    public static Case createCaseWithOriginAndPolicy(string id,string conId){
        // Create the Case Record.
        Case cas = new Case(Status ='new', 
                            Asbestos__c = 'Home built before 1990',
                            Appoint_Repair_Link_Assessor__c = 'Yes',
                            Contents_Damaged__c = 'Carpet',
                            Priority = 'Medium', 
                            Origin = 'Suncorp'); 
        cas.Policy__c=id;
        cas.ContactId=conId;
        
        insert cas;
        return cas;
    }
    public static Attachment createAttachment(string parentId,string bodyData,string description,string name){
        Attachment attach=new Attachment();     
        attach.Name=name;
        attach.Description=description;
        Blob bodyBlob=Blob.valueOf(bodyData);
        attach.body=bodyBlob;
        attach.parentId=parentId;
        insert attach;
        return attach;
    }
    public static void addContentVersionToParent(Id parentId) {
        Blob b = Blob.valueOf('Test Data');        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData =b;
        cv.Title = 'Test';
        cv.PathOnClient = 'Test';
        insert cv;
        ContentVersion cnt = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id limit 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cnt.ContentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'V';
        insert cdl;
    }
   /*************************************************
 	* Description: create Service Appointment parsing claim id or workOrder id and string representing status 
					and Service Resource Id
 	**************************************************/
    public static ServiceAppointment createNewServiceAppointment(Id parentID, String Status, Id ClaimId, Id ServiceResourceId) {
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=parentID;
        sa.Claim__c = ClaimId;
        sa.Service_Resource__c = ServiceResourceId;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now()+ 5; // 5 days
        sa.Status = Status;
        
        
        //system.debug('***SA: ' + sa);
        
   		insert sa;
        return sa;
    }
    public static User createTradeUser(Id ContactId) {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Trade Platfrom Community Plus User' LIMIT 1];        
        system.debug('profile: ' + profile);
        system.debug('ContactId: ' + ContactId);
        
        User usr = new User(LastName = 'Cunningham',
                           FirstName='Richie',
                           Alias = 'richic',
                           Email = 'rcunningham@fonz.com',
                           Username = 'ric054@fonzy.com',
                           ProfileId = profile.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_AU',
                           isActive = true,
                           PortalRole = 'Manager', 
                           ContactId = ContactId);
        
       
        system.debug('***userContactId: ' + usr.ContactId);
        insert usr;
      
        return usr;
        
    }

   public static ServiceResource createNewServiceResource (Id userId){
        ServiceResource SR = new ServiceResource();
        SR.Name = 'Bonjisto';
        SR.RelatedRecordId = userId;
        SR.IsActive = true;
        SR.IsCapacityBased = false;
        SR.ResourceType = 'T';		// Technician
        insert SR;
        return SR;        
    }
    
   public static Room__c createRoom(String claimId,List<WorkOrderLineItem> woliList){
        Room__c rm=new Room__c();            
        rm.Name='Test';                     
        rm.Height__c=7;
        rm.Length__c=7;
        rm.Width__c=7;
        rm.Claim__c=claimId;
        insert rm;
        
        for(WorkOrderLineItem woli: woliList){
            woli.Room__c = rm.Id;
        }
        update woliList;
        return rm;
    }
     @future(callout=false)
    public static void assignFSLPermissionSets(Id usrId) {
        
        System.Debug('Assigning FSL Resource Permissions...');
        PermissionSet p = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions' LIMIT 1];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = usrId;
        psa.PermissionSetId = p.Id;
        insert psa;
        
        System.Debug('FSL Resource Permissions Assignment: ' + psa);
        
        System.Debug('Assigning FSL Resource License Permissions...');
        PermissionSet p1 = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_License' LIMIT 1];
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = usrId;
        psa1.PermissionSetId = p1.Id;
    insert psa1;
        
        System.Debug('FSL Resource License Permissions Assignment: ' + psa1);
    }
    private static string retriveRecordTypeId(String RecordTypeName,String ObjectName){
        string devRecordTypeId = Schema.getGlobalDescribe().get(ObjectName).getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        return devRecordTypeId;
    }
    //accepts workOrder then changes status to closed - creating an invoice
    public static AP_Invoice__c createAP_Invoice(workOrder wo){
        wo.Status = 'closed';
        update wo;
        
        //automated process should create AP invoice from WO closing, retrieve said Invoice
        AP_Invoice__c apInv = [SELECT id
                               FROM AP_Invoice__c
                               WHERE Work_Order__c = :wo.id];
        return apInv;
    }
    
    //accepts assessment workOrder and creates CMFees invoice
    public static AR_Invoice__c createAR_Invoice(workOrder wo){
        wo.Status = 'Assessment Scheduled';
        wo.Service_Resource__c = '0Hn5D000000CbC9';
        update wo;
        
        system.debug('woKan1 ' + wo);
        
        
        //automated process should create AR invoice from WO Assessment Schedule, retrieve newly created Invoice
        AR_Invoice__c arInv = [SELECT id, Claim_Job__c
                               FROM AR_Invoice__c];
       
        return arInv;
    }
    
    
    //Create claim job & associate to claim
    public static Claim_Job__c createClaimJob(string caseId){
        Claim_Job__c testClaimJob = new Claim_Job__c();
        testClaimJob.Claim__c = caseId;
        testClaimJob.Job_Type__c = 'doAndCharge';
        insert testClaimJob;
        return testClaimJob;
    }
    
    //Create Vendor Note
    public static Vendor_Note__c createVendorNote(string caseId){
        Vendor_Note__c testVendor = new Vendor_Note__c();
        testVendor.Claim__c = caseId;
        testVendor.Text__c = 'Test';
        testVendor.Category__c = 'Passive Note';
        insert testVendor;
        return testVendor;
    }
    
    
    //Create AR Invoice
    public static AR_Invoice__c createARInvoice(string claimJobId){
        // Create the Invoice__c Record.
        AR_Invoice__c arInv = new AR_Invoice__c(); 
        arInv.Claim_Job__c= claimJobId;
        insert arInv;
        return arInv;
    }
    
    
    
    //Create General settings
    public static GeneralSettings__c generalSettings(string Key, String value){
        // Create general setting record
        GeneralSettings__c gs = new GeneralSettings__c(); 
        gs.Name = key;
        gs.Key__c = key;
        gs.Value__c = value;
        insert gs;
        return gs;
    } 
    
    //Create Home_Repairs_Trigger_Switch__c
    public static Home_Repairs_Trigger_Switch__c createHomeRepairsTriggerSwitch(){
        Home_Repairs_Trigger_Switch__c hrts = Home_Repairs_Trigger_Switch__c.getOrgDefaults();
        hrts.Trigger_On_Case__c=true;
        hrts.Trigger_On_Lead__c=true;
        upsert hrts custSettings__c.Id;
        return hrts;
    } 
    

}