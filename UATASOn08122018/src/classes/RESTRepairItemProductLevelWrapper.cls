global class RESTRepairItemProductLevelWrapper {
  //Product fields
  List<RestRepairItemProductWrapper> products;
  List<RestRepairItemLevelWrapper> levels; 
  public RestRepairItemProductLevelWrapper(List<RestRepairItemProductWrapper> products,List<RestRepairItemLevelWrapper> levels){
        this.products=products;
        this.levels=levels;
  }
}