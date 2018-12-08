public class homeRepairAPLabDistSetCreationProcessor {
    @InvocableMethod
    public static void collectLabInvoiceId(List<homeRepairAPDistributionSetWrapper> InvoiceDetails) {
        Map<Id,String> InvoiceMap = new Map<Id,String>();
        for(homeRepairAPDistributionSetWrapper inv : InvoiceDetails) {
            InvoiceMap.put(inv.InvoiceId,inv.Status);     
            
        }
    	generateDistributionSets.generateLabourDistributionSet(InvoiceMap);
    }
	
}