public class homeRepairMatDistSetCreationProcessor {
	@InvocableMethod
    public static void collectMatInvoiceId(List<homeRepairAPDistributionSetWrapper> InvoiceDetails) {
        Map<Id,String> InvoiceMap = new Map<Id,String>();
        for(homeRepairAPDistributionSetWrapper inv : InvoiceDetails) {
            InvoiceMap.put(inv.InvoiceId,inv.Status);     
            
        }
    	generateDistributionSets.generateMaterialDistributionSet(InvoiceMap);
    }
}