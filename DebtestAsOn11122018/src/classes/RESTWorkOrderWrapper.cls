global class RESTWorkOrderWrapper{
    public String workOrderId;
    public String workTypeId;
    public String workTypeName;
    public Decimal sortOrder;
    public Decimal totalLabourAmount;
    public Decimal totalMaterialAmount;
    public List<RESTWorkOrderLineItemWrapper> workOrderLineItems;
    public RESTWorkOrderWrapper(WorkOrder wo,List<RESTWorkOrderLineItemWrapper> workOrderLineItemList){
        this.workOrderId  = wo.Id;
        this.workTypeId=wo.WorkTypeId;
        this.workTypeName=wo.WorkType.Name;
        this.sortOrder = wo.Sort_Order__c;
        this.totalLabourAmount=wo.Total_Labour_Amount__c;
        this.totalMaterialAmount=wo.Total_Material_Amount__c;
        this.workOrderLineItems=workOrderLineItemList; 
    }
    
}