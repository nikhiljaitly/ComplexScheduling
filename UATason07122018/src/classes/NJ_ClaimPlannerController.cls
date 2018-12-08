public with sharing class NJ_ClaimPlannerController {
	public class SummVal {
		public String label;
		public String colorCode;
		public String iconName;
		public SummVal(String lbl, String code, String iconName) {
			this.label = lbl;
			this.colorCode = code;
			this.iconName = iconName;
		}
	}
	public static Map<String, SummVal> summaryLabelMap = new Map<String,SummVal> {'New' => new SummVal('New', '#A2D9CE', 'action:description'),
																									   									 'Tentative' => new SummVal('Tentative', '#F4D03F', 'action:info'),
																																		   
																																	     'Awaiting Confirmation' => new SummVal('AwaitConf', '#1132D5', 'action:submit_for_approval'),
																																	     'Confirmed' => new SummVal('Confirmed', '#85C1E9', 'action:user'),
																																	     'Cannot Complete' => new SummVal('CantCompl', '#EC7063', 'action:reject'),
																																	     'Cancelled'  => new SummVal('Cancelled', '#18090E', 'action:close'),
																																		   'Completed' => new SummVal('Completed', '#58D68D', 'action:approval')};
	
                                                                                                                                               
                                                                                                                                               
  /* public static Map<String, SummVal> summaryLabelMap = new Map<String,SummVal> {'None' => new SummVal('New', '#A2D9CE', 'action:description'),
																									   									 'Scheduled' => new SummVal('Tentative', '##F4D03F', 'action:info'),
																																		   'Dispatched' => new SummVal('Confirmed', '#85C1E9', 'action:approval'),
																																	     'In Progress' => new SummVal('In Progress', '#D4AC0D', 'utility:rating'),
																																	     'Cannot Complete' => new SummVal('Cannot Complete', '#EC7063', 'utility:rating'),
																																		   'Completed' => new SummVal('Completed', '#58D68D', 'utility:like'),
																																	   'Canceled' => new SummVal('Canceled', '#D7DBDD', 'utility:dislike')};*/
	                                                                                                                                            
	public class ClaimPlannerInitInfo {
		@AuraEnabled
		public List<NJ_SelectOptionLightning> summaries;
		@AuraEnabled
		public Boolean hasWorkOrder;
		public ClaimPlannerInitInfo() {
			summaries = new List<NJ_SelectOptionLightning>();
			hasWorkOrder = false;
		}
	}
	@AuraEnabled
	public static ClaimPlannerInitInfo initClaimPlanner(String claimId) {
		System.debug(claimId);
		ClaimPlannerInitInfo cpii = new ClaimPlannerInitInfo();
		for(String summLabel : summaryLabelMap.keySet()) {
			cpii.summaries.add(new NJ_SelectOptionLightning(summLabel, summaryLabelMap.get(summLabel).label, summaryLabelMap.get(summLabel).colorCode,summaryLabelMap.get(summLabel).iconName));
		}
		Integer totalStatus = 0;
		for(AggregateResult agr : [SELECT COUNT(Id) total, Status stat
															 FROM ServiceAppointment
															 WHERE Claim__c = :claimId
															 GROUP BY Status]) {
			for(NJ_SelectOptionLightning summ : cpii.summaries) {
				if(summ.value == String.valueOf(agr.get('stat'))) {
					summ.total = Integer.valueOf(String.valueOf(agr.get('total')));
				}
			}
			totalStatus += Integer.valueOf(String.valueOf(agr.get('total')));
		}
		List<WorkOrder> workOrders = [SELECT Id
																  FROM WorkOrder
																  WHERE CaseId = :claimId
																  LIMIT 1];
		if(workOrders.isEmpty()) {
			cpii.hasWorkOrder = false;
		} else {
			cpii.hasWorkOrder = true;
		}
		NJ_SelectOptionLightning totalOpt = new NJ_SelectOptionLightning('Total','Total','','action:add_relationship');
		totalOpt.total = totalStatus;
		cpii.summaries.add(totalOpt);
		return cpii;
	}
}