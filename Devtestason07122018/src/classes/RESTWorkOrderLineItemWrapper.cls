global class RESTWorkOrderLineItemWrapper{
    public String workOrderLineItemId;
    public String roomId;
    public String roomName;
    public String workTypeId;
    public String workTypeName;
    public String productId;
    public String productName;
    public Boolean cashSettled;
    public String contentsType;
    //public Decimal unitPrice;
    //public Decimal totalPrice;
    public Decimal quantity;
    public String UOM;
    public String description;
    public boolean isDeleted;
    public decimal labourCost;
    public decimal materialCost;
    public decimal labourTime;
    public decimal siteVisitNumber;
    public decimal sortOrder;
    public RESTWorkOrderLineItemWrapper(WorkOrderLineItem woli){
        this.workOrderLineItemId  = woli.id;
        this.roomId=woli.Room__r.Id;
        this.roomName=woli.Room__r.Name;
        this.workTypeId= woli.WorkTypeId;
        this.workTypeName=woli.WorkType.Name;
        this.productId= woli.PricebookEntryId;
        this.productName =woli.PricebookEntry.Name;
        this.cashSettled =woli.Cash_Settled__c;  
        this.contentsType =woli.Contents_Type__c; 
        //this.unitPrice =woli.UnitPrice ;  
        //this.totalPrice=woli.TotalPrice;   
        this.UOM = woli.UOM__c;
        this.quantity =woli.Quantity;  
        this.description =woli.Description;
        this.isDeleted=false;   
        this.labourCost=woli.Labour_Cost__c;
        this.materialCost=woli.Material_Cost__c;
        this.labourTime=woli.Labour_Time__c;
        this.siteVisitNumber=woli.Site_Visit_Number__c;
        this.sortOrder=woli.Sort_Order__c;
    }
}