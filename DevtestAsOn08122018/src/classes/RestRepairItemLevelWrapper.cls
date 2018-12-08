global class RestRepairItemLevelWrapper {
  //Report Item fields
  public String workTypeId; 
  public String workTypeName;  
  public Decimal sortOrder; 
  public Boolean main; 
  public List<String> categories; 
  public List<String> itemDescriptions;
  public List<String> dimensions;
  public List<String> repairMethods;
  public List<String> additionalNotes; 
  public RestRepairItemLevelWrapper (WorkType workType,List<string> categories,List<string> itemDescriptions,List<string> dimensions,List<string> repairMethods,List<string> additionalNotes){
        this.workTypeId = workType.Id;
        this.workTypeName = workType.Name;
        this.main = workType.Main__c;
        this.sortOrder = workType.Sort_Order__c;
        this.categories = categories;
        this.itemDescriptions=itemDescriptions;
        this.dimensions=dimensions;
        this.repairMethods=repairMethods;
        this.additionalNotes=additionalNotes;
  }
}