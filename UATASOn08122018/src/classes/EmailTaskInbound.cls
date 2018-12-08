public class EmailTaskInbound implements Messaging.InboundEmailHandler{
    public Messaging.InboundEmailResult handleInboundEmail
        (Messaging.inboundEmail email,Messaging.InboundEnvelope envelope){
            Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
            
            system.debug('Subject'+email.subject);
            system.debug('Subject'+email.plainTextBody);
            
            List<EmailMessage> emailMessageList = [SELECT Id, TextBody,ToAddress FROM EmailMessage where ToAddress =: email.fromAddress and createdDate >:Datetime.now().addMinutes(-30)];
            if(emailMessageList.size() > 0){
                result.success = true;
            }else{
                List<Case> caseList = [SELECT Id, CaseNumber FROM Case WHERE CaseNumber = :email.subject
                                       or Claim_Number_No_Leading_Zeros__c = :email.subject
                                       or claim_number__c = :email.subject LIMIT 1]; 
                system.debug('caseList: ' + caseList);
                if(caseList.size() > 0){
                    return result=createTaskAndAttachment(email,caseList[0].Id);
                }
                if(caseList.size()==0){  
                    if (email.subject.toLowerCase().contains('case #')){
                        if(extractCaseThreadRef(email.subject) != null){
                            System.debug('CaseNumber: '+ extractCaseThreadRef(email.subject));
                            caseList = [SELECT Id, CaseNumber FROM Case WHERE CaseNumber = :extractCaseThreadRef(email.subject)
                                        or Claim_Number_No_Leading_Zeros__c = :extractCaseThreadRef(email.subject)
                                        or claim_number__c = :extractCaseThreadRef(email.subject) LIMIT 1];
                            if(caseList.size() > 0){  
                                result=createTaskAndAttachment(email,caseList[0].Id); 
                            }else{
                                result.success = true;
                                sentEmailToCase(email);
                            }
                            
                        }else{
                            result.success = true;
                            sentEmailToCase(email);
                        }
                        
                    }else{
                        result.success = true;
                        sentEmailToCase(email);
                    }
                }else{
                    result.success = true;
                    sentEmailToCase(email);
                }
            }
            return result;                                                             
        }
    private void sentEmailToCase(Messaging.inboundEmail emailCase){
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName='HomeRepair Customer Suppport'];
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<String> toAddresses = new List<String>(); 
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            email.setOrgWideEmailAddressId(owea.get(0).Id);
        }  
        toAddresses.add(emailCase.fromAddress);
        email.subject = 'We are unable to locate your claim details in our system';
        email.plainTextBody = 'Oops! We are unable to locate your details in our system. Please check if you have entered valid claim number in subject';          
        email.setToAddresses(toAddresses);
        emailList.add(email);
        if(emailList.size() > 0){
            if(!Test.isRunningTest()){ 
                Messaging.sendEmail(emailList);
            }
        } 
    }
    private Messaging.InboundEmailResult createTaskAndAttachment(Messaging.inboundEmail email,String caseId){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        EmailMessage incomingEmail = new EmailMessage();
        incomingEmail.ParentId = caseId;
        incomingEmail.FromAddress = email.fromAddress;
        incomingEmail.Subject = email.subject;
        incomingEmail.HtmlBody = email.htmlBody;
        incomingEmail.FromName = email.fromName;
        incomingEmail.Status = '0';
        incomingEmail.ToAddress = email.toAddresses[0];        
        incomingEmail.Incoming = true;
        
        try{
            Insert incomingEmail;
        } catch(Exception e){
            String errorMessage = e.getMessage();
            result.message = errorMessage;
            result.success = false;            
        }
        
        List<HomeRepairUtil.contentWrapper> attachmentList = new List<HomeRepairUtil.contentWrapper> ();
        
        if(email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
            for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                HomeRepairUtil.contentWrapper att = new HomeRepairUtil.contentWrapper(
                    EncodingUtil.base64Encode(email.binaryAttachments[i].body),
                    email.binaryAttachments[i].filename,null);   
                attachmentList.add(att);                     
            }
        }
        
        if(email.textAttachments != null){
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                HomeRepairUtil.contentWrapper att = new HomeRepairUtil.contentWrapper(
                    tAttachment.body,
                    tAttachment.fileName,null);   
                attachmentList.add(att);   
            }
        }
        
        if(!attachmentList.isEmpty()){
            HomeRepairUtil.doUploadContent(incomingEmail.Id, attachmentList);
        }
        // New Task object to be created
        Task[] newTask = new Task[0];
        try{
            // Add a new Task to the case record we just found above.
            
            List<User> userList=[Select Id,Name,Email 
                                 FROM User
                                 WHERE Name = 'HR Claims'
                                 Limit 1];
            
            newTask.add(new Task(Description =  email.plainTextBody,
                                 priority = 'Low',
                                 status = 'Not Started',
                                 subject = 'Review Correspondence',
                                 IsReminderSet = true,
                                 Type = 'Email',
                                 OwnerId = userList[0].id,
                                 ActivityDate=System.Today()+1,
                                 ReminderDateTime = System.now()+1,
                                 WhatId =  caseId));
            
            // Insert the new Task 
            insert newTask; 
            result.success = true;
        } catch(Exception e){
            String errorMessage = e.getMessage();
            result.message = errorMessage;
            result.success = false;            
        }
        
        
        return result;
    }
    private String extractCaseThreadRef(String emailSubject){
        String target = emailSubject.toLowerCase();
        String caseRef = target.substringAfter('case #');
        system.debug('caseRef: ' + caseRef); 
        return caseRef; 
    }
}