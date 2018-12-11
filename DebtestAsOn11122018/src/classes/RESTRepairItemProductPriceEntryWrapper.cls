global class RESTRepairItemProductPriceEntryWrapper {
  //Product fields
  public String state; 
  public double labourPrice;
  public double materialPrice;
  public RESTRepairItemProductPriceEntryWrapper(PriceBookEntry pbe){
        this.state = pbe.Satte__c;
        this.labourPrice = pbe.Labour_Price__c;
        this.materialPrice= pbe.Material_Price__c;
  }
}