/***
 * homeRepAssessToolController is the controller for 
 * the lightning component homeRepAssessTool
 * 
***/
public class homeRepAssessToolController {
	@AuraEnabled
    public static Case getCaseRecord(Id caseId){
        List<Case> cases = [select Id, CaseNumber, Subject, Status  from Case where Id = :caseId ];
        Case returnCase = null;
        if(!cases.isEmpty()){
            returnCase = cases.get(0);
        }
        return returnCase;
    }

    @AuraEnabled
    public static List<PriceBookEntryFeed> getProductCandidate(Id pricebook2Id){
        tqaopa_PricebookEntryService service = new tqaopa_PricebookEntryService();
        
        List<PriceBookEntry> priceBookEntries = service.getPricebookEntryAssessItemsByPBId(pricebook2Id);
        return getPricebookEntryFeeds(pricebookEntries);
    }

    @AuraEnabled
    public static List<PriceBookEntryFeed> applyFilterSearch(Id pricebook2Id, String filterInfoStr){
        System.Debug('***Passed in Filter  =' + filterInfoStr);
        tqaopa_PricebookEntryService service = new tqaopa_PricebookEntryService();
        List<PricebookEntry> pricebookEntries 
            = service.getAssessItemPricebookEntryByFilter(pricebook2Id, filterInfoStr);
        return getPricebookEntryFeeds(pricebookEntries);
    }
    
    private static List<PriceBookEntryFeed> getPricebookEntryFeeds(List<PricebookEntry> pricebookEntries ){
        List<PriceBookEntryFeed> feeds = new List<PriceBookEntryFeed>();
        for(PriceBookEntry pb: priceBookEntries){
            feeds.add(new PriceBookEntryFeed(pb));
        }
        return feeds;
    }

    
    @AuraEnabled
    public static void saveCaseRecord(Case caseRecord){
        update caseRecord;
    }

    @AuraEnabled
    public static Map<String, Object> createAssessmentItems(String assessmentItemJSON, Id recordId){
        AssessmentLineItemService service = new AssessmentLineItemService();
        try{
            service.createAssessmentLineItems(assessmentItemJSON, recordId);
        }catch(DMLException ex){
            Map<String, Object> errors = tqaopa_GlobalUtility.handleWithDMLException(ex);
            
            return errors;
        }
        
        Map<String, Object> successMessage = new Map<String, Object>{'IsSuccess'=>true};
        
        return successMessage;
        
    }
    
    // adapted and used as an Assessment Report Item
    public class AssessmentItem{
        public Double salesPrice{set;get;}
        public Double quantity {set;get;}
        public String productName{set;get;}
        public String priceBookEntryId{set;get;}
        public Date serviceDate{set;get;}
        public String description{set;get;}
        public String productId {set; get;}
        public String longDescription {set; get;}
        
        
    }
    
    public class PriceBookEntryFeed{
        public PriceBookEntryFeed(PriceBookEntry pbEntry){
            this.isSelected = false;
            this.pbEntry = pbEntry;
        }
        
        @AuraEnabled
        public PriceBookEntry pBEntry {private set;get;}
        
        @AuraEnabled
        public String linkURL{ private set; get{
            return '/' + pBEntry.Product2.Id;
            
        }}
        
        @AuraEnabled
        public Boolean isSelected {set;get;}
        
    }
}