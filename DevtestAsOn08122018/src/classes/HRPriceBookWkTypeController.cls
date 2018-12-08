public class HRPriceBookWkTypeController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchWorkType, String searchState, String searchKeyWord, String ObjectName, String woRecordId) {
        system.debug('ObjectName-->' + ObjectName);
        String sQuery;
        String searchKey = '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        //Get Claim to filter for Rooms associated to Claim.
        List <WorkOrder> woList = new List <WorkOrder> ();      
        woList = [Select ID, WorkOrderNumber, CaseId FROM WorkOrder 
                  WHERE Id =: woRecordId
                 ];
        string sClaimId = woList[0].CaseId;
       
        
        if(ObjectName == 'PricebookEntry'){
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        sQuery =  'select id, Name, ProductCode from ' +ObjectName + ' where Name LIKE: searchKey AND WorkType__c =: searchWorkType order by createdDate DESC limit 100';
        }
        else if(ObjectName == 'WorkOrder'){
             sQuery =  'select id, WorkOrderNumber from ' +ObjectName + ' where WorkOrderNumber LIKE: searchKey order by createdDate DESC limit 5';     
        }
        else if(ObjectName == 'ServiceAppointment'){
            sQuery =  'select id, AppointmentNumber from ' +ObjectName + ' where AppointmentNumber LIKE: searchKey order by createdDate DESC limit 5';     
        }
        else if(ObjectName == 'Room__c'){
            //sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
            sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND Claim__c =: sClaimId order by createdDate DESC limit 5';     
        }

        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
   @AuraEnabled 
    public static List <WorkOrder> getWorkOrderWorkType(String WorkOrderId){
        List <WorkOrder> returnList = new List <WorkOrder> ();
        try {   
                returnList = [Select ID, WorkOrderNumber, WorkType.Name, Risk_State__c FROM WorkOrder 
                              WHERE Id =: WorkOrderId
                             ];
            
        }// try ends
        
        catch (System.QueryException se) {
        }
        finally {}
        //return returnList[0].WorkType.Name;
        return returnList;
    }    
    
    
}