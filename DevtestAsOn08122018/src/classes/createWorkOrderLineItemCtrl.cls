public class createWorkOrderLineItemCtrl {
    @AuraEnabled 
    public static string createWorkOrderLineItem(WorkOrderLineItem woli){ //changed from void to string
        List <WorkOrderLineItem> returnList = new List <WorkOrderLineItem> ();        
        try {   
            List<PricebookEntry> pricebookEntryList = [Select ID,Product2Id
                                                       FROM PricebookEntry 
                                                       WHERE Id =: woli.PricebookEntryId
                                                      ];
            
            List<PricebookEntry> pbeList = [Select ID,Product2Id
                                            FROM PricebookEntry 
                                            WHERE Product2Id =: pricebookEntryList[0].Product2Id AND
                                            Pricebook2.Name like 'Standard Price Book' AND IsActive = true
                                           ];
            string sPricebookEntryId;        
            for (PricebookEntry pbe : pbeList)
            {
                sPricebookEntryId = pbe.Id;            
            }
            //Replace PricebookEntryId in woli list to maintain intergrity between WOLI-Product & WO-PriceBook         
            woli.PricebookEntryId = sPricebookEntryId;     
            insert woli;
            
            returnList = [Select ID, LineItemNumber FROM WorkOrderLineItem 
                          WHERE Id =: woli.Id
                         ];            
        }// try ends
        catch (System.QueryException se) {
        }
        finally {}
        //return woli.Id;
        return returnList[0].LineItemNumber;
        
    }
    
    @AuraEnabled 
    public static string fetchCostsValuesId(String PricebookEntryId){
        List <Pricebook2> returnList = new List <Pricebook2> ();
        try {   
            List<PricebookEntry> pricebookEntryList = [Select ID, Product2Id, Pricebook2Id
                                                       FROM PricebookEntry 
                                                       WHERE Id =: PricebookEntryId
                                                      ];
            
            system.debug('##Pricebook2IdHR ' + pricebookEntryList[0].Pricebook2Id);
            
            returnList = [Select ID, Name, Labour_Price__c, Material_Price__c, Labour_TIME_mins__c
                                       FROM Pricebook2 
                                       WHERE Id =: pricebookEntryList[0].Pricebook2Id 
                          			   AND IsActive = true
                                      ];
            
        }// try ends
        
        catch (System.QueryException se) {
        }
        finally {}
        return returnList[0].Id;
    }
    
    @AuraEnabled 
    public static List <Pricebook2> fetchCostsValues(String PricebookEntryId, String woRecId){
        List <Pricebook2> returnList = new List <Pricebook2> ();
        try {   
            List<PricebookEntry> pricebookEntryList = [Select ID, Product2Id, Pricebook2Id, ProductCode
                                                       FROM PricebookEntry 
                                                       WHERE Id =: PricebookEntryId
                                                      ];
            
            List<WorkOrder> woList = [Select ID, Risk_State__c
                                      FROM WorkOrder 
                                      WHERE Id =: woRecId
                                     ];
            
           /* returnList = [Select ID, Name, Labour_Price__c, Material_Price__c, Labour_TIME_mins__c,State__c
                          FROM Pricebook2 
                          WHERE Id =: pricebookEntryList[0].Pricebook2Id AND
                          State__c =: woList[0].Risk_State__c AND
                          IsActive = true
                         ]; */
            
            string priceBookSrch = pricebookEntryList[0].ProductCode + '-' + woList[0].Risk_State__c;
            system.debug('priceBookSrch ' + priceBookSrch);
            returnList = [Select ID, Name, Labour_Price__c, Material_Price__c, Labour_TIME_mins__c,State__c
                          FROM Pricebook2 
                          WHERE Name Like:priceBookSrch AND
                          IsActive = true
                         ];
            
        }// try ends
        
        catch (System.QueryException se) {
        }
        finally {}
        return returnList;
    } 
    
    
}