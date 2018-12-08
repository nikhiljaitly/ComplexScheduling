@isTest
public class TestTradeTypeController {
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
        
        Map<String,Schema.RecordTypeInfo> rtMapByName =  
            WorkType.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<WorkType> worktypes = new List<WorkTYpe>();    
        
        worktypes.add(new WorkType(RecordTypeId = rtMapByName.get('Repair Items').getRecordTypeId(), name='Plasterer', DurationType='Hours',
            EstimatedDuration = 4 ));
        worktypes.add(new WorkType(RecordTypeId = rtMapByName.get('MakeSafe Items').getRecordTypeId(), name='MS - Plasterer', DurationType='Hours',
            EstimatedDuration = 4 ));    
        worktypes.add(new WorkType(RecordTypeId = rtMapByName.get('MakeSafe Items').getRecordTypeId(), name='MS - Carpenter', DurationType='Hours',
            EstimatedDuration = 4 ));  
        insert worktypes;
    }
    private static testmethod void testGetTradeComplianceForm(){
        System.assert(TradeTypeController.getTradeComplianceForm() != null);
    }
    private static testmethod void testGetOptions(){
        System.assert(TradeTypeController.getOptions() != null);
    }
    private static testmethod void testGetOptionsByField(){
        System.assert(TradeTypeController.getOptions('[{"objName":"Trade_Type__c","apiName":"Trade_Type__c"}]') != null);
        System.assert(TradeTypeController.getOptions('[{"objName":"Account","apiName":"Specify_the_areas_previously_worked_in__c","dependentFieldName": "Any_previous_work__c"}]') != null);
    }
    
    private static testmethod void testUpsertTradeCompliance(){
        String sampleTradeTypeData = '[{"Trade_Type__c":"Cabinet-maker","License_Number__c":"234234","License_Type__c":"ftest","License_Expiry__c":"2018-09-30"}]';
        System.assert(TradeTypeController.upsertTradeCompliance(sampleTradeTypeData) != null);
    }
    private static testmethod void testGetDocuments(){
        List<Account> accList=HomeRepairTestDataFactory.createAccounts('Test');
        String sampleTradeTypeData = '[{"Trade_Type__c":"Cabinet-maker","License_Number__c":"234234","License_Type__c":"ftest","License_Expiry__c":"2018-09-30", "Account__c":"'
        + accList[0].Id +'"}]';
        TradeTypeController.upsertTradeCompliance(sampleTradeTypeData);
        List<Trade_Type__c> types = [select Id, Trade_Type__c, License_Number__c,License_Type__c,License_Expiry__c  from Trade_Type__c limit 1];
        HomeRepairTestDataFactory.addContentVersionToParent(types.get(0).Id);
        System.assert(TradeTypeController.getDocuments(JSON.serialize(types) )!= null );
    }
    
    
    

}