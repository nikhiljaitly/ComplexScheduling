public class homeRepairAPGstDistSetCreationProcessor {
	@InvocableMethod
    public static void collectGstInvoiceId(List<homeRepairAPDistributionSetWrapper> InvoiceDetails) {
        Map<Id,String> InvoiceMap = new Map<Id,String>();
        for(homeRepairAPDistributionSetWrapper inv : InvoiceDetails) {
            InvoiceMap.put(inv.InvoiceId,inv.Status);     
            
        }
    	generateDistributionSets.generateGSTDistribuitonSet(InvoiceMap);
    }

}