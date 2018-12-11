/************************************************************************************************************
Name: APInvoiceService
=============================================================================================================
Purpose: Class with re-usable methods which manages sharing access for Invoice__c.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public without sharing class APInvoiceService {
    public class myException extends Exception {}
    //generate Labour Distribution Set
    public static void generateLabourDistributionSet(List<AP_Invoice__c> apInvoiceRecord) {  
        try{  
            List<AP_Invoice__c> apInvoice = [SELECT id, Work_Order__c
                                             FROM AP_Invoice__c
                                             WHERE Id =:apInvoiceRecord[0].Id
                                             LIMIT 1];
            
            
            
            //query for work order related to invoice     
            List<WorkOrder> workOrder = [SELECT id, job_Type__c, Claim__c, Work_Type_Name__c,Process_Builder_Update__c
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
                    if(Trade.size() > 0){
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
                                                             WHERE Id =:apInvoiceRecord[0].Id];
                        system.debug('***apInvtoUpdate Labour: ' + apInvtoUpdate[0].GST_Labour__c);
                        if(apInvtoUpdate != null && apInvtoUpdate[0].GST_Labour__c != 0.00)
                            for (AP_Invoice__c apinv : apInvtoUpdate) 
                            apinv.Labour_Distribution_Set__c = LabourDisSet; 
                        update apInvtoUpdate;
                    }//TradeCheck                   
                }//CostCentreCheck       
            }//WkOrderCheck
        }
        catch(exception e){
            //return;
            throw new myException('Distribution Sets cannot be generated - Trigger', e);
        }       
    }
}