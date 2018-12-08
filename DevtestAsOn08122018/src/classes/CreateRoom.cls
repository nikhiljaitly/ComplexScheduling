public with sharing class CreateRoom {
    @AuraEnabled
    public static void createNewRoom(Room__c room, String worecordId){
        try{
            //worecordId = '0WO5D000000Ah7vWAC';
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