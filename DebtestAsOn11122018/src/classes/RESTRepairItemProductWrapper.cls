global class RESTRepairItemProductWrapper {
  //Product fields
  public String priceBookEntryId;
  public String productId;
  public String productCode;
  public String name; 
  public String unitPrice;
  public String unitOfMeasure;
  public String workTypeName;
  public String category;
  public String itemDescription;
  public String dimensions;
  public String repairMethod;
  public String additionalNotes; 
  public List<RESTRepairItemProductPriceBookWrapper> prices;
  public RESTRepairItemProductWrapper(Product2 pro,String unitPrice,String tradeType,String priceBookEntryId,List<RESTRepairItemProductPriceBookWrapper> prices){
        this.priceBookEntryId=priceBookEntryId;
        this.productId = pro.Id;
        this.productCode = pro.ProductCode;
        this.Name = pro.name;
        this.unitOfMeasure = pro.UOM__c;
        this.unitPrice = unitPrice;
        this.workTypeName = tradeType;
        this.category = pro.Level_1_Description__c;
        this.itemDescription = pro.Level_2_Description__c;
        this.dimensions = pro.Level_3_Description__c;
        this.repairMethod = pro.Level_4_Description__c;
        this.additionalNotes = pro.Level_5_Description__c;
        this.prices=prices;
  }
}