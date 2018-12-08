/************************************************************************************************************
Name: hrCMFeeInvoiceCreationService
=============================================================================================================
Purpose: Class having re-usable logic for CM Fees invoice creation.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class hrCMFeeInvoiceCreationService {
    
/***************************************************************** 
Purpose: Method to create CM Fees Invoice records from ClaimJob.                                                       
Parameters: Map of ClaimJob ID & Status.
Returns: none
Throws [Exceptions]: None                                                          
History                                                             
--------                                                            
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module  
*******************************************************************/
public static void createInvoiceRecord(Map<ID,String> claimjobRecords) {
        system.debug('ClaimJob KeySet' + claimjobRecords.keySet());       

        try {
            List<Claim_Job__c> claimJobList = [Select ID,Name,Claim__c,Claim_Number__c,Claim_Type__c,Status__c
                                               FROM Claim_Job__c 
                                               WHERE Id =: claimjobRecords.keySet()
                                            ];
 
                Map<String,AR_Invoice__c> invMap = new Map<String,AR_Invoice__c>();
                Map<String,AR_SOW__c> invLIMap = new Map<String,AR_SOW__c>();                  
                Map<String,AR_Invoice__c> cmFeeInvMap = new Map<String,AR_Invoice__c>();                  
                
                for(Claim_Job__c cj : claimJobList) {                                       
                    AR_Invoice__c InvToCreate = new AR_Invoice__c();
                    InvToCreate.Claim_Job__c = cj.Id;
                    InvToCreate.Status__c = 'Submitted';
                    InvToCreate.Invoice_Type__c = 'CM Fees';
                    InvToCreate.Oracle_Process_Status__c = 'Pending';
                    InvToCreate.Generate_Invoice_Statement__c = true;                      
                    cmFeeInvMap.put(cj.Id,InvToCreate);
                    
                }
                if (cmFeeInvMap.size() > 0){
                    insert cmFeeInvMap.Values();                      
                }
                    
                //Get CMFee Product Details,Create Invoice Line Item & Associate to Invoice
                List<Product2> cmFeesLineItem = [SELECT Full_Product_Name__c,IsActive,Name,ProductCode 
                                                 FROM Product2 where ProductCode = 'CMFEES' and IsActive = true
                                                ];          			
                
                for(Product2 cmfli : cmFeesLineItem) {
                    AR_SOW__c InvLiItemToCreate = new AR_SOW__c();
                    InvLiItemToCreate.Scope_Of_Work__c = cmfli.Full_Product_Name__c;                     
                    
                    //Get newly created CMFee InvoiceId and associated to Line Item
                    for(String cmFeeInvId : cmFeeInvMap.keySet()){
                        InvLiItemToCreate.AR_Invoice__c = cmFeeInvMap.get(cmFeeInvId).Id;
                        system.debug('createdInvoice ' + InvLiItemToCreate.AR_Invoice__c);
                    }             
                    invLIMap.put(cmfli.Id,InvLiItemToCreate);
          
                }
                if (invLIMap.size() > 0){
                    insert invLIMap.Values();
                }

            //Update CMFeeInvCheckFlag in WO to restrict creation of more than one supplier invoice            
       /*     List<WorkOrder> wotoUpdate = [select id, CMFeeInvCheck__c from WorkOrder where Id =: workorderRecords.keySet()];
            if(wotoUpdate != null)
            { 
                for (WorkOrder woCmf : wotoUpdate)
                {
                    woCmf.CMFeeInvCheck__c = true;
                    update wotoUpdate;                            
                }
            }*/
			            
            
        }// try ends
        catch (System.QueryException se) {
        }
        finally {}
    }//createInvoiceRecord ends
}//hrCMFeeInvoiceCreationService ends