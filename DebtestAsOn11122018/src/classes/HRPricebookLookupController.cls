public class HRPricebookLookupController {
    @AuraEnabled
     public static List < PricebookEntry > fetchAccount(String searchKeyWord) {
      String searchKey = searchKeyWord + '%';
      List < PricebookEntry > returnList = new List < PricebookEntry > ();
      List < PricebookEntry > lstOfAccount = [select id, Name, Labour_Price__c, Material_Price__c from PricebookEntry where Name LIKE: searchKey];
     
      for (PricebookEntry acc: lstOfAccount) {
         returnList.add(acc);
         }
      return returnList;
     }

     @AuraEnabled
     public static List < PricebookEntry > fetchLabMatCosts(String selectedProdId) {
      List < PricebookEntry > returnList = new List < PricebookEntry > ();
      List < PricebookEntry > lstOfProd = [select id, Name, Labour_Price__c, Material_Price__c from PricebookEntry where Id =:selectedProdId];
     
      for (PricebookEntry prod: lstOfProd) {
         returnList.add(prod);
         }
      return returnList;
     }
    @AuraEnabled
     public static List < workType > fetchworkType(String searchKeyWord) {
      String searchKey = searchKeyWord + '%';
      List < workType > returnList = new List < workType > ();
      List < workType > lstOfAccount = [select id, Name from workType where Name LIKE: searchKey];
     
      for (workType acc: lstOfAccount) {
         returnList.add(acc);
         }
      return returnList;
     }
    
}