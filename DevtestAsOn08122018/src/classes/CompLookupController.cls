public class CompLookupController {
	@AuraEnabled
    public static List < PriceBookEntry > productPricesByState(string ProductId, string workOrderId){
        
        String prod = ProductId;
        String wo = workOrderId;
        
        system.debug('***prod: ' + prod);
        system.debug('***wo: ' + wo);
        
        //find relevant wo
        workOrder relatedClaimJobId = [SELECT claim_job__c 
                                       FROM workOrder
                                       WHERE id = :wo
                                       LIMIT 1];
        
        system.debug('*** relatedClaimJob: ' + relatedClaimJobId.id);
        //further up heirarchy through claimjob
        claim_job__c relatedClaimId = [SELECT claim__c
                                 	   FROM claim_job__c
                                	   WHERE id = :relatedClaimJobId.Claim_Job__c
                                       LIMIT 1];
        
        system.debug('***relatedClaimId: ' + relatedClaimId);
        //get claim where state is allocated
        case relatedClaim = [SELECT State1__c
                             FROM Case
                             WHERE id = :relatedClaimId.Claim__c];
        
        system.debug('relatedClaimState: ' + relatedClaim.State1__c);
        
        
        //find relevant product
        List < PricebookEntry > prices = new List < PricebookEntry >();
        
        List < PricebookEntry > pricesToAdd = [SELECT id, Name, Labour_Price__c, Material_Price__c, Product2Id
                                          	   FROM PricebookEntry
                                          	   WHERE Satte__c = :relatedClaim.State1__c 
                                          	   AND Product2Id = :prod
                                          	   LIMIT 1];
        	prices.Add(pricesToAdd[0]);
        if(prices.size() == 0){
            List < PricebookEntry > opricesToAdd = [SELECT id, Name, Labour_Price__c, Material_Price__c, Product2Id
                                          			FROM PricebookEntry
                                          			WHERE Product2Id = :prod
                                          			LIMIT 1];
            prices.Add(opricesToAdd[0]);
        }
        
        system.debug('***prices: ' + prices);
        return prices;
    }
    @AuraEnabled
    public static workOrderLineItem addWOLI(workOrderLineItem WOLI){
        system.debug('***BMwoli: ' + WOLI);
        system.debug('***BMwoli: ' + WOLI.Product2Id);
        insert WOLI;
        return WOLI;
    }
}