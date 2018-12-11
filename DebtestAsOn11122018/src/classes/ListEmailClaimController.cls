/***************************************************************** 
Purpose: Retreives Email Tempalte and Sent Custom Email with CC                                                         
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          02/08/2018      Created      Home Repair Claim System  
*******************************************************************/   
public class ListEmailClaimController {  
    /***************************************************************** 
    Purpose: getClaimContactsEmailList method to fetch User and Contact 
    Parameters: claimId (CaseId)
    Returns: emailUserListWrapper
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @AuraEnabled 
    public static list<emailUserListWrapper> getClaimContactsEmailList(string claimId){ 
        system.debug('Entering  getClaimContactsEmailList: ' + 'claim Id: ' + claimId);    
        list<emailUserListWrapper> userEmailList = new list<emailUserListWrapper>();    
        Set<String> conIds=new Set<String>();
        for (case c : [Select Contact.Id
                       From Case Where Id = :claimId]){
             conIds.add(c.Contact.Id);
        }        
        for(Contact c :[Select Id,Name,Phone,Email,Contact_Type__c From Contact Where Id IN: conIds]) {
            emailUserListWrapper eulw = new emailUserListWrapper(c.Id,
                                                             c.Name,
                                                             c.Email,
                                                             c.Phone,
                                                             c.Contact_Type__c);
           userEmailList.add(eulw);
        } 
        for(ServiceAppointment sa : [SELECT Id, Service_Resource__r.Contact__r.Id, Service_Resource__r.Contact__r.Name,
                                             Service_Resource__r.Contact__r.Email, Service_Resource__r.Contact__r.Phone, WorkType.Name,
                                             Service_Resource__c, Tier_2_Trade_Account__c, Tier_2_Trade_Account__r.Name,
                                             Tier_2_Trade_Account__r.Accounts_Email_Address__c, Tier_2_Trade_Account__r.Accounts_Phone__c
                                    FROM ServiceAppointment
                                    WHERE Claim__c = :claimId]) {
            emailUserListWrapper eulw = new emailUserListWrapper(sa.Service_Resource__r.Contact__r.Id, 
                                                                 sa.Service_Resource__c != null ? sa.Service_Resource__r.Contact__r.Name : sa.Tier_2_Trade_Account__r.Name,
                                                                 sa.Service_Resource__c != null ? sa.Service_Resource__r.Contact__r.Email : sa.Tier_2_Trade_Account__r.Accounts_Email_Address__c, 
                                                                 sa.Service_Resource__c != null ? sa.Service_Resource__r.Contact__r.Phone : sa.Tier_2_Trade_Account__r.Accounts_Phone__c,
                                                                 sa.WorkType.Name);
            userEmailList.add(eulw); 
        }
         /* for (All_Service_Appointments__c asa : [Select Service_Resource__r.Id,Service_Resource__r.Name,Service_Resource__r.Email,
                                                  Service_Resource__r.Phone,Work_Type__c
                                                From All_Service_Appointments__c Where Claim__c =:claimId
                                                and Service_Resource__c !=null]){
                                        
            emailUserListWrapper eulw = new emailUserListWrapper(asa.Service_Resource__r.Id,
                                         asa.Service_Resource__r.Name,
                                         asa.Service_Resource__r.Email,
                                         asa.Service_Resource__r.Phone,
                                         asa.Work_Type__c
                                         );
            userEmailList.add(eulw);
         }*/
        system.debug('Exiting  getClaimContactsEmailList: ' + 'emailUserListWrapper : ' + userEmailList);
        return userEmailList;
    }
    /***************************************************************** 
    Purpose: getClaimContacts method to fetch Contact 
    Parameters: claimId (CaseId)
    Returns: Contact
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @AuraEnabled 
    public static list<Contact> getClaimContacts(string claimId){  
        system.debug('Entering  getClaimContacts: ' + 'claim Id: ' + claimId);   
        list<Contact> conList = new list<Contact>();    
        Set<String> conIds=new Set<String>();
        for (case c : [Select Contact.Id
                       From Case Where Id = :claimId]){
             conIds.add(c.Contact.Id);
        }        
        for(Contact c :[Select id,Name,Phone,Email,Contact_Type__c From Contact Where Id IN: conIds]) {
            conList.add(c);
        }        
        system.debug('Exiting  getClaimContacts: ' + 'Contact : ' + conList);
        return conList;
    }
     
    /***************************************************************** 
    Purpose: getFiles method to fetch Content Version File 
    Parameters: recordId (CaseId or All_Service_AppointmentId)
    Returns: ContentVersion
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/ 
    @AuraEnabled 
    public static List<ContentVersion> getFiles(string recordId){
        system.debug('Entering  getFiles: ' + 'claim Id: ' + recordId);
        EmailTemplate emailTemp = new EmailTemplate();
        Set<String> objectIds=new Set<String>();
        objectIds.add(recordId);
        List<ContentDocumentLink> contents = [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersion.Title, 
               ContentDocument.LatestPublishedVersion.LastModifiedBy.Name, 
               ContentDocument.Description FROM ContentDocumentLink 
               where LinkedEntityId =: recordId];
        List<String> contentDocumentIds = new List<String>();
        for(ContentDocumentLink link: contents) {
            contentDocumentIds.add(link.ContentDocumentId);
        }
        List<ContentVersion> versions 
            = [SELECT Id, Title, FileType, VersionData, 
               isLatest, ContentDocumentId
               FROM ContentVersion
               WHERE isLatest = true AND ContentDocumentId IN :contentDocumentIds];
        system.debug('Exiting  getFiles: ' + 'ContentVersion : ' + versions);
        return versions;
    }
    /***************************************************************** 
    Purpose: getTemplateDetails method to fetch Template Detail 
    Parameters: templteId 
    Returns: EmailTemplate
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @AuraEnabled 
    public static EmailTemplate getTemplateDetails(string templteId){ 
        system.debug('Entering  getTemplateDetails : ' + 'Template Id: ' + templteId);       
        EmailTemplate emailTemp = new EmailTemplate();
        list<EmailTemplate> emailTempLst = new list<EmailTemplate>();
        emailTempLst = [SELECT Id,Name,Subject,TemplateType,body FROM EmailTemplate WHERE ID=: templteId];        
        emailTemp = emailTempLst.size()>0 ? emailTempLst[0] : emailTemp;
        system.debug('Exiting  getTemplateDetails : ' + 'EmailTemplate : ' + emailTemp);
        return emailTemp;        
    }
    /***************************************************************** 
    Purpose: getTemplates method to fetch Template from Claim Email Templates Folder
    Parameters: none
    Returns: EmailTemplate
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @AuraEnabled
    public static list<EmailTemplate> getTemplates(){
        system.debug('Entering  getTemplates');
        list<EmailTemplate> emailTemp = new list<EmailTemplate>();
        emailTemp = [SELECT Id,Name,Subject,TemplateType FROM EmailTemplate WHERE TemplateType IN ('custom','text') and Folder.Name ='Claim Email Templates'];
        system.debug('Exiting  getTemplates : ' + 'EmailTemplate : ' + emailTemp );
        return emailTemp;
    }
    /***************************************************************** 
    Purpose: getContentDocumentAsAttachement method to fetch ContentDocument and create Attachment
    Parameters: contentDocumentIds
    Returns: EmailFileAttachment
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    public static List<Messaging.EmailFileAttachment> getContentDocumentAsAttachement(String[] contentDocumentIds) {
        system.debug('Entering  getContentDocumentAsAttachement : ' + 'ContentDocument Id: ' + contentDocumentIds);
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>{};
            List<ContentVersion> documents= new List<ContentVersion>{};                
                documents.addAll([
                    SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId
                    FROM ContentVersion
                    WHERE isLatest = true AND ContentDocumentId IN :contentDocumentIds
                ]);
        
        for (ContentVersion document: documents) {
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();            
            attachment.setBody(document.VersionData);
            attachment.setFileName(document.Title + '.' + document.FileType);            
            attachments.add(attachment);
        }
        system.debug('Exiting  getContentDocumentAsAttachement  : ' + 'EmailFileAttachment : ' + attachments);
        return attachments;
    }
    /***************************************************************** 
    Purpose: postChatterToClaim method to PostChatter To Claim (Case)
    Parameters: claimId and UserId
    Returns: 
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    public static void postChatterToClaim(String claimId, List<String> idList) {
        system.debug('Entering  postChatterToClaim: ' + 'claim Id: ' + claimId + ' User Id :'+idList);
        List<Contact> contacts = [select Id, Name, Email from Contact where id in: idList];
        List<User> users = [select Id, Name, Email from User where id in: idList];
        String names = '';
        for(Contact record: contacts) {
            names = names + record.Name + '('+record.Email+') ,';
        }
        for(User record: users) {
            names = names + record.Name + '('+record.Email+') ,';
        }
        names = names.removeEnd(',');
        String message = 'Email Sent to ' + names ;
        if(!Test.isRunningTest()){
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), 
                                                                                     claimId, ConnectApi.FeedElementType.FeedItem, message);
            System.debug('feedElement' + feedElement);
        }
        system.debug('Exiting  postChatterToClaim : ');
    }
    /***************************************************************** 
    Purpose: generateEmails method to Generate and Send Mail
    Parameters: email,personId(ContactId),templateId,emailBody,subj(email subject),attachments(EmailFileAttachment),
                mails(SingleEmailMessage) and saveAsActivity
    Returns: List<Messaging.SingleEmailMessage>
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/  
    public static List<Messaging.SingleEmailMessage> generateEmails(String email,String personId,String recordId, 
            String templateId, String contentBody, String subj, List<Messaging.EmailFileAttachment> attachments,
            List<Messaging.SingleEmailMessage> mails , Boolean saveAsActivity) {            
            system.debug('Entering  generateEmails: ' + 'email :' + email + ' Contact Id :'+personId+ ' template Id :'+templateId+ ' contentBody :'+contentBody+ ' Email Subject :'+subj+' Attachment List :'+attachments+' Mail :'+mails+' saveAsActivity :'+saveAsActivity);
            OrgWideEmailAddress[] owea = [select Id, Address from OrgWideEmailAddress where DisplayName='HomeRepair Customer Suppport'];        
            List<Case> records = [select Id, Thread__c from Case where id=: recordId];
            if(records.isEmpty()){
                return mails;
            }
            String threadId = records.get(0).Thread__c; 
            if(email != null && email != ''){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                
                if(!owea.isEmpty()) {
                    mail.setOrgWideEmailAddressId( owea.get(0).Id);
                }
                
                if(string.isNotBlank(templateId)){
                    mail.setTemplateId(ID.valueOf(templateId));
                    mail.setTargetObjectId(personId);
                    mail.setWhatId(recordId);
                }
                if(string.isNotBlank(contentBody)){
                    mail.setSubject((string.isNotBlank(subj) ? subj : '') + threadId );
                    mail.setTargetObjectId(personId);
                    mail.setHtmlBody(contentBody);
                    mail.setWhatId(recordId);
                }
                
                List<String> sendTo = new List<String>();
                sendTo.add(email);
                mail.setToAddresses(sendTo);
                mail.saveAsActivity=saveAsActivity;
                if(!attachments.isEmpty()) {
                    mail.setFileAttachments(attachments);
                }
                mails.add(mail);                        
            }
            system.debug('Exiting  generateEmails: '+ ' Mail List :'+mails);
            return mails;
        }
    /***************************************************************** 
    Purpose: sendAnEmailMsg method to Generate all related combination for Send Mail
    Parameters: templateId, idList, emailList, emailCCList, subj, contentBody, attIds and claimId
    Returns: 
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @AuraEnabled
    public static sucesMsg sendAnEmailMsg(string templateId, List<String> idList, List<String> emailList,List<string> emailCCList,string subj,string contentBody, List<String> attIds, String claimId) {
          system.debug('Entering  sendAnEmailMsg: '+ ' template Id :'+templateId+ ' ConatctidsList:'+idList+ ' UserEamilList:'+emailList+ ' CCUserEamilList:'+emailCCList+ ' Email Subject :'+subj+ ' contentBody :'+contentBody+' AttachmentIds List :'+attIds+' claimId :'+claimId);
          try {
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            List<Contact> tempContactList = new List<Contact>();
            if(attIds != null && !attIds.isEmpty()) {
                attachments = getContentDocumentAsAttachement(attIds);
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            system.debug('---conIdsList-- ' + idList);
            system.debug('---templateId--- ' + templateId);
            
            if(idList.size()>0 || emailList.size() > 0){
                List<Contact> conList=[Select id,Name,FirstName,LastName,Email,Contact_Type__c From Contact Where Id IN: idList];
                
                for(Contact con : conList){
                    String email = con.Email;
                    mails = generateEmails(email,con.Id, claimId, templateId, contentBody, subj, attachments, mails, true );
                }
                
                List<User> userList = [Select Id, FirstName, LastName, Email from User where Id in: IdList];
                for(User user: userList) {
                     tempContactList.add(new Contact(FirstName=User.FirstName,
                                             LastName=User.LastName,Email=User.Email));                      
                }
                
                for(User user:  [Select Id,FirstName,LastName,Email from User where Email in :emailList]) {
                      tempContactList.add(new Contact(FirstName=User.FirstName,
                                             LastName=User.LastName,Email=User.Email));                      
                }
                
                Insert tempContactList;
                
                for(Contact con : tempContactList){
                    String email = con.Email;
                    mails = generateEmails(email, con.Id, claimId, templateId, contentBody, subj, attachments, mails, true );
                }
            }      
            system.debug('mails'+mails);
            if(mails.size()>0){  
                if(emailCCList.size() > 0){
                    List<String> sendTo = new List<String>();                   
                    for(String e:emailCCList){
                        sendTo.add(e);
                    } 
                    for(Messaging.SingleEmailMessage mm : mails){
                        mm.setccAddresses(sendTo);
                    }
                }                
                try {                    
                    Messaging.sendEmail(mails);
                    if(claimId != null){
                        //Post Chatter regarding Emails
                        postChatterToClaim(claimId, idList);
                    }
                    delete tempContactList;
                   return new sucesMsg(true, 'Sucess!');                    
                } catch(Exception e) {
                    system.debug('*************--Exception @SendEmail method ---*********');
                    System.debug('****--Exception type caught: ' + e.getTypeName());    
                    System.debug('****--Message: ' + e.getMessage());    
                    System.debug('****--Cause: ' + e.getCause());    
                    System.debug('****--Line number: ' + e.getLineNumber());    
                    System.debug('****--Stack trace: ' + e.getStackTraceString());   
                    return new sucesMsg(false, e.getMessage()+' - '+e.getCause()+' - '+e.getStackTraceString()+' - '+e.getLineNumber());
                }
            }            
            return new sucesMsg(true, 'Sucess!');
        }
        catch(Exception e) {
            system.debug('*************--Exception @sendAnEmailMsg method ---*********');
            System.debug('****--Exception type caught: ' + e.getTypeName());    
            System.debug('****--Message: ' + e.getMessage());    
            System.debug('****--Cause: ' + e.getCause());    
            System.debug('****--Line number: ' + e.getLineNumber());    
            System.debug('****--Stack trace: ' + e.getStackTraceString());   
            return new sucesMsg(false, e.getMessage()+' - '+e.getCause()+' - '+e.getStackTraceString()+' - '+e.getLineNumber());
        }       
    }    
    
    public class sucesMsg {        
        @AuraEnabled public boolean isSuccess;
        @AuraEnabled public string errMsg;        
        public sucesMsg(boolean isSuccess, string errMsg){
            this.isSuccess = isSuccess;
            this.errMsg = errMsg;
        }
        
    }
   
    public class emailUserListWrapper {        
        @AuraEnabled public String ID;
        @AuraEnabled public string name;  
        @AuraEnabled public string email;
        @AuraEnabled public string phone;  
        @AuraEnabled public string userRole;        
        public emailUserListWrapper (String ID, string name, string email, string Phone, string userRole){
            this.ID = ID;
            this.name = name;
            this.email = email;
            this.phone = phone;
            this.userRole = userRole;
        }        
    }
}