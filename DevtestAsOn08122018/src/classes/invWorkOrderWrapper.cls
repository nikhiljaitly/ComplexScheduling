global class invWorkOrderWrapper{
    public String workOrderId;
    public String workTypeId;
    public String workTypeName;
    public Decimal totalPrice;
    public Decimal sortOrder;
    public List<invWorkOrderLineItemWrapper> workOrderLineItems {get; set;}
    public invWorkOrderWrapper(WorkOrder wo,List<invWorkOrderLineItemWrapper> workOrderLineItemList){
        this.workOrderId  = wo.Id;
        this.workTypeId=wo.WorkTypeId;
        this.workTypeName=wo.WorkType.Name;
        this.totalPrice=wo.TotalPrice;
        this.sortOrder = wo.Sort_Order__c;
        this.workOrderLineItems=workOrderLineItemList; 
    }
    
}