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
    public static Contact createContact(String contactName) {
       Contact con=new Contact();
       con.LastName=contactName;
       con.Phone='0265874111';
       con.MobilePhone='0465874111';
       insert con;
       return con;
    }
     public static List<Lead> createLead(String companyName,String lastName) {

        List <Lead> leadList = new List <Lead> ();
        Lead l = new Lead(Company = companyName,
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
    
    public static void createProductForWorkType(String productName,String workTypeId){
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
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id=Prod.Id;
        pbe.IsActive=True;
        pbe.UnitPrice=70;
        //pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Pricebook2Id = standardPricebook.Id;
        pbe.UseStandardPrice=false;
        insert pbe;
    }
    public static AP_Invoice__c createAPInvoiceWithWorkOrder(String workOrderId){
        AP_Invoice__c ap=new AP_Invoice__c();
        ap.Work_Order__c=workOrderId;
        insert ap;
        return ap;
    }
    public static WorkOrder createWorkOrderWithCase(String RecordTypeName,String CaseId,String workTypeId){ 
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
        /*woli = new WorkOrderLineItem();
        woli.workOrderId = workOrderId;
        woli.Site_Visit_Number__c=1;
        woli.description = 'cdba';
        woli.workTypeId=workTypeId;
        woliList.add(woli);*/
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
    public static Case createCase(){
        // Create the Case Record.
        Case cas = new Case(Status ='new', Priority = 'Medium', Origin = 'Web');
        
        insert cas;
        return cas;
    }
    public static Case createCaseWithOrigin(){
        // Create the Case Record.
        Case cas = new Case(Status ='new', Priority = 'Medium', Origin = 'Suncrop'); 
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
        Case cas = new Case(Status ='new', Priority = 'Medium', Origin = 'Suncorp'); 
        cas.Policy__c=id;
        cas.ContactId=conId;
        insert cas;
        return cas;
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
    public static void createServiceAppointment(Id parentId) {
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=parentId;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now();
        insert sa;
    }
    public static ServiceAppointment createNewServiceAppointment(Id caseID, String Status) {
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=caseID;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now()+5;
        sa.Status = Status;
        system.debug('***SA: ' + sa);
        try{
            insert sa;
        }
        catch(exception e){
            String error = e.getMessage();
            system.debug(LoggingLEvel.DEBUG, 'error: ' + error);
        }
        return sa;
    }
    
    //public static Room__c createRoom(String claimId,String WorkOrderId,String WorkTypeId){
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
                              // WHERE Claim_Job__c = :wo.Claim_Job__c];
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
    
    //Create AR Invoice
    public static AR_Invoice__c createARInvoice(string claimJobId){
        // Create the Invoice__c Record.
        AR_Invoice__c arInv = new AR_Invoice__c(); 
        arInv.Claim_Job__c= claimJobId;
        insert arInv;
        return arInv;
    }
    
   public static Account createServiceResource(){ 
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
        return testAccount;
   }
    
    
}