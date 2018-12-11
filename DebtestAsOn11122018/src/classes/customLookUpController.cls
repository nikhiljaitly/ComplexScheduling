public class customLookUpController {
    @AuraEnabled
    public static List <sObject> fetchCustomLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug(searchKeyWord+'------'+ObjectName);
        String searchKey = searchKeyWord + '%';        
        List < sObject > returnList = new List < sObject > ();      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' + ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        system.debug('Product Code : '+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}