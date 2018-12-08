//class to generate distribution sets on accounts sent in
public class generateDistributionSets {
    
    //generate Labour Distribution Set
      public static void generateLabourDistributionSet(Map<ID,String> invoiceRecord) {  
          try{  
          List<AP_Invoice__c> apInvoice = [SELECT id, Work_Order__c
                                           FROM AP_Invoice__c
                                           WHERE Id =:invoiceRecord.keySet()
                                           LIMIT 1];
          
          
          
                    //query for work order related to invoice     
                    List<WorkOrder> workOrder = [SELECT id, job_Type__c, Claim__c, Work_Type_Name__c
                                                 FROM WorkOrder
                                                 WHERE Id =:apInvoice[0].Work_Order__c
                                                 LIMIT 1];
               		
              		system.debug('***workOrder.size: ' + workOrder.size());
                    //query for claim related to workOrder
                    If(workOrder.size() > 0){
                    List<Case> Claim = [SELECT id, State1__c
                                        FROM Case
                                        WHERE CaseNumber = :workOrder[0].Claim__c];
        
        			/*system.debug('***claim.size: ' + Claim.size());
                    system.debug('***workOrder jobType: ' + workOrder[0].Job_Type__c);
                    system.debug('***claim state: ' + Claim[0].State1__c);*/
                    //get Cost Centre Part of DS
                    //query for the CC_Code__c code that matched the job type on the related work order
                    List<Cost_Centre__mdt> CostCentre = [SELECT id, CC_Code__c, Description__c
                                                         FROM Cost_Centre__mdt
                                                         WHERE Description__C = :workOrder[0].Job_Type__c
                                                         AND State__c = :Claim[0].State1__c
                                                         LIMIT 1];
                    
                    //system.debug('***CostCentre.size: ' + CostCentre.size());
                    //assign query results to a value for placing into the DS
                    Decimal CostCentreMDT = CostCentre[0].CC_Code__c;
                    
                    
                    Double x = double.valueOf(CostCentreMDT);
                    integer CC = x.intValue();
                    
                    
        			//system.debug('***CostCentreMDT: ' + CostCentreMDT);
                    //Get Trade Part
                    if(CostCentre.size() > 0){
                    List<Trade__mdt> Trade = [SELECT CC_Code__c, description__c
                                              FROM Trade__mdt
                                              WHERE description__c = :workOrder[0].Work_Type_Name__c];
                    Decimal TradeMDT = Trade[0].CC_Code__c;
                        
                    Double z = double.valueOf(TradeMDT);
                    integer TradeCode = z.intValue();
                    
                    //create labour distribution set with found values
                    Map<String, Decimal> DistributionSetLabour = new Map<String, Decimal>();
                    DistributionSetLabour.put('CostCentre' , CC);
                    DistributionSetLabour.put('Trade' , TradeCode);
                    
                    String LabourDisSet = ('11.' + CC + '.51300.' 
                                           + TradeCode + '.000');
                      
                    //assign created value to map and update apInvoice
                      List<AP_Invoice__c> apInvtoUpdate = [SELECT id, Status__c, GST_Labour__c 
                                                           FROM AP_Invoice__c 
                                                           WHERE Id =:invoiceRecord.keySet()];
                        system.debug('***apInvtoUpdate Labour: ' + apInvtoUpdate[0].GST_Labour__c);
                                if(apInvtoUpdate != null && apInvtoUpdate[0].GST_Labour__c != 0.00)
                                     for (AP_Invoice__c apinv : apInvtoUpdate) 
                                         apinv.Labour_Distribution_Set__c = LabourDisSet; 
                                         update apInvtoUpdate;
                  }
              }
          }
        catch(exception e){
              return;
          }  
    }
    
    //generate Material Distibution Set
    public static void generateMaterialDistributionSet(Map<ID,String> invoiceRecord){
        try{
          List<AP_Invoice__c> apInvoice = [SELECT id, Work_Order__c
                                           FROM AP_Invoice__c
                                           WHERE Id =:invoiceRecord.keySet()
                                           LIMIT 1];
          
          
                	//query for work order related to invoice
                    if(apInvoice.size() > 0){
                    List<WorkOrder> workOrder = [SELECT id, job_Type__c, Claim__c, Work_Type_Name__c
                                                 FROM WorkOrder
                                                 WHERE Id =:apInvoice[0].Work_Order__c
                                                 LIMIT 1];
	        
        			//query for claim related to workOrder
                    if(workOrder.size() > 0){
                    List<Case> Claim = [SELECT id, State1__c
                                        FROM Case
                                        WHERE CaseNumber = :workOrder[0].Claim__c];
                
                
                    //get Cost Centre Part of DS
                    //query for the CC_Code__c code that matched the job type on the related work order
                    List<Cost_Centre__mdt> CostCentre = [SELECT id, CC_Code__c, Description__c
                                                         FROM Cost_Centre__mdt
                                                         WHERE Description__C = :workOrder[0].Job_Type__c
                                                         AND State__c = :Claim[0].State1__c
                                                         LIMIT 1];
                
                
                	//assign query results to a value for placing into the DS
               		Decimal CostCentreMDT = CostCentre[0].CC_Code__c;
                        
                    Double x = double.valueOf(CostCentreMDT);
                    integer CC = x.intValue();
                	
                	//Get Trade Part
                    if(CostCentre.size() > 0){
                    List<Trade__mdt> Trade = [SELECT CC_Code__c, description__c
                                              FROM Trade__mdt
                                              WHERE description__c = :workOrder[0].Work_Type_Name__c];
                    Decimal TradeMDT = Trade[0].CC_Code__c;
                    
                    Double z = double.valueOf(TradeMDT);
                    integer TradeCode = z.intValue();
                        
                    //create labour distribution set with found values
                    Map<String, Decimal> DistributionSetLabour = new Map<String, Decimal>();
                    DistributionSetLabour.put('CostCentre' , CC);
                    DistributionSetLabour.put('Trade' , TradeCode);
                    
                    String MaterialDisSet = ('11.' + CC + '.51400.' 
                                            + TradeCode + '.000');
                    
                    //assign created value to map and update apInvoice
                      List<AP_Invoice__c> apInvtoUpdate = [SELECT id, Status__c, GST_Material__c 
                                                           FROM AP_Invoice__c 
                                                           WHERE Id =:invoiceRecord.keySet()];
         			if(apInvtoUpdate != null && apInvtoUpdate[0].GST_Material__c != 0.00)
                         for (AP_Invoice__c apinv : apInvtoUpdate) 
                             apinv.Material_Distribution_Set__c = MaterialDisSet; 
                             update apInvtoUpdate;
                    }
                }
            }
        }
        catch(exception e){
            return;
        }
    }
    
    
    //generate GST Distribution Set
    public static void generateGSTDistribuitonSet(Map<ID,String> invoiceRecord){
        
        try{
        List<AP_Invoice__c> apInvoice = [SELECT id, Work_Order__c, Trade_Account__c
                                         FROM AP_Invoice__c
                                         WHERE Id =:invoiceRecord.keySet()
                                         LIMIT 1];
            system.debug(LoggingLevel.DEBUG, '***BMapInvoice: ' + apInvoice.size());
        //determine if work order is eligible for taxation
        
        //booleans representing conditions to be checked
        Boolean accountGST = false;
        Boolean woliGST = false;
        
        
        Account tradeAccount = [SELECT id, GST_Status__c 
                                FROM ACCOUNT 
                                WHERE Name = :apInvoice[0].Trade_Account__c];
        	system.debug(LoggingLevel.DEBUG, '***BMtradeAccount: ' + tradeAccount);
        
            //if GST_status is Active, gst must be calculated
            if (tradeAccount.GST_Status__c == 'Active' || tradeAccount.GST_Status__c == 'Yes')  {
                accountGST = true;
            }
        
        
        	//if account is GST chargeable, execute further code
        	if(accountGST == true){
            
            //place and woli's with a gst value above zero into a list
            List<WorkOrderLineItem> woli = [SELECT id, GST__c
                                            FROM WorkOrderLineItem
                                            WHERE workOrderId = :apInvoice[0].Work_Order__c
                                            AND (GST_Labour__c != 0.00 OR GST_Material__c != 0.00)];
            
            system.debug(LoggingLevel.DEBUG, '***BMwoli: ' + woli.size());
            //determine if any woli's have an above zero gst value, set bool
            if (woli.size() > 0){
                woliGST = true;
            }
            //woliGST is true if there is gst value in woli's
            if(woliGST == true){
                
                //query for work order related to invoice
                List<WorkOrder> workOrder = [SELECT id, job_Type__c, Claim__c, Work_Type_Name__c
                                             FROM WorkOrder
                                             WHERE Id =:apInvoice[0].Work_Order__c
                                             LIMIT 1];
                system.debug(LoggingLevel.DEBUG, '***BMworkOrder: ' + workOrder);
                //query for claim related to workOrder
                if(workOrder.size() > 0){
                List<Case> Claim = [SELECT id, State1__c
                                    FROM Case
                                    WHERE CaseNumber = :workOrder[0].Claim__c];
            	
            
                //get Cost Centre Part of DS
                //query for the CC_Code__c code that matched the job type on the related work order
                List<Cost_Centre__mdt> CostCentre = [SELECT id, CC_Code__c, Description__c
                                                     FROM Cost_Centre__mdt
                                                     WHERE Description__C = :workOrder[0].Job_Type__c
                                                     AND State__c = :Claim[0].State1__c
                                                     LIMIT 1];
                system.debug(logginglevel.DEBUG, 'BMCostCentre: ' + CostCentre);
                    
                //assign query results to a value for placing into the DS
                Decimal CostCentreMDT = CostCentre[0].CC_Code__c;
                    
                Double x = double.valueOf(CostCentreMDT);
                integer CC = x.intValue();
            
            	//Get Trade Part
                if(CostCentre.size() > 0){
                List<Trade__mdt> Trade = [SELECT CC_Code__c, description__c
                                          FROM Trade__mdt
                                          WHERE description__c = :workOrder[0].Work_Type_Name__c];
                Decimal TradeMDT = Trade[0].CC_Code__c;
                
                Double z = double.valueOf(TradeMDT);
                integer TradeCode = z.intValue();
                    
                //create labour distribution set with found values
                Map<String, Decimal> DistributionSetLabour = new Map<String, Decimal>();
                DistributionSetLabour.put('CostCentre' , CC);
                DistributionSetLabour.put('Trade' , TradeCode);
                
                String gstDisSet = ('11.' + CC + '.23200.' 
                                       + TradeCode + '.000');
                
                //assign created value to map and update apInvoice
                  List<AP_Invoice__c> apInvtoUpdate = [SELECT id, Status__c 
                                                       FROM AP_Invoice__c 
                                                       WHERE Id =:invoiceRecord.keySet()];
                            if(apInvtoUpdate != null)
                                 for (AP_Invoice__c apinv : apInvtoUpdate) 
                                     apinv.GST_Distribution_Set__c = gstDisSet; 
                                     update apInvtoUpdate;
                }
            }
        }
            
            }
        } 
        catch(exception e){
                return;
            }
    }
}