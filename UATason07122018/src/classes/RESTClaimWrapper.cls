global class RESTClaimWrapper{
    public String claimId{get;set;}
    Public String contactId{get;set;}
    public String claimName{get;set;}
    public String claimDescription{get;set;}
    //public Decimal totalPrice{get;set;}
    public Boolean assessmentReportCreated{get;set;}
    public Decimal estimatedCostofCashSettlement{get;set;}
    public List<RESTRoomRepairItemListWrapper> rooms{get;set;}
    //constructor
    public RESTClaimWrapper(){
        this.rooms = new List<RESTRoomRepairItemListWrapper>();
    }
    //constructor
    public RESTClaimWrapper(Case cs,List<RESTRoomRepairItemListWrapper> roomRepairItemListWrapperList){
        this.claimId = cs.id;
        this.contactId = cs.ContactId;
        this.claimName =cs.CaseNumber;
        this.claimDescription=cs.Description;
        //this.totalPrice=cs.Total_Price__c;
        this.estimatedCostofCashSettlement = cs.Estimated_Cost_of_Cash_Settlement__c;     
        this.rooms = roomRepairItemListWrapperList;
        this.assessmentReportCreated=cs.Assessment_Report_Created__c;
    }
}