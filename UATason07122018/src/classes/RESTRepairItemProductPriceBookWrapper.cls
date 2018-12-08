global class RESTRepairItemProductPriceBookWrapper {
  //Product fields
  public String state; 
  public double labourPrice;
  public double materialPrice;
  public double labourTime;
  public RESTRepairItemProductPriceBookWrapper(PriceBook2 pb){
        this.state = pb.State__c;
        this.labourPrice = pb.Labour_Price__c;
        this.materialPrice= pb.Material_Price__c;
      	this.labourTime = pb.Labour_TIME_mins__c;
  }
}