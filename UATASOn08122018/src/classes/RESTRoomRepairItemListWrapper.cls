global class RESTRoomRepairItemListWrapper{
    // properties
    public string roomId;
    public string name;
    public String claimId;
    public Decimal floor;
    public Decimal height;
    public Decimal length;
    public Decimal width;
    public Decimal wall;
    public Decimal perimeter; 
    public boolean isDeleted; 
    public List<RESTWorkOrderWrapper> workOrders;
    public List<RESTAttachmentWrapper> attachments;
    //constructor
    public RESTRoomRepairItemListWrapper(){
        this.workOrders = new List<RESTWorkOrderWrapper>();
        this.attachments=new List<RESTAttachmentWrapper>();
        this.isDeleted=false;   
    }
    //constructor 
    public RESTRoomRepairItemListWrapper(Room__c rm,List<RESTWorkOrderWrapper> workOrderList,List<RESTAttachmentWrapper> attachments){
        this.roomId=rm.Id;
        this.name=rm.Name;
        this.claimId=rm.Claim__c;
        this.floor=rm.floor__c;
        this.height=rm.height__c;
        this.length=rm.length__c;
        this.width=rm.width__c;
        this.wall=rm.wall__c;
        this.perimeter=rm.perimeter__c;        
        this.workOrders = workOrderList;
        this.attachments=attachments;
        this.isDeleted=false;   
    }
    
}