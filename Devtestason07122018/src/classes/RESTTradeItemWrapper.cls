global class RESTTradeItemWrapper{
    // properties
    public String productName;
    public Decimal unitCost;
    public RESTTradeItemWrapper(ProductRequired trade){
        this.productName=trade.ProductName; 
        this.unitCost=trade.Product2.Unit_Cost__c;           
   }
   public RESTTradeItemWrapper(Product2 trade){
        this.productName=trade.Name; 
        this.unitCost=trade.Unit_Cost__c;           
   }
}