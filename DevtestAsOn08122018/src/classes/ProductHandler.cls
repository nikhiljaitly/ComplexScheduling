public with sharing class ProductHandler implements ITrigger{

    // Product Record Types
    Map<ID,Schema.RecordTypeInfo> rt_Map = Product2.sObjectType.getDescribe().getRecordTypeInfosById();
    
    
    // pricebook entries related to products
    Map<String,PricebookEntry> productPriceMap = new Map<String, PricebookEntry>();

    // Standard Pricebook
    String standardPricebookId;
    String standardPricebookName = 'Standard Price Book';

    // pricebook entries to be inserted/updated
    List<PricebookEntry> pricesToInsert = new List<PricebookEntry>();
    List<PricebookEntry> pricesToUpdate = new List<PricebookEntry>();
  
    public ProductHandler() {}
  
    public void bulkBefore() {}
    
    public void bulkAfter() {
        system.debug('Entering bulkAfter ProductHandler');
        // get a map of related Pricebook Entries for Product(s)
        List<Pricebook2> pBook = [SELECT Id FROM Pricebook2 WHERE Name = :standardPricebookName];
        standardPricebookId = pBook[0].Id;
        Set<Id> productKeys = Trigger.newMap.keySet();
        List<PricebookEntry> productPriceList = [SELECT Id, Pricebook2Id, 
                                        Product2Id, UnitPrice,
                                        Pricebook2.Name
                                FROM PricebookEntry
                                WHERE Product2Id IN :productKeys
                                    AND Pricebook2Id = :standardPricebookId];
        if (productPriceList.size() > 0) {
            for (PricebookEntry p : productPriceList) {
                productPriceMap.put(String.valueOf(p.Product2Id), p);
            }
        }
        
        if(Trigger.IsUpdate){
            set<String> parentProductIds= new set<String>();
            for(product2 pro  :[select id,RecordTypeId,isActive from product2 where id IN : Trigger.new]){
                system.debug('RecordType id :' +pro.RecordTypeId);
                if(rt_map.get(pro.RecordTypeId).getName().containsIgnoreCase('Repair Item')){
                      product2 oldProduct = (product2)Trigger.OldMap.get(pro.Id);
                      if(oldProduct.isActive != pro.isActive){
                          parentProductIds.add(pro.id);
                      }
                }
            }
            if(parentProductIds.size() > 0){  
                HomeRepairUtil.updateUnitPrice(false,true,null,false,parentProductIds);    
            }                                    
        }
        System.Debug(LoggingLevel.DEBUG, '***[bulkAfter] standardPricebookId = ' + standardPricebookId);
        System.Debug(LoggingLevel.DEBUG, '***[bulkAfter] productPriceMap = ' + productPriceMap);
        system.debug('Exiting bulkAfter ProductHandler');
    }
    
    public void beforeInsert(SObject so) {} 
    
    public void afterInsert(SObject so) {
        
        // cast to correct type
        Product2 newProduct = (Product2) so;
        
        // create a Standard Pricebook Entry for a Repair Product
        System.Debug(LoggingLevel.DEBUG, '***Create a New Standard Pricebook Entry for a Repair Item');
        if(rt_map.get(newProduct.recordTypeID).getName().containsIgnoreCase('Repair Item')){
            PricebookEntry p = new PricebookEntry();
            p.Product2Id = newProduct.Id;
            p.Pricebook2Id = standardPricebookId;
            p.UnitPrice = newProduct.Unit_Cost__c;
            p.IsActive = true;
            pricesToInsert.add(p);
        }
    } 
    
    public void beforeUpdate(SObject oldSo, SObject so) {}
    
    public void afterUpdate(SObject oldSo, SObject so) {

        // cast to correct types
        Product2 oldProduct = (Product2) oldSo;
        Product2 newProduct = (Product2) so;
        system.debug('newProduct :'+newProduct);
        // process Repair Item Pricebook Entries
        if(rt_map.get(newProduct.recordTypeID).getName().containsIgnoreCase('Repair Item')){

                System.Debug(LoggingLevel.DEBUG, '***[afterUpdate] productPriceMap = ' + productPriceMap);

                // check if price already exists for product
                PricebookEntry productPrice = productPriceMap.get(newProduct.Id);
                if (productPrice == null) {
                    // if it doesn't exist, create a Standard Pricebook Entry for a Repair Product
                    System.Debug(LoggingLevel.DEBUG, '***[afterUpdate] Create a New Standard Pricebook Entry for a Repair Item');
                    PricebookEntry p = new PricebookEntry();
                    p.Product2Id = newProduct.Id;
                    p.Pricebook2Id = standardPricebookId;
                    p.UnitPrice = newProduct.Unit_Cost__c;
                    p.IsActive = true;
                    pricesToInsert.add(p);

                } else {
                    // if it exists, and price has changed, update Standard Pricebook Entry for a Repair Product
                    System.Debug(LoggingLevel.DEBUG, '***[afterUpdate] Updating Standard Pricebook Entry for a Repair Item (if required)');
                    if (newProduct.Unit_Cost__c != productPrice.UnitPrice) {
                        PricebookEntry newPrice = productPriceMap.get(newProduct.Id);
                        newPrice.UnitPrice = newProduct.Unit_Cost__c;
                        pricesToUpdate.add(newPrice);
                    }
                }
            
        }

    }

    public void beforeDelete(SObject so) {} 
    public void afterDelete(SObject so) {} 
    
    public void beforeUnDelete(SObject so) {} 
    public void afterUnDelete(SObject so) {} 
    
    public void andFinally() {
        // perform insert/update of pricebook entries
        if (pricesToInsert.size() > 0) {
            insert pricesToInsert;
        }

        if (pricesToUpdate.size() > 0) {
            update pricesToUpdate;
        }


    }
}