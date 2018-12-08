public class InvoiceStatementExtn{
    
    public InvoiceStatementExtn() {
        
    }
    
    public Account acc{         
        get {
            
            List<Account> accList=[Select id,Name,Business_Email_Address__c,Postal_Street__c,
                                   ABN__c,Phone,BillingStreet, BillingCity, BillingState, 
                                   BillingPostalCode, BillingCountry from Account 
                                   where Name='HomeRepair .Net. Au Pty Ltd' LIMIT 1];
            if(accList.size() == 0){
                acc=new Account();
            }else{
                acc=accList[0];              
            }
            return acc;
        } set;
    }
    public InvoiceStatementExtn(ApexPages.StandardController controller) {
        
    }  
}