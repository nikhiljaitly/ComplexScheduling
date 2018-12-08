Global class UpdateStandardPriceProduct{
      @ InvocableMethod
      public static void fetchStandardPriceProduct(List<String> products) {
        List<Product2> productList = [SELECT Id,Total_Material_Cost__c FROM Product2 WHERE id in :products];
        list<PricebookEntry> pbList = new list<PricebookEntry>();
        Map<string,PricebookEntry> pricebookEntryMap = new Map<string,PricebookEntry>();
        for(PricebookEntry pbe: [Select Product2Id,Product2.Name,UnitPrice From PricebookEntry Where PriceBook2.isStandard=true]){
            pricebookEntryMap.put(pbe.Product2Id,pbe);
        }        
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        for (product2 p:productList){
            if(!pricebookEntryMap.containsKey(p.Id)){
                PricebookEntry pb =new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=p.Total_Material_Cost__c, isActive=true);
                pblist.add(pb);
                p.Total_Material_Cost__c=0.0;
            }
        }
         system.debug('productList '+productList);
         if(pblist.size() > 0){
             insert pblist;
             update productList;
         } 
                 
     return;
  }
}