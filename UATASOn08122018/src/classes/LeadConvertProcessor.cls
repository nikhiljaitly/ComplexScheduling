public without sharing class LeadConvertProcessor {
    
    public static void tradeTypeProcessor(List<leadDetail>leadDetailList) {
        system.debug('Entering tradeTypeProcessor: '+ 'leadDetailList: ' + leadDetailList);
        Map<string,String>leadToAccountIdMap = new Map<string,String>();
        Set<String> conIds=new Set<String>();
        Set<String> acctIds=new Set<String>();
        for(leadDetail ld : leadDetailList){            
            if(ld.isConverted){
                leadToAccountIdMap.put(ld.leadId,ld.convertedAccountId);
                leadToAccountIdMap.put(ld.convertedContactId,ld.convertedAccountId); 
                conIds.add(ld.convertedContactId); 
                acctIds.add(ld.convertedAccountId);  
            }
            
        }
        
        if(acctIds.size() > 0){
            List <Account> acctList = new List<Account>();
            for(Account acct : [Select Id,RecordTypeId
                                from Account
                                where id in :acctIds]) {
                                    acct.Oracle_Process_Status__c = 'Pending';
                                    acct.Type = 'Trade Company';
                                    acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Trade Account').getRecordTypeId(); 
                                    acctList.add(acct);
                                    
                                }
            Update acctList;
        }
        
        if(conIds.size() > 0){
            List <Contact> contList = new List<Contact>();
            for(Contact cont : [Select Id,RecordTypeId
                                from Contact
                                where id in :conIds]) {
                                    cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Trade Contact').getRecordTypeId();
                                    contList.add(cont);
                                    
                                }
            Update contList;
        }
        
        List<Trade_Type__c>tradeTypeList = new List<Trade_Type__c>();
        List<Attachment> attachmentList = new List<Attachment>();
        List<Attachment> attachmentDeleteList = new List<Attachment>(); 
        
        if(!leadToAccountIdMap.isEmpty()){
            for(Trade_Type__c tt : [Select Id,Account__c,Lead__c,Status__c
                                    from Trade_Type__c 
                                    where Lead__c IN : leadToAccountIdMap.keySet()]) {
                                        If (tt.Status__c != 'Rejected'){
                                            tt.Status__c = 'Approved';
                                        }
                                        tt.Account__c = leadToAccountIdMap.get(tt.Lead__c);
                                        tradeTypeList.add(tt);
                                        
                                    }
            for(Attachment att : [SELECT Body, Id, ParentId, Name, Description,ContentType FROM Attachment where ParentId IN : conIds]){
                Attachment accountFile = new Attachment(Name = att.name, body = 
                                                        att.body,ParentId= leadToAccountIdMap.get(att.ParentId),Description=att.Description,ContentType=att.ContentType);
                attachmentList.add(accountFile);                
            }
        }
        if (!tradeTypeList.isEmpty()){
            update tradeTypeList;
        }
        if(!attachmentList.isEmpty()){
            HomeRepairUtil.doUploadContentFromAttachment(attachmentList,conIds);
        }
    }
    
    public class leadDetail{
        
        public string leadId; 
        public String convertedAccountId;
        public String convertedContactId;
        public boolean isConverted ; 
        
    }
}