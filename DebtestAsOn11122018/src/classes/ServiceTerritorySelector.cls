public without sharing class ServiceTerritorySelector {
    public static List<ServiceTerritory> getServiceTerritory () {
        return [Select Name,  ParentTerritory.Name from ServiceTerritory where Name != 'Home Repair Assessors'];
    }

}