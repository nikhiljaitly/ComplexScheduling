@isTest(SeeAllData=true)
public class FSLTestAllData {
    
    @isTest
    static void testViewFSLData() {
        List<ServiceTerritory> stList = [SELECT Id, Name, Description FROM ServiceTerritory];
        Integer i = 0;
        for (ServiceTerritory s : stList) {
            i = i + 1;
            System.Debug('Service Territory ' + i + ': ' + s);
        }
        
       
    }

}