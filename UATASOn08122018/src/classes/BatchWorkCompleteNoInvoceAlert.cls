/*Purpose: Batch job is to send email to the contact email-id on Work order, if there 
the work order status is 'Work Complete' but no Invoice file is uploaded.  ones.
History                                                             
--------                                                            
VERSION        AUTHOR          DATE           DETAIL       Description 
1.0            Chandra Kemoji 19/Nov/2018      Created      Home Repair Claim System 
*/
global class BatchWorkCompleteNoInvoceAlert implements Database.Batchable<sObject> {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Date tempDate = date.today().adddays(-5);
        system.debug('date ' + tempdate);
        String query;
        If (test.isRunningTest()){
            query = 'select workOrderNumber,work_Completed_Date__c, Service_Resource_Company__r.Accounts_Email_Address__c, Service_Resource_Company__r.Name, caseID from workOrder where status = \'Job Complete\'';
        }else{   
            query = 'select workOrderNumber,work_Completed_Date__c, Service_Resource_Company__r.Accounts_Email_Address__c, Service_Resource_Company__r.Name, caseID from workOrder where status = \'Job Complete\' and work_Completed_Date__c <= :tempDate' ;
        }
        system.debug('query: '+ query);
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<workOrder> scope) {
        system.debug('Scope List: '+scope);
        List<Task> TaskList = new List<Task>();
        List<workOrder> woContEmailList = new List<workOrder>();
        set<string> woIDSet    = new set<string>();
        map<String, string> taskMap = new map<String, string>();
        
        for(workOrder wONum : scope){
            woIDSet.add(wOnum.caseID);
        }
        string s2;
        
        for(Task tL1 : [select subject from task where (subject like'%Invoice%') and (subject like '%Work Order%') and whatID in :woIDSet]){
            s2 = tL1.subject.substringAfterLast('Work Order');
            s2 = (s2.deleteWhitespace());
            taskMap.put(s2,s2);
        }
        
        for(workOrder woNum : scope){  
            if(!taskMap.containsKey(woNUM.workOrderNumber))
                woContEmailList.add(wONum);
        }
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'trades@homerepair.com.au'];
        
        
        if(woContEmailList.size() > 0)
        {
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            for(workOrder s : woContEmailList){
                if(s.Service_Resource_Company__r.Accounts_Email_Address__c != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {s.Service_Resource_Company__r.Accounts_Email_Address__c};
                        String[] tradeName = new String[] {s.Service_Resource_Company__r.Name};
                            String[] sworkOrderNumber = new String[] {s.workOrderNumber};
                                
                                if ( owea.size() > 0 ) {
                                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                }
                    mail.setToAddresses(toAddresses);
                    String subject='Work Order'+ sworkOrderNumber + ' Completed but Invoice is not uploaded';
                    String body = 'Hi ' + s.Service_Resource_Company__r.Name + ',' + '<br/>'+'<br/>' +
                        'We haven’t received your invoice in 5 business days from Job Completion.' + '<br/>' +
                        'Please enter your Invoice details in you Trade Portal as soon as possible.' + '<br/>' + '<br/>' +
                        'Thank you,' + '<br/>' +
                        'HomeRepair';
                    mail.setHtmlBody(body); 
                    mail.setSubject(subject);
                    allMails.add(mail);
                }
            }
            if(allMails.size() > 0)
                Messaging.sendEmail(allMails); 
        }
        
    }
    
    global void finish(Database.BatchableContext bc){ 
        
    }
    
}