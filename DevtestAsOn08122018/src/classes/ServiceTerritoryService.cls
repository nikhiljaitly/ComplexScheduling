public class ServiceTerritoryService {
    
    public static TradeTypeController.PicklistOption getServiceTerritories(){
        TradeTypeController.PicklistOption option = null;
        List<ServiceTerritory> territories = ServiceTerritorySelector.getServiceTerritory();
        Map<String, List<ServiceTerritory>> regions = (new ServiceTerritoryDomain(territories)).getParentToRegions();
        List<ServiceTerritory> parentTerritories = regions.get(null);
        if(parentTerritories.size()> 0){
            option = getServiceRegions(parentTerritories.get(0), regions);
        }
        System.debug('options' + option);
        return option;
    }
    public static TradeTypeController.PicklistOption getServiceRegions(ServiceTerritory territory, 
        Map<String, List<ServiceTerritory>> regions ) {
        String parentName = territory.Name;
        TradeTypeController.PicklistOption option = new TradeTypeController.PicklistOption(parentName);
        if(parentName == 'National') {
            option.hideChildren = false;
        } 
        List<ServiceTerritory> territories = regions.get(parentName);
        if(territories == null ){
        
            
        } else {
            List<TradeTypeController.PicklistOption> childOptions = new List<TradeTypeController.PicklistOption>();
            
            for(ServiceTerritory record: territories) {
                childOptions.add(getServiceRegions(record, regions));
            }
            option.children = childOptions;
        }
        return option;
    }
}