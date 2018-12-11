public class LeadHandler implements ITrigger {
    
    private List<LeadConvertProcessor.leadDetail> leadDetailList = new List<LeadConvertProcessor.leadDetail>();
    public LeadHandler() {}
    
    public void bulkBefore() {
    }
    public void bulkAfter() {

        if(Trigger.IsUpdate ||Trigger.IsInsert){          
            for(Sobject leadTemp : trigger.new){ 
                Lead leadRec = (Lead)leadTemp;   
                system.debug('leadRec :'+leadRec);
                if(leadRec.isConverted){
                    if(leadRec.ConvertedAccountId != NULL){
                        LeadConvertProcessor.leadDetail lDetail = new LeadConvertProcessor.leadDetail();
                        lDetail.leadId = leadRec.Id;
                        lDetail.convertedAccountId = leadRec.ConvertedAccountId;
                        lDetail.convertedContactId = leadRec.ConvertedContactId;
                        lDetail.isConverted = true;
                        leadDetailList.add(lDetail);
                    }
                }        
            }
        }   
                                             
    }
    public void beforeInsert(SObject so) {
    } 
    public void afterInsert(SObject so) {
    } 
    public void beforeUpdate(SObject oldSo, SObject so) {

    }
    public void beforeUnDelete(SObject so) {} 
    
    public void afterUpdate(SObject oldSo, SObject so) {} 
    public void beforeDelete(SObject so){} 
    public void afterDelete(SObject so) {} 
    public void afterUnDelete(SObject so) {} 
    public void andFinally() {

        
        if(!leadDetailList.IsEmpty()){
           system.debug('leadDetailList'+leadDetailList);
           LeadConvertProcessor.tradeTypeProcessor(leadDetailList);
        
        }            
        
    }               
}