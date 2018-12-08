@isTest
public class TestServiceTerritoryService {
    @testSetup 
    public static void prepareData() {
        OperatingHours bhs = new OperatingHours();
        bhs.Name = 'Base Calendar (Syd/Vic)';
        bhs.Name = 'Australia/Sydney';
        insert bhs;
        
        ServiceTerritory territory = new ServiceTerritory();
        territory.Name = 'National';
        territory.OperatingHoursId = bhs.Id;
        insert territory;
        
        
        List<ServiceTerritory> terrotiries = new List<ServiceTerritory>();
        ServiceTerritory territory1 = new ServiceTerritory();
        territory1.Name = 'QLD';
        territory1.OperatingHoursId = bhs.Id;
        territory1.ParentTerritoryId = territory.Id;
        ServiceTerritory territory2 = new ServiceTerritory();
        territory2.Name = 'VIC';
        territory2.OperatingHoursId = bhs.Id;
        territory2.ParentTerritoryId = territory.Id;
        ServiceTerritory territory3 = new ServiceTerritory();
        territory3.Name = 'NSW';
        territory3.OperatingHoursId = bhs.Id;
        territory3.ParentTerritoryId = territory.Id;
        
        terrotiries.add(territory1);
        terrotiries.add(territory2);
        terrotiries.add(territory3);
        insert terrotiries;
    }
    private static testmethod void testServiceTerritory(){
        ServiceTerritoryService.getServiceTerritories();
    }

}