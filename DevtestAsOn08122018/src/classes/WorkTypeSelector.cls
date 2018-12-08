public with sharing class WorkTypeSelector {
    public static  List<WorkType> getWorkTypes () {
        return [Select Name, Id, DurationType, RecordType.Name from WorkType where RecordType.DeveloperName='Repair_Items' or RecordType.DeveloperName='MakeSafe_Items' order by Name];
    }

}