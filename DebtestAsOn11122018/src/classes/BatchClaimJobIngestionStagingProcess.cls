/***************************************************************** 
Purpose: Batch job to process instance of a Claim Job staging object into the resulting 
Claims (Cases)and Claim Jobs, Claim Job Work Items and update any existing ones.
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          20/02/2018      Created      Home Repair Claim System  
*******************************************************************/
global class BatchClaimJobIngestionStagingProcess implements Database.Batchable<sObject> {
    
/***************************************************************** 
Purpose: Batch start method to fetch records from Claim Job Ingestion 
Staging with status Pending.
Parameters:None
Returns: Query 
Throws [Exceptions]: None                                                          
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String status = 'Pending';
        String claimId='a0gN0000009cPwQ';
        String query = 'Select AuthorisedAmount__c,Asbestos_Present__c,DateIssued__c,Brand__c,ClaimNumber__c,Construction_Type__c,' +
            'ClaimType__c,Claim_Description__c,DateReceived__c,DateRespondBy__c,Excess__c,HomeAge__c,Id,Insured__c,' +
            'InternalReferenceId__c,JobNumber__c,JobSubType__c,JobType__c,Job_Description__c,LossDate__c,LossCause__c,' +
            'Name,Mould_Present__c,OccupancyType__c,OwnerId,Policy_Number__c,PrimaryContactEmailAddress__c,PrimaryContactHomePhone__c,' +
            'PrimaryContactMobilePhone__c,PrimaryContactRelationshipToInsured__c,PrimaryContactWorkPhone__c,PrimaryContact__c,' +
            'RiskAddressLine1__c,RiskAddressLine2__c,RiskAddressLine3__c,RiskAddressPostcode__c,RiskAddressState__c,' +
            'RiskAddressSuburb__c,RoofType__c,Building_under_construction__c,StatusUpdateDate__c,Status__c,Storeys__c,SpecialInstructions__c,' +
            'VendorReferenceNumber__c ,HomeAssist__c, (select id,Age__c, Category__c, Work_Item_Type__c,Description__c, Item__c, Item_Location__c,'+
            'Make_Model__c, Number_Of_Items__c, Quantity__c, Quote_Amount__c,'+ 
            'Source_Internal_Reference_Id__c, Special_Instructions__c, Unit__c,'+ 
            'Job_Number__c from Claim_Job_Work_Items_Staging__r) FROM Claim_Job_Ingestion_Staging__c Where Process_Status__c =:status';
        system.debug('query '+query);
        return Database.getQueryLocator(query);
    }
/***************************************************************** 
Purpose: Batch execute method to process Claim Job Ingestion from Start method result
Parameters:List<Claim_Job_Ingestion_Staging__c>
Returns: none
Throws [Exceptions]: DML                                                          
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/   
    global void execute(Database.BatchableContext BC, List<Claim_Job_Ingestion_Staging__c> scope) {
        system.debug('Entering List of Claim_Job_Ingestion_Staging__c: '+scope);
        //delcare variables
        List<Policy__c> policyList = new List<Policy__c>();
        List<Case> caseList = new List<Case>();
        List<Contact> contactList = new List<Contact>();
        List<Account> accountList = new List<Account>();
        List<Claim_Job__c> claimJobList = new List<Claim_Job__c>();
        List<Claim_Job_Work_Item__c> claimJobWorkItemList = new List<Claim_Job_Work_Item__c>();
        
        Set<String> NameSet = new Set<String>();
        Set<String> policyNumberSet = new Set<String>();
        Set<String> claimJobStagingSet = new Set<String>();
        
        //Contact
        Map<string, Contact> contactMap = new Map<string, Contact>();
        //Existing Account
        Map<string, Account> existingAccountMap = new Map<string, Account>();
        //Brand
        Map<string, Account> brandMap = new Map<string, Account>();
        //Account
        Map<string, Account> accountMap = new Map<string, Account>();
        
        Set<Account> upsertAccountSet = new Set<Account>();
        
        Set<Contact> upsertContactSet = new Set<Contact>();
        Map<string, Policy__c> policyMap = new Map<string, Policy__c>();
        
        for (Claim_Job_Ingestion_Staging__c cjis : scope) {
            policyNumberSet.add(cjis.Policy_Number__c);
            NameSet.add(cjis.PrimaryContact__c);
            claimJobStagingSet.add(cjis.JobNumber__c);
            if(cjis.Claim_Job_Work_Items_Staging__r.size() > 0){
                for(Claim_Job_Work_Items_Staging__c cjwi : cjis.Claim_Job_Work_Items_Staging__r){
                    claimJobWorkItemList.add(createClaimJobWorkItem(cjwi));
                }                
            }
        }
        
        for (Contact con : [Select id, Name, AccountId, Policy_Number__c from Contact where Name IN : NameSet and Policy_Number__c IN : policyNumberSet]) {
            contactMap.put(con.Policy_Number__c + con.Name, con);
        }
        
        for (Account acct : [Select id, Name from Account where  recordtype.name  = 'Insurance Provider']) {
            brandMap.put(acct.name.toLowerCase(), acct);
        }
        for (Account acct : [Select id, Name,Policy_Number__c from Account where Name IN : NameSet and Policy_Number__c IN : policyNumberSet]) {
            existingAccountMap.put(acct.Policy_Number__c + acct.Name, acct);
        }
        
        for (Claim_Job_Ingestion_Staging__c cjis : scope) {
            accountList.add(createPersonAccount(cjis,existingAccountMap));
        }
        
        system.debug('Before Inserted Account List after '+ accountList);
        if (accountList.size() > 0) {
            upsertAccountSet.addAll(accountList);
            system.debug('upsertAccountSet'+upsertAccountSet);
            Map<Id,Account> upsertAccountMap = new Map<Id,Account>();
            accountList = new List<Account>();
                        
            for(Account acc : upsertAccountSet){
                if(acc.Id == null){
                    accountList.add(acc);
                }else{
                    upsertAccountMap.put(acc.Id,acc);
                }
            }
            for(Account acc : upsertAccountMap.values()){
                accountList.add(acc);
            }
            Set<Id> upsertAcctIds = new Set<Id>();
            system.debug('accountList'+accountList);
            try {
                List<Database.upsertResult> accountResults = Database.Upsert(accountList, false);
                //Iterate through each returned result
                system.debug('After Inserted Account List after '+ accountResults);
                for (Database.upsertResult sr : accountResults) {
                    system.debug('sr'+sr);
                    if (sr.isSuccess()) {
                        upsertAcctIds.add(sr.getId());
                    }
                }
                for (Account acct : [select id, Policy_Number__c, Name from account where Id IN : upsertAcctIds]) {
                    accountMap.put(acct.Policy_Number__c + acct.Name, acct);
                }
            } catch(DMLException e) {
                failureEmailAlert('Account',e.getMessage());
                system.debug('Error upserting Account - ' + e.getMessage());
            }                      
        }
        
        for (Claim_Job_Ingestion_Staging__c cjis : scope) {
            contactList.add(createContact(cjis, contactMap, accountMap));
        }        
        if (contactList.size() > 0) {
            Set<Id> upsertConIds = new Set<Id>();
            Map<Id,Contact> upsertUniqueMap = new Map<Id,Contact>();
            upsertContactSet.addAll(contactList);
            
            contactList = new List<Contact>();
            for(Contact con : upsertContactSet){
                if(con.Id == null){
                    contactList.add(con);
                }else{
                    upsertUniqueMap.put(con.Id,con);
                }
            }
            for(Contact con : upsertUniqueMap.values()){
                contactList.add(con);
            }
            system.debug('Before Inserted Contact List after '+ contactList);            
            try {
                List<Database.upsertResult> contactResults = Database.Upsert(contactList, false);
                system.debug('After Inserted Contact List after '+ contactResults);
                for (Database.upsertResult sr : contactResults) {
                    if (sr.isSuccess()) {
                        upsertConIds.add(sr.getId());
                    }
                }
                for (Contact con : [select id, Name, Policy_Number__c from contact where Id IN : upsertConIds]) {
                    contactMap.put(con.Policy_Number__c + con.Name, con);
                }
            } catch(DMLException e) {
                failureEmailAlert('Contact',e.getMessage());
                system.debug('Error upserting Contacts - ' + e.getMessage());
            }           
        }
        set<string> policySet = new set<string>();
        set<string> claimSet = new set<string>();
        for (Claim_Job_Ingestion_Staging__c cjis : scope) {
            If(!policySet.contains(cjis.Policy_Number__c)) {
                policyList.add(createPolicy(cjis));
                policySet.add(cjis.Policy_Number__c);
            }
            If(!claimSet.contains(cjis.ClaimNumber__c)) {
                caseList.add(createCase(cjis, contactMap,brandMap));
                claimSet.add(cjis.ClaimNumber__c);
            }
            cjis.Process_Status__c = 'completed';
        }
        system.debug('Before Inserted Policy List after '+ policyList);
        try{
            List<Database.upsertResult> policyResults  = Database.upsert(policyList, Policy__c.Policy_Number__c, false);
            system.debug('After Inserted Policy List after '+ policyResults);
        }catch(DMLException e) {
            failureEmailAlert('Policy',e.getMessage());
            system.debug('Error inserting Policy - ' + e.getMessage());
        }
        system.debug('Before Upsert Case List after '+ caseList);
        try{
            //Schema.SObjectField polNumber = Policy__c.Fields.Policy_Number__c;
            List<Database.upsertResult> caseResults = Database.upsert(caseList, Case.Claim_Number__c, false);
               // Iterate through each returned result
                    for (Database.upsertResult upr : caseResults) {
                        if (!upr.isSuccess()) {
                            // Operation failed, so get all errors                
                            for(Database.Error err : upr.getErrors()) {
                                System.debug('The following error has occurred.');   
                                system.debug('Id: '+upr.getId());
                                System.debug('Error: ' + err.getMessage());
                                System.debug('Fields that affected this error: ' + err.getFields());
                            }
                        }
                    }    
            system.debug('Inserted Case List after '+ caseResults );
        }catch(DMLException e) {
            failureEmailAlert('Case',e.getMessage());
            system.debug('Error upserting Case - ' + e.getMessage());
        }            
        
        for(Claim_Job_Ingestion_Staging__c cjis : scope) {
            claimJobList.add(createClaimJob(cjis));
        }
        system.debug('Before Upsert Claim Job List after '+ claimJobList);        
        try{
            List<Database.upsertResult> claimJobResults = Database.upsert(claimJobList, Claim_Job__c.Source_Internal_Reference_Id__c, false);
            system.debug('After Inserted Claim Job List after '+ claimJobResults);
            Set<Id> claimJobIds=new Set<Id>();
            for (Database.upsertResult sr : claimJobResults) {
                if (sr.isSuccess()) {
                    claimJobIds.add(sr.getId());
                }
            }
            if(claimJobIds.size() > 0){
                system.debug('Before Inserted Claim Job Work Item List after '+ claimJobWorkItemList);
                try{
                    List<Database.upsertResult> claimJobWorkItemResults = Database.upsert(claimJobWorkItemList, Claim_Job_Work_Item__c.Source_Internal_Reference_Id__c,false);
                    system.debug('After Inserted Claim Job Work Item List after '+ claimJobWorkItemResults);
                }catch(DMLException e) {
                    system.debug('Error inserting Claim Job Work Item List after - ' + e.getMessage());
                }  
            }          
        }catch(DMLException e) {
            failureEmailAlert('Claim Job',e.getMessage());
            system.debug('Error upserting Claim Job - ' + e.getMessage());
        }
        system.debug('Exiting List of Claim_Job_Ingestion_Staging__c : '+ scope);
        update scope;
    }
/***************************************************************** 
Purpose: create Person Account from Claim Job Ingestion Staging
Parameters:Claim_Job_Ingestion_Staging__c and Map<string, Contact>
Returns: Account
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/   
    private Account createPersonAccount(Claim_Job_Ingestion_Staging__c cjis,Map<String,Account> existingAccountMap) {
        //Need to Enable Person Account on Org
        Account acct = new Account();
        if (existingAccountMap.containsKey(cjis.Policy_Number__c + cjis.PrimaryContact__c)) {
            acct.Id = existingAccountMap.get(cjis.Policy_Number__c + cjis.PrimaryContact__c).Id;
        }
        acct.RecordTypeId=retriveRecordTypeId('Policy Holder Account','Account');
        acct.type = 'Policy Holder Account';
        acct.Name = cjis.PrimaryContact__c;
        acct.Policy_Number__c = cjis.Policy_Number__c;
        return acct;
    }
/***************************************************************** 
Purpose: create Contact from Claim Job Ingestion Staging
Parameters:Claim_Job_Ingestion_Staging__c , Map<string, Account> and Map<string, Contact>
Returns: Contact
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/    
    private Contact createContact(Claim_Job_Ingestion_Staging__c cjis, Map<string, Contact> contactMap, Map<string, Account> accountMap) {
        //Fetch Claim Job Record
        contact con = new contact();
        system.debug('createContact : '+Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Policy Holder Contact').getRecordTypeId());
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Policy Holder Contact').getRecordTypeId();
        system.debug('createContactId : '+con.RecordTypeId);
        if (contactMap.containsKey(cjis.Policy_Number__c + cjis.PrimaryContact__c)) {
            con.Id = contactMap.get(cjis.Policy_Number__c + cjis.PrimaryContact__c).Id;
        }
        if (accountMap.containsKey(cjis.Policy_Number__c + cjis.PrimaryContact__c)) {
            con.AccountId = accountMap.get(cjis.Policy_Number__c + cjis.PrimaryContact__c).Id;
        }
        con.RelationshipToInsured__c = cjis.PrimaryContactRelationshipToInsured__c;
        con.RecordTypeId=retriveRecordTypeId('Policy Holder Contact','Contact');
        con.LastName = cjis.PrimaryContact__c;
        con.HomePhone = cjis.PrimaryContactHomePhone__c;
        con.Phone = cjis.PrimaryContactWorkPhone__c;
        con.Mobilephone = cjis.PrimaryContactMobilePhone__c;
        con.Email = cjis.PrimaryContactEmailAddress__c;
        con.Policy_Number__c = cjis.Policy_Number__c;
        return con;
    }
/***************************************************************** 
Purpose: create Policy from Claim Job Ingestion Staging
Parameters:Claim_Job_Ingestion_Staging__c
Returns: Policy
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/     
    private Policy__c createPolicy(Claim_Job_Ingestion_Staging__c cjis) {        
        //FetchPolicy Record
        Policy__c policy = new Policy__c();
        policy.AddressLine1__c = cjis.RiskAddressLine1__c;
        policy.AddressLine2__c = cjis.RiskAddressLine2__c;
        policy.AddressLine3__c = cjis.RiskAddressLine3__c;
        policy.Suburb__c = cjis.RiskAddressSuburb__c;
        policy.State__c = cjis.RiskAddressState__c;
        policy.Insured__c = cjis.Insured__c;
        policy.Postcode__c = cjis.RiskAddressPostcode__c;
        policy.Policy_Number__c = cjis.Policy_Number__c;
        policy.Occupancy_Type__c = cjis.OccupancyType__c;
        policy.Storeys__c = cjis.Storeys__c;
        policy.Roof_Type__c = cjis.RoofType__c;
        policy.Year_Built__c = cjis.HomeAge__c;
        policy.Excess__c = cjis.Excess__c;
        policy.Construction_Type__c = cjis.Construction_Type__c;
        policy.Building_under_construction__c = cjis.Building_under_construction__c;
        return policy;
    }
/***************************************************************** 
Purpose: create Case from Claim Job Ingestion Staging
Parameters:Claim_Job_Ingestion_Staging__c and Map<string, Contact>
Returns: Case
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/
    private Case createCase(Claim_Job_Ingestion_Staging__c cjis, Map<string, Contact> contactMap,Map<String,Account> brandMap) {
        //create instance of Case(Claim) Record
        Case cs = new Case();
        //associate claim with respective policy
        Policy__c pol = new Policy__c(Policy_Number__c = cjis.Policy_Number__c);
        cs.Policy__r = pol;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HR Case Feed').getRecordTypeId(); 
        system.debug('cjis.Brand__c '+cjis.Brand__c.toLowerCase()+'---'+cjis.Brand__c);
        
        if (brandMap.containsKey(cjis.Brand__c)){
             cs.Insurance_Provider__c = brandMap.get(cjis.Brand__c.toLowerCase()).Id;
        }
        
        if(contactMap.containsKey(cjis.Policy_Number__c + cjis.PrimaryContact__c)){
            cs.ContactId = contactMap.get(cjis.Policy_Number__c + cjis.PrimaryContact__c).Id;
        }
        cs.Status = 'New';
        cs.Origin = 'Suncorp';
        cs.Claim_Number__c = cjis.ClaimNumber__c.touppercase();
        cs.Description = cjis.Claim_Description__c;
        if(cjis.Claim_Description__c != null && cjis.Claim_Description__c.length() > 250){
            cs.Subject = cjis.Claim_Description__c.subString(0,250);
        }else{
            cs.Subject = cjis.Claim_Description__c;
        }
        
        cs.Loss_Date__c = cjis.LossDate__c;
        cs.Authorised_Amount__c=cjis.AuthorisedAmount__c;
        cs.Loss_Cause__c = cjis.LossCause__c;
        cs.Asbestos_Present__c = cjis.Asbestos_Present__c;
        cs.Mould_Present__c = cjis.Mould_Present__c;
        cs.StatusUpdateDate__c = cjis.StatusUpdateDate__c;
        return cs;
    }
/***************************************************************** 
Purpose: create Claim Job from Claim Job Ingestion Staging
Parameters:Claim_Job_Ingestion_Staging__c
Returns: Claim_Job__c
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/     
    private Claim_Job__c createClaimJob(Claim_Job_Ingestion_Staging__c cjis) {
        //Fetch Claim Job Record
        Claim_Job__c cj = new Claim_Job__c();
        cj.Job_Number__c = cjis.JobNumber__c;
        cj.Source_Internal_Reference_Id__c = cjis.InternalReferenceId__c;
        cj.Vendor_Reference_Number__c = cjis.VendorReferenceNumber__c;
        cj.Description__c=cjis.Job_Description__c;
        cj.Date_Issued__c = cjis.DateIssued__c;
        cj.Date_RespondBy__c = cjis.DateRespondBy__c;
        cj.Reported_Date__c = cjis.DateReceived__c;
        cj.Status__c=cjis.Status__c;
        cj.Special_Instructions__c = cjis.SpecialInstructions__c;
        cj.Claim_Type__c = cjis.ClaimType__c ;
        cj.Job_Type__c = cjis.JobSubType__c; 
        cj.Action_Type__c = cjis.JobType__c; 
        cj.HomeAssist__c = cjis.HomeAssist__c;
        Case cs = new Case(Claim_Number__c= cjis.ClaimNumber__c.touppercase());
        cj.Claim__r = cs;        
        return cj;
    }
/***************************************************************** 
Purpose: create Claim Job from Claim Job Work Items Staging
Parameters:Claim_Job_Work_Items_Staging__c
Returns: Claim_Job_Work_Item__c
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/      
    private Claim_Job_Work_Item__c createClaimJobWorkItem(Claim_Job_Work_Items_Staging__c cjwis){        
        Claim_Job_Work_Item__c cjwi=new Claim_Job_Work_Item__c();
        Claim_Job__c claimJob = new Claim_Job__c(Job_Number__c= cjwis.Job_Number__c);
        cjwi.Claim_Job__r=claimJob;                     
        cjwi.Age__c=cjwis.Age__c;
        cjwi.Category__c=cjwis.Category__c;
        cjwi.Description__c=cjwis.Description__c;
        cjwi.Item__c=cjwis.Item__c;
        cjwi.Item_Location__c=cjwis.Item_Location__c;
        cjwi.Make_Model__c=cjwis.Make_Model__c;
        cjwi.Number_Of_Items__c=cjwis.Number_Of_Items__c;
        cjwi.Quantity__c=cjwis.Quantity__c;
        cjwi.Quote_Amount__c=cjwis.Quote_Amount__c;
        cjwi.Source_Internal_Reference_Id__c=cjwis.Source_Internal_Reference_Id__c;
        cjwi.Special_Instructions__c=cjwis.Special_Instructions__c;
        cjwi.Unit__c=cjwis.Unit__c;
        cjwi.RecordTypeId=retriveRecordType(cjwis.Work_Item_Type__c);
        return cjwi;   
    }
/***************************************************************** 
Purpose: Fetch RecordTypeId for Claim_Job_Work_Item__c object from Developer Name
Parameters: String(Developer Name)
Returns: RecordTypeId
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/           
    private string retriveRecordType(string rType){
        system.debug('rType'+rType);
        return Schema.SObjectType.Claim_Job_Work_Item__c.getRecordTypeInfosByName().get(rType).getRecordTypeId();
    }
/***************************************************************** 
Purpose: Fetch RecordTypeId for Object from Developer Name
Parameters: String(Developer Name) with Object Name
Returns: RecordTypeId
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/  
    private static string retriveRecordTypeId(String RecordTypeName,String ObjectName){
        string devRecordTypeId = Schema.getGlobalDescribe().get(ObjectName).getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        return devRecordTypeId;
    }
/***************************************************************** 
Purpose: Batch finish method to Reschedule batch from ScheduledClaimIngestionStagingProcess Class
Parameters: Database.BatchableContext
Returns: none
Throws [Exceptions]: none
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
*******************************************************************/ 
    global void finish(Database.BatchableContext BC) {        
        /*for (CronTrigger job : [SELECT Id, NextFireTime FROM CronTrigger where CronJobDetail.Name like 'ClaimIngestionStagingProcess']) {
            system.abortJob(job.Id);
        }
        String str = system.now().addMinutes(2).format('ss mm HH dd MM ? yyyy');
        System.schedule('ClaimIngestionStagingProcess',  str, new ScheduledClaimIngestionStagingProcess());*/
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email,CreatedDate from AsyncApexJob where Id =:BC.getJobId()];
        System.debug('Claim Ingestion batch status ' + a.Status);
        System.debug('Start Time of Job is : '+a.CreatedDate+ ' and Completed Time of job is : '+ system.now() +' records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.');
   }
    private void failureEmailAlert(string objectName,string errorMsg){
        GeneralSettings__c gs = GeneralSettings__c.getValues('ITSupportEmail');
        if(gs.Value__c != ''){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {gs.Value__c};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch claim ingestion job failed');
            mail.setPlainTextBody('Error on Object : '+objectName+ ' and Error is : '+ errorMsg);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}