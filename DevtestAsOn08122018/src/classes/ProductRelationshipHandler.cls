public class ProductRelationshipHandler implements ITrigger {
    // Product Record Types
    Map<ID,Schema.RecordTypeInfo> rt_Map = Product2.sObjectType.getDescribe().getRecordTypeInfosById();
    // pricebook entries to be inserted/updated
    List<PricebookEntry> pricesToUpdateList = new List<PricebookEntry>();
    
    public ProductRelationshipHandler () {}
    
    public void bulkBefore() {
    }
    public void bulkAfter() {
        system.debug('Entering bulkAfter ProductRelationshipHandler');
        if(Trigger.IsUpdate || Trigger.IsInsert || Trigger.IsDelete){
            set<String> parentProductIds= new set<String>();
            if (Trigger.isDelete) {
                system.debug('Trigger.old :'+Trigger.old);
                List<Product_Relationship__c> proRelList=(List<Product_Relationship__c>) Trigger.old;
                for(Product_Relationship__c pr : proRelList){
                    parentProductIds.add(pr.Parent_Product__c);
                }  
                HomeRepairUtil.updateUnitPrice(false,false,null,true,parentProductIds);
            }else{
                for(Product_Relationship__c pr  :[select id,Parent_Product__r.RecordTypeId,Yield__c from Product_Relationship__c where id IN : Trigger.new]){
                    system.debug('RecordType id :' +pr.Parent_Product__r.RecordTypeId);
                    if(rt_map.get(pr.Parent_Product__r.RecordTypeId).getName().containsIgnoreCase('Repair Item')){
                        if(!Trigger.isInsert){
                              Product_Relationship__c oldPR = (Product_Relationship__c)Trigger.OldMap.get(pr.Id);
                              system.debug('oldPR :'+oldPR);
                              if(oldPR.Yield__c != pr.Yield__c){
                                  parentProductIds.add(pr.id);
                              }
                          }else{
                              parentProductIds.add(pr.id);
                          }
                    }
                }
                system.debug('parentProductIds :'+parentProductIds);   
                HomeRepairUtil.updateUnitPrice(false,false,null,false,parentProductIds);
            } 
                                                    
        }
        system.debug('Exiting bulkAfter ProductRelationshipHandler');
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
        if(!pricesToUpdateList.IsEmpty()){
           system.debug('pricesToUpdateList '+pricesToUpdateList);
           update pricesToUpdateList;       
        }                  
    }               
}