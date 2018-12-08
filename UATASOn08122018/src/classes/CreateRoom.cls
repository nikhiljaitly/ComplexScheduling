public with sharing class CreateRoom {
    @AuraEnabled
    public static void createNewRoom(Room__c room, String worecordId){
        try{
          List<WorkOrder> woList = [SELECT id, caseId
                                      FROM WorkOrder 
                                      WHERE Id =:worecordId];
            string claimId = woList[0].caseId;
            room.Claim__c = claimId;
            if(room.Name != '')
                insert room;
        }
        catch (System.Exception se) {
        }
        finally {}    
    }      
}