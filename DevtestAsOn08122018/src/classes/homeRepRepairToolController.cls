/***
 * homeRepRepairToolController is the controller for 
 * the lightning component homeRepAssessTool
 * 
***/
public class homeRepRepairToolController {
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
    public static List<Room__c> getCaseRooms(Id caseId){
        List<Room__c> rooms = [select Id, Name, Length__c, Width__c, Height__c,
                                Floor__c, Perimeter__c, Wall__c, Claim__c  
                               from Room__c where Claim__c = :caseId ];
        
        return rooms;
    }

    @AuraEnabled
    public static List<PriceBookEntryFeed> getProductCandidate(Id pricebook2Id){
        System.Debug(LoggingLevel.DEBUG, '[homeRepRepairToolController] Executing getProductCandidate...');
        tqaopa_PricebookEntryService service = new tqaopa_PricebookEntryService();
        
        List<PriceBookEntry> priceBookEntries = service.getPricebookEntryRepairItemsByPBId(pricebook2Id);
        return getPricebookEntryFeeds(pricebookEntries);
    }

    @AuraEnabled
    public static List<PriceBookEntryFeed> applyFilterSearch(Id pricebook2Id, String filterInfoStr){
        System.Debug('***Passed in Filter  =' + filterInfoStr);
        tqaopa_PricebookEntryService service = new tqaopa_PricebookEntryService();
        List<PricebookEntry> pricebookEntries 
            = service.getRepairItemPricebookEntryByFilter(pricebook2Id, filterInfoStr);
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
    public static Map<String, Object> createRepairItems(String repairItemJSON, Id recordId,
                Id pricebookId){
        WorkOrderService2 service = new WorkOrderService2();
        try{
           service.createWorkOrders(repairItemJSON, recordId, pricebookId);
        }catch(DMLException ex){
            Map<String, Object> errors = tqaopa_GlobalUtility.handleWithDMLException(ex);
            
            return errors;
        }
        
        Map<String, Object> successMessage = new Map<String, Object>{'IsSuccess'=>true};
        
        return successMessage;
        
    }

    /* Fields needed to create WO & Line Items

    caseId (recordId)
    pricebookEntryId
    Quantity
    UnitPrice
    RoomId
    workActionId
    workItemDescription

    */
    
    // Class to convert JSON Repair Items into
    public class RepairItem{
        public String caseId {get; set;}
        public String pbEntryId {get; set;}
        public Double quantity {get; set;}
        public Double unitPrice {get; set;}
        public String roomId {get; set;}
        public String workActionId {get; set;}
        public String workItemDescription {get; set;}
        /*public Double quantity {set;get;}
        public RepairItemClaim claim;
        public RepairItemPBEntry pBEntry {set; get;}
        public RepairItemRoom room {set; get;}
        public String productName{set;get;}
        public String priceBookEntryId{set;get;}
        public Date serviceDate{set;get;}
        public String description{set;get;}
        public String productId {set; get;}
        public String longDescription {set; get;}
        public String workActionId {get; set;}
        public String workActionDescription {get; set;}*/
    }

    // Pricebook Entry Component of Repair Item JSON
    public class RepairItemPBEntry {
        public Id pBEntryId {set; get;}
        public Id productId {get; set;}
        public Double unitPrice {get; set;}
        public RepairItemPBEntryProduct product {get; set;}
    }

    // Pricebook Entry, Product Component of Repair Item JSON
    public class RepairItemPBEntryProduct {
        public Id productId {get; set;}
        public String productName {get; set;}
        public String workActionDescription {get; set;}
        public String workActionId {get; set;}
        public String workCode {get; set;}
        public String workItemDescription {get; set;}
        public String workItemSummary {get; set;}
    }

    // Claim (Case) Component of Repair Item JSON
    public class RepairItemClaim {
        public Id claimId {get; set;}
        public String caseNumber {get; set;}
        public String subject {get; set;}
        public String status {get; set;}
    }

    // Room Component of Repair Item JSON
    public class RepairItemRoom {
        public Id roomId {get; set;}
        public Id claimId {get; set;}
        public Double floor {get; set;}
        public Double wall {get; set;}
        public Double perimeter {get; set;}
        public Double length {get; set;}
        public Double width {get; set;}
        public Double height {get; set;}
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