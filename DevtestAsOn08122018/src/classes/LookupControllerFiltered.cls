public with sharing class LookupControllerFiltered {

   /* Method to query records using SOSL*/
    @AuraEnabled
    public static String search1(String objectAPIName, String searchText,
            List<String> whereClause, List<String> extrafields){

        objectAPIName = String.escapeSingleQuotes(objectAPIName);
        searchText = String.escapeSingleQuotes(searchText);
        String searchQuery = 'FIND \'' + searchText + '*\' IN ALL FIELDS RETURNING ' + objectAPIName + '(Id,Name' ;
        if(!extrafields.isEmpty()){
            searchQuery = searchQuery + ',' + String.join(extrafields, ',') ;
        }
        system.debug(whereClause);
        if(!whereClause.isEmpty()){
            searchQuery = searchQuery + ' WHERE ' ;
            searchQuery = searchQuery + String.join(whereClause, 'AND') ;
        }
        searchQuery = searchQuery + ' LIMIT 10 ) ';
        system.debug(searchQuery);
        return JSON.serializePretty(search.query(searchQuery)) ;
    }

    /* Method to query records using SOQL*/
    @AuraEnabled
    public static List<SObject> getRecentlyViewed(            
        	String objectAPIName,
            List<String> whereClause,
            List<String> extrafields){

        String searchQuery = 'SELECT Id, Product2.Name';
        if(!extrafields.isEmpty()){           
            searchQuery = searchQuery + ',' + String.join(extrafields, ',') ;
        }
        searchQuery = searchQuery + ' FROM ' + objectAPIName + ' WHERE CreatedDate  != NULL ';
        if(!whereClause.isEmpty()){       
            searchQuery = searchQuery + ' AND ' ;
            searchQuery = searchQuery + String.join(whereClause, 'AND') ;
            system.debug(searchQuery);
        }
        searchQuery = searchQuery + ' ORDER BY CreatedDate DESC Limit 10' ;
        List<SObject> objectList =  new List<SObject>();
        objectList = Database.query(searchQuery);
        return objectList;        
    }
    
    
    /* Method to query records using SOQL*/
    @AuraEnabled
    public static List<SObject> search(
        String searchText,
        String objectAPIName,
        List<String> whereClause,
        List<String> extrafields){
            
            String searchQuery = 'SELECT Id, Product2.Name';
            if(!extrafields.isEmpty()){
                searchText = String.escapeSingleQuotes(searchText);
                searchQuery = searchQuery + ',' + String.join(extrafields, ',') ;
            }
            searchQuery = searchQuery + ' FROM ' + objectAPIName;
            if(!whereClause.isEmpty()){
                string tempsearchInput = '%' + searchText + '%';
                searchQuery = searchQuery + ' WHERE Product2.Name like : tempsearchInput AND ' ;                
                searchQuery = searchQuery + String.join(whereClause, 'AND') ;
                searchQuery = searchQuery + ' LIMIT 10 ';
                system.debug(searchQuery);
            }
            searchQuery = searchQuery;
            List<SObject> objectList =  new List<SObject>();
            objectList = Database.query(searchQuery);
            return objectList;
        }
    
}