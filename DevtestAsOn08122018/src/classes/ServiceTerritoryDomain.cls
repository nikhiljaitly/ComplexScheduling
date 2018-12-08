public class ServiceTerritoryDomain extends SObjectDomain {
    public ServiceTerritoryDomain(List<ServiceTerritory> serviceTerritories){
        super(serviceTerritories);
    }
    public Map<String, List<ServiceTerritory>> getParentToRegions(){
        Map<String, List<ServiceTerritory>> regions = new Map<String, List<ServiceTerritory>>();
        for(SObject record: records) {
            ServiceTerritory region = (ServiceTerritory) record;
            String parentName = region.ParentTerritory.Name;
            List<ServiceTerritory> territories = new List<ServiceTerritory>();
            if(regions.containsKey(parentName)){
                territories = regions.get(parentName);
            }
            
            territories.add(region);
            regions.put(parentName, territories);
        }
        return regions;
    }
}