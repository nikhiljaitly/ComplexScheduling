public class HRWorkTypeController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String sQuery;
        String searchKey = '%' + searchKeyWord + '%';
        String srecordType = 'Repair Items';
        
        List < sObject > returnList = new List < sObject > ();
        
        if(ObjectName == 'WorkType'){
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND RecordType.Name =: srecordType order by createdDate DESC limit 5';
        }        

        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    
    @AuraEnabled
    public static Map<String, String> createTradeTypeRecord(Trade_Type__c newTradeType, String sWorkTypeId) {
        // Forming a  string map to return response
        Map<String,String> resultMap = new Map<String,String>();
        // Adding try catch for exception handling
        try {
            // Inserting the TradeType
            system.debug('newTradeType ' + newTradeType);
            system.debug('WorkType ' + sWorkTypeId);
            newTradeType.Work_Type__c=sWorkTypeId;
            
            insert newTradeType;
            // Setting the success status and message in resultMap
            resultMap.put('status', 'success');
            resultMap.put('message', 'TradeType Inserted Successfully');        
        }
        catch(Exception e) {
            // Setting the error status and message in resultMap
            resultMap.put('status', 'error');
            resultMap.put('message',e.getMessage());
        }
        // Returning the result string map
        return resultMap;        
    }
    
    @AuraEnabled
    public static List<Trade_Type__c> getAllTrades(){        
        return [SELECT Id, Work_Type__c, WorkTypeName__c, License_Number__c, License_Expiry__c,
                Status__c 
                FROM Trade_Type__c order by createddate desc limit 10];
    }
    
    @AuraEnabled
    public static void saveTradeTypes(List<Trade_Type__c> ListTradeType){
        Insert ListTradeType;
    }
    
    @AuraEnabled
    public static List<WorkType> getWorkTypeName(String sWorkTypeId){
        return [SELECT Id, Name
                FROM WorkType where Id =:sWorkTypeId];
    }
    
}