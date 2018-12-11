public class tqaopa_PricebookEntryService{
    //
    public List<PricebookEntry> getPricebookEntryByPBId(Id pricebook2Id){
        return tqaopa_PriceBookEntrySelector.getPricebookEntryByPBId(pricebook2Id);
    }

    public List<PricebookEntry> getPricebookEntryAssessItemsByPBId(Id pricebook2Id){
        return tqaopa_PriceBookEntrySelector.getPricebookEntryAssessItemsByPBId(pricebook2Id);
    }

    public List<PricebookEntry> getPricebookEntryRepairItemsByPBId(Id pricebook2Id){
        System.Debug(LoggingLevel.DEBUG, '[PricebookEntryService] Executing getPricebookEntryRepairItemsByPBId...');
        return tqaopa_PriceBookEntrySelector.getPricebookEntryRepairItemsByPBId(pricebook2Id);
    }
    
    public List<PricebookEntry> getPricebookEntryByFilter(Id pricebook2Id, String filterInfoStr){
        List<PricebookEntry> pricebookEntries 
            = new List<PricebookEntry>();
        tqaopa_ProductService productService = new tqaopa_ProductService();
        
        tqaopa_ProductFilterCondition filterCondition = 
            tqaopa_ProductFilterCondition.create(filterInfoStr);
        
        String condition = filterCondition.generateConditions();
        String orderBy = filterCondition.orderBy;
        if(orderBy != null && orderBy != ''){
            orderBy = ' Order By Product2.'+ orderBy.trim();
        }
        if(orderBy == null){
            orderBy = '';
        }
        
        if(filterCondition.isForSearch){
            List<Id> productIdList = new tqaopa_Products(productService.searchProductsByCriteria(
                    pricebook2Id, condition, filterCondition.keyword)).getRecordIds();        
            pricebookEntries = tqaopa_PriceBookEntrySelector.getPricebookEntryByPBANDProId(pricebook2Id, productIdList, orderBy);    
        }else{
            pricebookEntries = tqaopa_PriceBookEntrySelector.getPricebookEntryByCondition(pricebook2Id, condition, orderBy);                            
        }
        
        return pricebookEntries;
    }

    // filtering support for assessment items
    public List<PricebookEntry> getAssessItemPricebookEntryByFilter(Id pricebook2Id, String filterInfoStr){
        List<PricebookEntry> pricebookEntries 
            = new List<PricebookEntry>();

        System.Debug('***[getAssessItemPricebookEntryByFilter] filterInfo = ' + filterInfoStr);

        tqaopa_ProductService productService = new tqaopa_ProductService();
        
        tqaopa_ProductFilterCondition filterCondition = 
            tqaopa_ProductFilterCondition.create(filterInfoStr);
        
        String condition = filterCondition.generateConditions();
        /*String orderBy = filterCondition.orderBy;
        if(orderBy != null && orderBy != ''){
            orderBy = ' Order By Product2.'+ orderBy.trim();
        }
        if(orderBy == null){
            orderBy = '';
        }*/
        String orderBy = ' ORDER BY Product2.Work_Code__c ';

        System.Debug(LoggingLevel.DEBUG, '***Filter Condition = ' + filterCondition);
        System.Debug(LoggingLevel.DEBUG, '***Sort Condition = ' + orderBy);
        
        if(filterCondition.isForSearch){
            System.Debug(LoggingLevel.DEBUG, '***filterCondition.isForSearch = TRUE');
            List<Id> productIdList = new tqaopa_Products(productService.searchProductsByCriteria(
                    pricebook2Id, condition, filterCondition.keyword)).getRecordIds(); 
            System.Debug(LoggingLevel.DEBUG, '***No. Found Products = ' + productIdList.size());       
            pricebookEntries = tqaopa_PriceBookEntrySelector.getAssessItemPricebookEntryByPBANDProId(pricebook2Id, productIdList, orderBy);    
        }else{
            System.Debug(LoggingLevel.DEBUG, '***filterCondition.isForSearch = FALSE');
            pricebookEntries = tqaopa_PriceBookEntrySelector.getAssessItemPricebookEntryByCondition(pricebook2Id, condition, orderBy);                            
        }
        
        return pricebookEntries;
    }

    // filtering support for repair items
    public List<PricebookEntry> getRepairItemPricebookEntryByFilter(Id pricebook2Id, String filterInfoStr){
        List<PricebookEntry> pricebookEntries 
            = new List<PricebookEntry>();

        System.Debug('***[getRepairItemPricebookEntryByFilter] filterInfo = ' + filterInfoStr);

        tqaopa_ProductService productService = new tqaopa_ProductService();
        
        tqaopa_ProductFilterCondition filterCondition = 
            tqaopa_ProductFilterCondition.create(filterInfoStr);
        
        String condition = filterCondition.generateConditions();
        /*String orderBy = filterCondition.orderBy;
        if(orderBy != null && orderBy != ''){
            orderBy = ' Order By Product2.'+ orderBy.trim();
        }
        if(orderBy == null){
            orderBy = '';
        }*/
        String orderBy = ' ORDER BY Product2.Name, Product2.Work_Action__c ';

        System.Debug(LoggingLevel.DEBUG, '***Filter Condition = ' + filterCondition);
        System.Debug(LoggingLevel.DEBUG, '***Sort Condition = ' + orderBy);
        
        if(filterCondition.isForSearch){
            System.Debug(LoggingLevel.DEBUG, '***filterCondition.isForSearch = TRUE');
            List<Id> productIdList = new tqaopa_Products(productService.searchProductsByCriteria(
                    pricebook2Id, condition, filterCondition.keyword)).getRecordIds(); 
            System.Debug(LoggingLevel.DEBUG, '***No. Found Products = ' + productIdList.size());       
            pricebookEntries = tqaopa_PriceBookEntrySelector.getRepairItemPricebookEntryByPBANDProId(pricebook2Id, productIdList, orderBy);    
        }else{
            System.Debug(LoggingLevel.DEBUG, '***filterCondition.isForSearch = FALSE');
            pricebookEntries = tqaopa_PriceBookEntrySelector.getRepairItemPricebookEntryByCondition(pricebook2Id, condition, orderBy);                            
        }
        
        return pricebookEntries;
    }

}