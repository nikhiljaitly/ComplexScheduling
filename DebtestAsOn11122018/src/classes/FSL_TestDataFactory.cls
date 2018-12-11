/*************
 * Test Data Factory for FSL test classes
 * Author: Brandon Moss
 * Date: 23/11/2019
 * Description: Factory to create FSL Data Objects
 */

@isTest
public class FSL_TestDataFactory {
	
    
    /*************************************************
 	* Description: create claim, adds policy, contact
 	**************************************************/
    public static Case createClaim(){
        // Create the Case Record.
        Case cas = new Case(Status ='new', Priority = 'Medium', Origin = 'Suncorp'); 
        //create policy
        Policy__c testPol = createPolicy();
        cas.Policy__c = testPol.Id;
        //create contact
        Contact con = createContact();
        cas.ContactId = con.Id;
        //system.debug(cas);
        try{
        insert cas;
        
        } catch(exception e){
            system.debug('error: ' + e.getMessage());
        }
        return cas;
    }
    
    /*************************************************
 	* Description: create work order accepts claim id, worktype ID, location, Service Territory and record type name
 	**************************************************/
    public static WorkOrder createWorkOrderWithCase(String RecordTypeName,String CaseId,Id workTypeId,
                                                    Id serviceTerritoryId,
                                                   String streetAddress,
                                                         String city,
                                                         String state,
                                                         String postCode,
                                                         String country){ 
        WorkOrder wo = new WorkOrder();
        wo.ServiceTerritoryId = serviceTerritoryId;
        wo.subject ='title';
        wo.status = 'New';
        wo.WorkTypeId=workTypeId;
        wo.CaseId=CaseId;
        wo.Subject = 'Test WO';
        wo.Street = streetAddress;
        wo.City = city;
        wo.State = state;
        wo.PostalCode = postCode;
        wo.Country = country;
                                                             
        String cJob = createClaimJob(CaseId);
        wo.Claim_Job__c = cJob;
        
        if(RecordTypeName != ''){
           wo.RecordTypeId= retrieveRecordTypeId(RecordTypeName,'WorkOrder');
           system.debug(retrieveRecordTypeId(RecordTypeName,'WorkOrder'));
        }
        system.debug(wo);
        insert wo;
        return wo;
    }
    /*************************************************
 	* Description: create work order accepts claim id, worktype ID, location and record type name
 	**************************************************/
    public static WorkOrder createWorkOrderWithCase(String RecordTypeName,String CaseId,Id workTypeId,
                                                   String streetAddress,
                                                         String city,
                                                         String state,
                                                         String postCode,
                                                         String country){ 
        WorkOrder wo = new WorkOrder();
        wo.subject ='title';
        wo.status = 'New';
        wo.WorkTypeId=workTypeId;
        wo.CaseId=CaseId;
        wo.Subject = 'Test WO';
        wo.Street = streetAddress;
        wo.City = city;
        wo.State = state;
        wo.PostalCode = postCode;
        wo.Country = country;
                                                             
        String cJob = createClaimJob(CaseId);
        wo.Claim_Job__c = cJob;
        
        if(RecordTypeName != ''){
           wo.RecordTypeId= retrieveRecordTypeId(RecordTypeName,'WorkOrder');
           system.debug(retrieveRecordTypeId(RecordTypeName,'WorkOrder'));
        }
        system.debug(wo);
        insert wo;
        return wo;
    }
    
    /*************************************************
 	* Description: create wo with default recordtype as homeRepair Trades and default worktype
 	**************************************************/
    public static WorkOrder HRTradeWorkOrderWithCase(String CaseId){ 
        WorkOrder wo = new WorkOrder();
        wo.Status = 'New';
        wo.subject ='title';
        String cJob = createClaimJob(CaseId);
        wo.Claim_Job__c = cJob;
        
        //wo.Claim__c = CaseId;
        
        wo.CaseId=CaseId;
        wo.RecordTypeId = retrieveRecordTypeId('Home Repair Trades', 'WorkOrder');
        
        //Default WorkType: Electrician
        workType TestElectrician = createWorkType('Repair Items', 'Electrician');
        
        wo.WorkTypeId = TestElectrician.Id;
        //system.debug('wo: ' + wo);
        insert wo;
        return wo;
    }
    /*************************************************
 	* Description: create work order line item
 	**************************************************/
    public static workOrderLineItem createWOLI(Id workOrderId){
        workOrderLineItem WOLI = new workOrderLineItem();
        WOLI.WorkOrderId = workOrderId;
        WOLI.Site_Visit_Number__c = 1;
        
        insert WOLI;
        return WOLI;
    }
    
    /*************************************************
 	* Description: create work type accepts name for worktype and recordtype name
 	**************************************************/
    public static WorkType createWorkType(String RecordTypeName,String workTypeName){
        WorkType wt=new WorkType();
       // system.debug(RecordTypeName+'RecordType :'+retrieveRecordTypeId(RecordTypeName,'WorkType'));
        wt.RecordTypeId=retrieveRecordTypeId(RecordTypeName,'WorkType');
        wt.Name=workTypeName;
        wt.DurationType='Hours';
        wt.EstimatedDuration=1.0;
        wt.ShouldAutoCreateSvcAppt = true; // negates need to create SA Manually in code for Work Type
        Insert wt;
        return wt;
    }
    
    /*************************************************
 	* Description: find a FSL Skill
 	**************************************************/
    public static Skill findSkill(String skillName) {
        Skill skill = [Select Id, Description, DeveloperName, Language, MasterLabel
                       From Skill Where DeveloperName = :skillName];
        
        return skill;
        
    }
    
    /*************************************************
 	* Description: create a Service Resource Skill
 	**************************************************/
    public static ServiceResourceSkill createSRSkill(Id serviceResourceId, Id skillId) {
        ServiceResourceSkill sk = new ServiceResourceSkill();
        sk.SkillId = skillId;
        sk.ServiceResourceId = serviceResourceId;
        sk.EffectiveStartDate = System.DateTime.now();
        insert sk;
        return sk;
    }
    
    /*************************************************
 	* Description: create a Work Type Skill
 	**************************************************/
    public static SkillRequirement createSkillReq(Id workTypeId, Id skillId) {
        SkillRequirement skR = new SkillRequirement();
        skR.RelatedRecordId = workTypeId;
        skR.SkillId = skillId;
        
        insert skR;
        return skR;
    }
    
    
    /*************************************************
 	* Description: create Service Appointment parsing claim id or workOrder id and string representing status
 	**************************************************/
    public static ServiceAppointment createNewServiceAppointment(Id parentID, String Status) {
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=parentID;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now()+ 5; // 5 days
        sa.Status = Status;
        sa.Duration = 1;
        sa.DurationType = 'Hours';
        
        //system.debug('***SA: ' + sa);
        
   		insert sa;
        return sa;
    }
    
    /*************************************************
 	* Description: create Service Appointment parsing claim id or workOrder id and string representing status
 	**************************************************/
    public static ServiceAppointment createNewServiceAppointment(Id parentID, Id Tier2Trade, String Status) {
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=parentID;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now()+ 5; // 5 days
        sa.Status = Status;
        sa.Duration = 1;
        sa.DurationType = 'Hours';
        
        sa.Tier_2_Trade_Account__c = Tier2Trade;
        
        //system.debug('***SA: ' + sa);
        
   		insert sa;
        return sa;
    }
    /*************************************************
 	* Description: create Service Appointment parsing claim id and workOrder id and string representing status
 	**************************************************/
    public static ServiceAppointment createNewServiceAppointment(Id workOrderID, String Status, Id ClaimId) {
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=workOrderID;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now()+ 5; // 5 days
        sa.Claim__c = ClaimId;
        sa.Status = Status;
        sa.Duration = 1;
        sa.DurationType = 'Hours';
        
        //system.debug('***SA: ' + sa);
        
   		insert sa;
        return sa;
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
    
    /*************************************************
 	* Description: create Service Appointment using workOrder base data
 	**************************************************/
    public static ServiceAppointment createNewServiceAppointment(WorkOrder wo, String Status, Id serviceTerritoryId) {
        System.debug('***createNewServiceAppointment Passed in WO:  ' + wo);
        ServiceAppointment sa=new ServiceAppointment();
        sa.ParentRecordId=wo.Id;
        sa.ServiceTerritoryId = serviceTerritoryId;
        //sa.WorkTypeId = wo.WorkTypeId;
        sa.Street = wo.Street;
        sa.City = wo.City;
        sa.State = wo.State;
        sa.PostalCode = wo.PostalCode;
        sa.Country = wo.Country;
        sa.EarliestStartTime=System.DateTime.now();
        sa.DueDate=System.DateTime.now()+5;
        sa.Status = Status;
        
        
        //system.debug('***SA: ' + sa);
        
   		insert sa;
        
        System.debug('***createNewServiceAppointment Created SA:  ' + sa);
        
        return sa;
    }
    
    /*************************************************
 	* Description: create Scheduling Policy(Customer First)
 	**************************************************/
    public static FSL__Scheduling_Policy__c createShedulingPolicy(String TestName){
        FSL__Scheduling_Policy__c testPol = new FSL__Scheduling_Policy__c();
        testPol.Name = TestName;
        testPol.FSL__Description__c = 'This policy balances great customer service with travel minimization. Appointments are graded first by the customer\'s selection of a preferred employee and by the ability to provide the service as soon as possible. Travel minimization is considered as a second priority.';
        insert testPol;
        return testPol;
        
    }
    
    /*************************************************
 	* Description: create Work Rule (Customer First)
 	**************************************************/
    public static void createWorkRulesforPolicy(Id schedPolicyId) {
        List<FSL__Work_Rule__c> workRuleList = new List<FSL__Work_Rule__c>();
        
        // Active Resources
        FSL__Work_Rule__c wr1 = new FSL__Work_Rule__c();
        wr1.RecordTypeId=retrieveRecordTypeId('Field Service - Match Boolean','FSL__Work_Rule__c');
        System.Debug('Work Rule Record Type Id = ' + wr1.RecordTypeId);
        wr1.Name = 'Active Resources';
        wr1.FSL__Resource_Property__c = 'IsActive';
        wr1.FSL__Match_Constant_Boolean_Value__c = true;
        wr1.FSL__Match_Skill_Level__c = false;
        wr1.FSL__Active__c = true;
        workRuleList.add(wr1);
        
        // Capacity Exceeded
        FSL__Work_Rule__c wr2 = new FSL__Work_Rule__c();
        wr2.RecordTypeId=retrieveRecordTypeId('Field Service - Match Boolean','FSL__Work_Rule__c');
        wr2.Name = 'Capacity Exceeded';
        wr2.FSL__Resource_Property__c = 'Capacity_Exceeded__c';
        wr2.FSL__Match_Constant_Boolean_Value__c = false;
        wr2.FSL__Active__c = true;
        wr2.FSL__Match_Skill_Level__c = true;
        workRuleList.add(wr2);
        
        
        
        //*********************************
        // These are created by default
        // ********************************
        // Due Date
        /*FSL__Work_Rule__c wr3 = new FSL__Work_Rule__c();
        wr3.RecordTypeId=retrieveRecordTypeId('Field Service - Match Time Rule','FSL__Work_Rule__c');
        wr3.Name = 'Due Date';
        wr3.FSL__Service_Schedule_Time_Property__c = 'SchedEndTime';
        wr3.FSL__Service_Time_Operator__c = 'Before or Equal to';
        wr3.FSL__Service_Time_Property__c = 'DueDate';
        wr3.FSL__Pass_Empty_Values__c = true;
        workRuleList.add(wr3);
        
        //Earliest Start Permitted
        FSL__Work_Rule__c wr4 = new FSL__Work_Rule__c();
        wr4.RecordTypeId=retrieveRecordTypeId('Field Service - Match Time Rule','FSL__Work_Rule__c');
        wr4.Name = 'Earliest Start Permitted';
        wr3.FSL__Service_Schedule_Time_Property__c = 'SchedStartTime';
        wr3.FSL__Service_Time_Operator__c = 'Later than or Equal to';
        wr3.FSL__Service_Time_Property__c = 'EarliestStartTime';
        wr3.FSL__Pass_Empty_Values__c = true;
        workRuleList.add(wr4);*/
        
        //Match Skills
        FSL__Work_Rule__c wr5 = new FSL__Work_Rule__c();
        wr5.Name = 'Match Skills';
        wr5.RecordTypeId=retrieveRecordTypeId('Field Service - Match Skills','FSL__Work_Rule__c');
        wr5.FSL__Match_Skill_Level__c = false;
        wr5.FSL__Active__c = true;
        workRuleList.add(wr5);
        
        //Match Territory
        FSL__Work_Rule__c wr6 = new FSL__Work_Rule__c();
        wr6.RecordTypeId=retrieveRecordTypeId('Field Service - Match Territory','FSL__Work_Rule__c');
        wr6.Name = 'Match Territory';
        workRuleList.add(wr6);
        
        //Max Travel from Home
        FSL__Work_Rule__c wr7 = new FSL__Work_Rule__c();
        wr7.Name = 'Max Travel from Home';
        wr7.FSL__Maximum_Travel_From_Home_Type__c = 'Distance';
        wr7.RecordTypeId = retrieveRecordTypeId('Field Service - Maximum Travel From Home','FSL__Work_Rule__c');
        wr7.FSL__Active__c = true;
        wr7.FSL__Maximum_Travel_From_Home__c = 60.00;
        workRuleList.add(wr7);
        
        //Rectification
        FSL__Work_Rule__c wr8 = new FSL__Work_Rule__c();
        wr8.Name = 'Rectification';
        wr8.RecordTypeId = retrieveRecordTypeId('Field Service - Match Boolean','FSL__Work_Rule__c');
        wr8.FSL__Resource_Property__c = 'Rectification__c';
        wr8.FSL__Match_Constant_Boolean_Value__c = false;
        wr8.FSL__Active__c = true;
        wr8.FSL__Match_Skill_Level__c = true;
        workRuleList.add(wr8);
        
        //Resource Availability
        FSL__Work_Rule__c wr9 = new FSL__Work_Rule__c();
        wr9.Name = 'Resource Availability';
        wr9.RecordTypeId = retrieveRecordTypeId('Field Service - Service Resource Availability','FSL__Work_Rule__c');
        wr9.FSL__Travel_From_Home__c = 60;
        wr9.FSL__Travel_To_Home__c = 60;
        wr9.FSL__Is_Fixed_Gap__c = false;
        wr9.FSL__Minimum_Gap__c = 0;
        //wr9.FSL__Resource_Group_Field__c = 'All';
        
        workRuleList.add(wr9);
        
        //Service Appointment Visiting Hours
        FSL__Work_Rule__c wr10 = new FSL__Work_Rule__c();
        wr10.Name = 'Service Appointment Visiting Hours';
        wr10.RecordTypeId = retrieveRecordTypeId('Field Service - Service Appointment Visiting Hours','FSL__Work_Rule__c');
        workRuleList.add(wr10);
                
        insert workRuleList;
       	
        // Assign Work Rules to passed in Service Policy
        List<FSL__Scheduling_Policy_Work_Rule__c> schedPolicyWRList = new List<FSL__Scheduling_Policy_Work_Rule__c>();
        Integer i = 0;
        for (FSL__Work_Rule__c workRule : workRuleList) {
            i = i + 1;
            //System.Debug('Processing Policy Work Rule #' + i);
            FSL__Scheduling_Policy_Work_Rule__c sWR = new FSL__Scheduling_Policy_Work_Rule__c();
            sWR.FSL__Scheduling_Policy__c = schedPolicyId;
            sWR.FSL__Work_Rule__c = workRule.Id;
            schedPolicyWRList.add(sWR);
        }
        
        //System.Debug('Number of Work Rules In List for Scheduling Policy: ' + schedPolicyWRList.size());
        
        insert schedPolicyWRList;
        
        /*List<FSL__Scheduling_Policy_Work_Rule__c> polList = [SELECT Id, Name
                                                             FROM FSL__Scheduling_Policy_Work_Rule__c
                                                             WHERE FSL__Scheduling_Policy__c = :schedPolicyId];
        System.Debug('Number of Work Rules Inserted for Scheduling Policy: ' + polList.size());*/
        
    }
    
    /*************************************************
 	* Description: create Service Objectives (Customer First)
 	**************************************************/
	public static void createSchedulingPolicyObjectives(Id schedPolicyId) {
        List<FSL__Service_Goal__c> servObjList = new List<FSL__Service_Goal__c>();
        
        // ASAP
        FSL__Service_Goal__c srvObj1 = new FSL__Service_Goal__c();
        srvObj1.RecordTypeId=retrieveRecordTypeId('ASAP','FSL__Service_Goal__c');
        srvObj1.Name = 'ASAP';
        srvObj1.FSL__Prioritize_Resource__c = 'Least Qualified';
        //srvObj1.FSL__Resource_Group_Field__c = 'All';
        //srvObj1.FSL__Object_Group_Field__c = 'All';
        servObjList.add(srvObj1);
        
        // Minimize Travel
        FSL__Service_Goal__c srvObj2 = new FSL__Service_Goal__c();
        srvObj2.RecordTypeId=retrieveRecordTypeId('Minimize Travel','FSL__Service_Goal__c');
        srvObj2.Name = 'Minimize Travel';
        servObjList.add(srvObj2);
        
        // Preferred Service Resource
        FSL__Service_Goal__c srvObj3 = new FSL__Service_Goal__c();
        srvObj3.RecordTypeId=retrieveRecordTypeId('Preferred Resource','FSL__Service_Goal__c');
        srvObj3.Name = 'Preferred Service Resource';
        servObjList.add(srvObj3);
        
        //Skill Level
        FSL__Service_Goal__c srvObj4 = new FSL__Service_Goal__c();
        srvObj4.RecordTypeId=retrieveRecordTypeId('Skill Level' , 'FSL__Service_Goal__c');
        srvObj4.Name = 'Skill Level';
        srvObj4.FSL__Prioritize_Resource__c = 'Most Qualified';
        servObjList.add(srvObj4);
        
        insert servObjList;
        
        List<FSL__Scheduling_Policy_Goal__c> schedPolObjList = new List<FSL__Scheduling_Policy_Goal__c>();
        for(FSL__Service_Goal__c serviceGoal : servObjList){
            
            FSL__Scheduling_Policy_Goal__c SchedPolObj = new FSL__Scheduling_Policy_Goal__c();
            SchedPolObj.FSL__Scheduling_Policy__c =  schedPolicyId;
            SchedPolObj.FSL__Service_Goal__c = serviceGoal.Id;
            
            if(serviceGoal.Name == 'Preferred Service Resource'){
                SchedPolObj.FSL__Weight__c = 10;
            }
            else{
                SchedPolObj.FSL__Weight__c = 30;
            }
            
            schedPolObjList.add(SchedPolObj);
        }
        
        insert schedPolObjList;
        
    }
    
    
    /*************************************************
 	* Description: create Service Resource Account
 	**************************************************/
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
        testAccount.RecordTypeId = retrieveRecordTypeId('Trade Account', 'Account');
        
        insert testAccount;
        System.debug('Account Owner:'+testAccount.Owner.Name);
        return testAccount;
   }
    /*************************************************
 	* Description: create Service Resource Account
 	**************************************************/
    public static Account createServiceResource(String AccountName, List<String> ServiceAreas){ 
    //create service resource Account relatable to work order
        Account testAccount = new Account();
        //business details
        
        testAccount.Name = AccountName;
        testAccount.ABN__c = '1234';
        testAccount.ABN_Status__c = 'Active';
        testAccount.GST_Status__c = 'Active';
        testAccount.Phone = '0404040404';
        testAccount.When_did_your_business_commence_trading__c = date.newInstance(2011,11,11);
        testAccount.Business_Structure__c = 'sample structure';
        testAccount.RCTI__c = true;
        //business work type
        testAccount.Work_Type__c = 'CabinetMaker';
        //testAccount.Service_Areas__c = 'VIC';
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
        testAccount.RecordTypeId = retrieveRecordTypeId('Trade Account', 'Account');
        
        
        
        String ServiceAreaValues = String.join(ServiceAreas, ';');
        system.debug('Service Areas: ' + ServiceAreaValues);
        testAccount.Service_Areas__c = ServiceAreaValues;
        
        insert testAccount;
        return testAccount;
   }
    /*************************************************
 	* Description: create Trade Compliance
 	**************************************************/
    public static Trade_Type__c createTradeCompliance(Id AccountId, Id WorkTypeId){
        Trade_Type__c newCompliance = new Trade_Type__c();
        
        newCompliance.Account__c = AccountId;
        newCompliance.Work_Type__c = WorkTypeId;
        newCompliance.Status__c = 'Approved';
        
        
        insert newCompliance;
        return newCompliance;
    }
    /*************************************************
 	* Description: create Service Resource isCapacityBased = false
 	**************************************************/
    public static ServiceResource createNewServiceResource (){
        ServiceResource SR = new ServiceResource();
        SR.Name = 'Bonjisto';
        /*User u = createFSLUser();
        SR.RelatedRecordId = u.Id;*/
        SR.IsActive = true;
        SR.IsCapacityBased = false;
        SR.ResourceType = 'T';		// Technician
        insert SR;
        return SR;        
    }
    /*************************************************
 	* Description: create Service Resource isCapacityBased = false
 	**************************************************/
    public static ServiceResource createNewServiceResource (Id userId){
        ServiceResource SR = new ServiceResource();
        SR.Name = 'Bonjisto';
        /*User u = createFSLUser();
        SR.RelatedRecordId = u.Id;*/
        
        SR.RelatedRecordId = userId;
        SR.IsActive = true;
        SR.IsCapacityBased = false;
        SR.ResourceType = 'T';		// Technician
        insert SR;
        return SR;        
    }
    
    /*************************************************
 	* Description: create Service Resource isCapacityBased = true
 	**************************************************/
    public static ServiceResource createNewCapacityServiceResource (){
        ServiceResource SR = new ServiceResource();
        SR.Name = 'Bonjisto';
        /*User u = createFSLUser();
        SR.RelatedRecordId = u.Id;*/
        SR.IsActive = true;
        SR.IsCapacityBased = true;
        SR.ResourceType = 'T';		// Technician
        insert SR;
        return SR;        
    }
    /*************************************************
 	* Description: create Operating Hours
 	**************************************************/
    public static OperatingHours createOperatingHours(String name) {
        OperatingHours newOpHours = new OperatingHours();
        newOpHours.Name = name;
        newOpHours.TimeZone = UserInfo.getTimeZone().toString();
        insert newOpHours;
        return newOpHours;
        
    }
    
    /*************************************************
 	* Description: create Time Slot
 	**************************************************/
    public static TimeSlot createTimeSlot(String dayOfWeek, Integer startHour, Integer endHour, String slotType,
                                   Id operatingHoursId) {
        
        TimeSlot newSlot = new TimeSlot();
        newSlot.OperatingHoursId = operatingHoursId;
        newSlot.DayOfWeek = dayOfWeek;
        newSlot.Type = slotType;
        newSlot.StartTime = Time.newInstance(startHour, 0, 0, 0);
        newSlot.EndTime = Time.newInstance(endHour, 0, 0, 0);
        
        insert newSlot;
        return newSlot;
    }    
    
    
    
    
    /*************************************************
 	* Description: create Service Territory
 	**************************************************/
    public static ServiceTerritory createServiceTerritory(String name, Id operatingHoursId,
                                                         String streetAddress,
                                                         String city,
                                                         String state,
                                                         String postCode,
                                                         String country) {
        ServiceTerritory newTerritory = new ServiceTerritory();
        newTerritory.Name = name;
        newTerritory.OperatingHoursId = operatingHoursId;
        newTerritory.Street = streetAddress;
        newTerritory.City = city;
        newTerritory.State = state;
        newTerritory.PostalCode = postCode;
        newTerritory.Country = country;
        newTerritory.IsActive = true;
        
        insert newTerritory;
        return newTerritory;
    }
    
    /*************************************************
 	* Description: create Service Territory Membership
 	**************************************************/
    public static ServiceTerritoryMember createServiceTerritoryMember(Id serviceResourceId, Id serviceTerritoryId,
                                                                     Id operatingHoursId) {
        ServiceTerritoryMember newMember = new ServiceTerritoryMember();
        newMember.ServiceResourceId = serviceResourceId;
        newMember.ServiceTerritoryId = serviceTerritoryId;
        newMember.OperatingHoursId = operatingHoursId;
        // P = Primary
        // S = Secondary
        // R = Relocation
        newMember.TerritoryType = 'P';
        newMember.EffectiveStartDate = DateTime.now() - 5; 
                                                                         
        insert newMember;
        return newMember;
    }
    
    
    
    
    
    //helper methods
	private static string retrieveRecordTypeId(String RecordTypeName,String ObjectName){
        string devRecordTypeId = Schema.getGlobalDescribe().get(ObjectName).getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        return devRecordTypeId;
    }
    
    public static string retrieveWorkTypeId(String WorkTypeName){
        system.debug('WorkTypeName: ' + WorkTypeName);
        
        WorkType foundType = [SELECT Id, Name
                              FROM WorkType
                              WHERE Id = :WorkTypeName
                              LIMIT 1];
        system.debug('foundType: ' + foundType);
        
        
        String foundId = foundType.Id;
        return foundId;
        
        
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
	public static string createClaimJob(string caseId){
        Claim_Job__c testClaimJob = new Claim_Job__c();
        testClaimJob.Claim__c = caseId;
        testClaimJob.Job_Type__c = 'doAndCharge';
        insert testClaimJob;
        String returnID = testClaimJob.id;
        return returnID;
     }
	public static Contact createContact() {
       Contact con=new Contact();
       con.LastName='The Fonz';
       con.Phone='0265874111';
       con.MobilePhone='0465874111';
       insert con;
       return con;
    }
    /***********
     * Description: create contact and associate with account
     * ********/
    public static Contact createContact(Id AccountId) {
       Contact con=new Contact();
       con.AccountId = AccountId;
       con.LastName='The Fonz';
       con.Phone='0265874111';
       con.MobilePhone='0465874111';
       insert con;
       return con;
    }
    @future(callout=false)
    public static void createFSLUser() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];        
        UserRole role = [SELECT Id FROM UserRole WHERE name = 'SVP Customer Experience'];
        
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
                           isActive = true);
        
       
        system.debug('user: ' + usr);
        insert usr;
        usr.UserRoleId = role.Id;
        update usr;    
        //return usr;
        
    }
    @future(callout=false)
    public static void createFSLUser(Id ContactId) {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Trade Platfrom Community Plus User' LIMIT 1];        
        system.debug('profile: ' + profile);
        UserRole role = [SELECT Id FROM UserRole WHERE name = 'SVP Customer Experience'];
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
                           ContactId = ContactId
                           /*UserRoleId = role.Id*/);
        
       
        system.debug('***userContactId: ' + usr.ContactId);
        insert usr;
      
        //return usr;
        
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
	@future (callout=false)
    public static void createUserWithPermissions(boolean permSets){
        //user creation logic
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];        
        UserRole role = [SELECT Id FROM UserRole WHERE name = 'SVP Customer Experience'];
        
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
                           isActive = true);
        
       
        system.debug('user: ' + usr);
        insert usr;
        usr.UserRoleId = role.Id;
        update usr;    
        //return usr;
        
        if(permSets){
            System.Debug('Assigning FSL Resource Permissions...');
            PermissionSet p = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions' LIMIT 1];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = usr.Id;
            psa.PermissionSetId = p.Id;
            insert psa;
            
            System.Debug('FSL Resource Permissions Assignment: ' + psa);
            
            System.Debug('Assigning FSL Resource License Permissions...');
            PermissionSet p1 = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_License' LIMIT 1];
            PermissionSetAssignment psa1 = new PermissionSetAssignment();
            psa1.AssigneeId = usr.Id;
            psa1.PermissionSetId = p1.Id;
            insert psa1;
            
            System.Debug('FSL Resource License Permissions Assignment: ' + psa1);
        }
    }    
}