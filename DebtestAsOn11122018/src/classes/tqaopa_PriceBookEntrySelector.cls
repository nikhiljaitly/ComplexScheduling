public class tqaopa_PriceBookEntrySelector {
    public static List<PricebookEntry> getPricebookEntryByPBId(Id pricebook2Id){
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id limit 2000 ';
        return database.query(queryString);
    }

    /**********************************************************************************************/

    // Support for Assessment Items

    // NOTE Hardcoding of Record Type Id's is VERY BAD and should be moved to a Custom Setting
    // in a Production Build
    public static String reportItemRecTypeId = '0125D000000Cj7v';
    public static String repairItemRecTypeId = '0125D000000Cj7u'; 

    public static List<PricebookEntry> getPricebookEntryAssessItemsByPBId(Id pricebook2Id){
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice, Product2.Work_Item_Description__c, '
                              + 'Product2.Work_Item_Summary__c, Product2.Work_Code__c from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id '
                        + 'AND Product2.RecordTypeId = :reportItemRecTypeId '
                        + 'ORDER BY Product2.Work_Code__c limit 2000 ';
        return database.query(queryString);
    }

    public static List<PricebookEntry> getAssessItemPricebookEntryByCondition(Id pricebook2Id, String condition,  String orderBy){
        System.Debug(LoggingLevel.DEBUG, '***Condition = ' + condition);
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice, Product2.Work_Item_Description__c, '
                              + 'Product2.Work_Item_Summary__c, Product2.Work_Code__c from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id ';
        queryString = queryString + ' and Product2.RecordTypeId = :reportItemRecTypeId ';
        if(condition != null && condition != ''){
          queryString = queryString + '  and ( ' + condition + ' )' ;
        }
        
        queryString = queryString + ' ' + orderBy + ' limit 2000';
        System.debug('###############The query String is #############' + queryString);
        return Database.query(queryString);
    }
    
    public static List<PricebookEntry> getAssessItemPricebookEntryByPBANDProId(Id pricebook2Id, List<Id> productIds, String orderBy){
        System.Debug(LoggingLevel.DEBUG, '***Executing getAssessItemPricebookEntryByPBANDProId...');
        System.Debug(LoggingLevel.DEBUG, '***No Products Passed In: ' + productIds.size());
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice, Product2.Work_Item_Description__c, '
                              + 'Product2.Work_Item_Summary__c, Product2.Work_Code__c from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id  ';
        queryString = queryString + ' and Product2.RecordTypeId = :reportItemRecTypeId ';
        queryString = queryString + ' and product2Id in: productIds '+ orderBy + ' limit 2000';
        System.Debug(LoggingLevel.DEBUG, '***Query String = ' + queryString);
        return database.query(queryString);
    }


    /**********************************************************************************************/

    // Support for Repair Items

    public static List<PricebookEntry> getPricebookEntryRepairItemsByPBId(Id pricebook2Id){
        System.Debug(LoggingLevel.DEBUG, '[PricebookEntrySelector] Executing getPricebookEntryRepairItemsByPBId...');
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice, Product2.Work_Item_Description__c, '
                              + 'Product2.Work_Action__c, Product2.Work_Action_Description__c, '
                              + 'Product2.Work_Item_Summary__c, Product2.Work_Code__c from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id '
                        + 'AND Product2.RecordTypeId = :repairItemRecTypeId '
                        + 'ORDER BY Product2.Name, Product2.Work_Action__c limit 1000 ';
        return database.query(queryString);
    }

    public static List<PricebookEntry> getRepairItemPricebookEntryByCondition(Id pricebook2Id, String condition,  String orderBy){
        System.Debug(LoggingLevel.DEBUG, '***Condition = ' + condition);
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice, Product2.Work_Item_Description__c, '
                              + 'Product2.Work_Action__c, Product2.Work_Action_Description__c, '
                              + 'Product2.Work_Item_Summary__c, Product2.Work_Code__c from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id ';
        queryString = queryString + ' and Product2.RecordTypeId = :repairItemRecTypeId ';
        if(condition != null && condition != ''){
          queryString = queryString + '  and ( ' + condition + ' )' ;
        }
        
        queryString = queryString + ' ' + orderBy + ' limit 1000';
        System.debug('###############The query String is #############' + queryString);
        return Database.query(queryString);
    }
    
    public static List<PricebookEntry> getRepairItemPricebookEntryByPBANDProId(Id pricebook2Id, List<Id> productIds, String orderBy){
        System.Debug(LoggingLevel.DEBUG, '***Executing getAssessItemPricebookEntryByPBANDProId...');
        System.Debug(LoggingLevel.DEBUG, '***No Products Passed In: ' + productIds.size());
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice, Product2.Work_Item_Description__c, '
                              + 'Product2.Work_Action__c, Product2.Work_Action_Description__c, '
                              + 'Product2.Work_Item_Summary__c, Product2.Work_Code__c from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id  ';
        queryString = queryString + ' and Product2.RecordTypeId = :repairItemRecTypeId ';
        queryString = queryString + ' and product2Id in: productIds '+ orderBy + ' limit 1000';
        System.Debug(LoggingLevel.DEBUG, '***Query String = ' + queryString);
        return database.query(queryString);
    }


    /**********************************************************************************************/

    
    public static List<PricebookEntry> getPricebookEntryByCondition(Id pricebook2Id, String condition,  String orderBy){
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id ';
        if(condition != null && condition != ''){
          queryString = queryString + '  and ( ' + condition + ' )' ;
        }
        
        queryString = queryString + ' ' + orderBy + ' limit 2000';
        System.debug('###############The query String is #############' + queryString);
        return Database.query(queryString);
    }
    
    public static List<PricebookEntry> getPricebookEntryByPBANDProId(Id pricebook2Id, List<Id> productIds, String orderBy){
        String queryString ='Select Id, Product2.Id, Product2.ProductCode, '
                              + 'Product2.Family, Product2.Name, Product2.Description, UnitPrice from PricebookEntry ';
        queryString = queryString + ' where Pricebook2Id =: pricebook2Id  and product2Id in: productIds '+ orderBy + ' limit 2000';
        return database.query(queryString);
    }

}