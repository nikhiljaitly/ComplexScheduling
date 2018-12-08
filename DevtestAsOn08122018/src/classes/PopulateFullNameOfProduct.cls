Global class PopulateFullNameOfProduct{
      @ InvocableMethod
      public static void fetchProductForProductFullName(List<String> products) {
        List<Product2> productList = [SELECT Id,Level_1_Description__c,Level_2_Description__c,Level_3_Description__c,Level_4_Description__c,Level_5_Description__c FROM Product2 WHERE id in :products];
         system.debug('productList :'+productList );
         for(Product2 pro : productList ) {
             String fullName='';
             if(pro.Level_1_Description__c != null || pro.Level_1_Description__c != ''){
                 fullName += pro.Level_1_Description__c+' - ';
             } 
             if(pro.Level_2_Description__c != null || pro.Level_1_Description__c != ''){
                 fullName += pro.Level_2_Description__c+' - ';
             }  
             if(pro.Level_3_Description__c != null || pro.Level_1_Description__c != ''){
                 fullName += pro.Level_3_Description__c+' - ';
             }  
             if(pro.Level_4_Description__c != null || pro.Level_1_Description__c != ''){
                 fullName += pro.Level_4_Description__c+' - ';
             } 
             if(pro.Level_5_Description__c != null || pro.Level_1_Description__c != ''){
                 fullName += pro.Level_5_Description__c;
             }
             if(fullName !=''){    
                 pro.Name=fullName; 
             }    
         }
         system.debug('productList '+productList);
         if(productList.size() > 0){
             update productList;
         }         
     return;
  }
}