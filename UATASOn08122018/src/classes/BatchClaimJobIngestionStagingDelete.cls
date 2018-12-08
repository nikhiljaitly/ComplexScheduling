global class BatchClaimJobIngestionStagingDelete implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        DateTime lastDate = System.now().addDays(-30);
        return Database.getQueryLocator
            ([Select id from Claim_Job_Ingestion_Staging__c where LastModifiedDate <= :LastDate and Process_Status__c = 'Completed' LIMIT 2]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Claim_Job_Ingestion_Staging__c>scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, TotalJobItems, CreatedBy.Email,CreatedDate from AsyncApexJob where Id =:BC.getJobId()];
        System.debug('Claim Ingestion Staging Delete Job status ' + a.Status);
        System.debug('Start Time: '+a.CreatedDate+ ' and Completed : '+ system.now() +' records delete ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.');
        String subject = 'Batch claim job ingestion Staging delete';
        String plainTextBody = '';
        plainTextBody += 'Job start Time: '+ a.CreatedDate + '\n';
        plainTextBody += 'Job end Time: '+ system.now() + '\n';
        plainTextBody += 'No of errors: ' + a.NumberOfErrors + '\n';
        jobStatusEmailAlert(subject,plainTextBody);
    }
    
    private void jobStatusEmailAlert(string subject,string body){
        GeneralSettings__c gs = GeneralSettings__c.getValues('ITSupportEmail');
        if(gs.Value__c != ''){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {gs.Value__c};
                mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}