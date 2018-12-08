global class RESTRepairItemProductLevelPriceWrapper {
  //Product fields
  List<RestRepairItemProductPriceWrapper> products;
  List<RestRepairItemLevelWrapper> levels; 
  public RESTRepairItemProductLevelPriceWrapper(List<RestRepairItemProductPriceWrapper> products,List<RestRepairItemLevelWrapper> levels){
        this.products=products;
        this.levels=levels;
  }
}