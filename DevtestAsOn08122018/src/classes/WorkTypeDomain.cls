public class WorkTypeDomain extends SObjectDomain {
    public WorkTypeDomain(List<WorkType> workTypes) {
        super(workTypes);
    }
    public List<TradeTypeController.PicklistOption> getTradeTypes() {
        List<TradeTypeController.PicklistOption> options = new List<TradeTypeController.PicklistOption>();
        Set<String> tradeTypeSet = new Set<String>();
        for(Sobject record: records) {
            WorkType workT = (WorkType) record;
            if(tradeTypeSet.contains(workT.RecordType.Name)){
                continue;
            }
            options.add(new TradeTypeController.PicklistOption(workT.RecordType.Name, 
                workT.RecordType.Name));
        }
        return options;
    }
    
    public Map<String, List<TradeTypeController.PicklistOption>> getWorkTypes() {

        Map<String, List<TradeTypeController.PicklistOption>> workTypes 
            = new Map<String, List<TradeTypeController.PicklistOption>>();
        for(Sobject record: records) {
            WorkType workT = (WorkType) record;
            String parentTypeName = workT.RecordType.Name;
            List<TradeTypeController.PicklistOption> options 
                = new List<TradeTypeController.PicklistOption>();

            if(workTypes.containsKey(parentTypeName)) {
                options = workTypes.get(parentTypeName);
            }
            options.add(new TradeTypeController.PicklistOption(workT.Name, 
                workT.Name));
            workTypes.put(parentTypeName, options);
        }
        
        return workTypes;
    }
    
    public List<TradeTypeController.PicklistOption> getWorkTypeOptions() {
        List<TradeTypeController.PicklistOption> workTypes 
            = new List<TradeTypeController.PicklistOption>();
        for(Sobject record: records) {
            WorkType workT = (WorkType) record;
            workTypes.add(new TradeTypeController.PicklistOption(workT.Name, 
                workT.Name));
        }
        return workTypes;
    }
}