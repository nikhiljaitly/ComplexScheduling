/************************************************************************************************************
Name: homeRepairCustomerInvoiceCreationService
=============================================================================================================
Purpose: Class having re-usable logic for invoice creation.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class homeRepairCustomerInvoiceCreationService {

    /***************************************************************** 
    Purpose: Method to create Invoice records from WorkOrder.                                                       
    Parameters: Map of Work Order Number & Status.
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
   VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
    1.0        xx                xx                 xx       HomeRepair - Finance Module  
    *******************************************************************/
    public static void createInvoiceRecord(Map<ID,String> workorderRecords) {
        system.debug('WorkOrder KeySet' + workorderRecords.keySet());       
        List<WorkOrder_Invoice__c> workOrderInvoicesToInsert = new List <WorkOrder_Invoice__c>();
        List<WorkOrder_Invoice__c> workOrderInvoicesToInsertCust = new List <WorkOrder_Invoice__c>();
      try {
            List<WorkOrder> workOrderList = [Select ID,WorkOrderNumber,CaseId,Claim_Job__c,WorkTypeId,Job_Type__c,RCTI__c,
                                             Description,LineItemCount,Do_Not_Invoice_AP__c,Work_Type_Name__c,Internal_Resource__c,
                                             Invoice_Type__c,Status, SupplierInvCheck__c
                                             FROM WorkOrder 
                                             WHERE Id =: workorderRecords.keySet()
                                             ];
            
            
              boolean rcti,SupplierInvFlag,DoNotInvoiceAPflag,intResourceFlag;
              Integer LineItemCount;
              string WorkTypeId,WorkTypeName,invoiceType,WkOrdrstatus,workOrderID;
              
                  for (WorkOrder r : workOrderList)
                  {
                      rcti = r.RCTI__c;
                      LineItemCount = r.LineItemCount;
                      DoNotInvoiceAPflag = r.Do_Not_Invoice_AP__c;
                      SupplierInvFlag = r.SupplierInvCheck__c;
                      WorkTypeId = r.WorkTypeId;
                      WorkTypeName = r.Work_Type_Name__c; 
                      intResourceFlag = r.Internal_Resource__c; 
                      invoiceType = r.Invoice_Type__c; 
                      WkOrdrstatus = r.Status;
                      workOrderID = r.Id;
                  }
                  
                
                  Map<String,AR_Invoice__c> cusInvMap = new Map<String,AR_Invoice__c>();                  
                  Map<String,String> cusInvMapAll = new Map<String,String>();
                  
                  
                  Map<AP_Invoice__c,List<string>> invMapCustomer = new Map<AP_Invoice__c,List<string>>();
                  Map<Id,List<WorkOrderLineItem>> workOrderLineItemMap = new Map<Id,List<WorkOrderLineItem>>();
                  
                  Map<String,String> workOrderIdToCaseIdMap  = new Map<String,String>();
                  Map<String,String> workOrderIdToJobTypeMap  = new Map<String,String>();
                  Map<String,String> workOrderIdToWorkTypeMap  = new Map<String,String>();
      
              
            //Check for other WorkOrder associated to this WO's Claim.
            
              //Cases where No WOLIs exists in Supplier WO, but still wanted to create customer invoices with other WOs.
                for(WorkOrder wo : workOrderList) {
                        workOrderIdToCaseIdMap.put(wo.Id,wo.CaseId);
                        workOrderIdToJobTypeMap.put(wo.Id,wo.Job_Type__c);
                        workOrderIdToWorkTypeMap.put(wo.Id,wo.WorkTypeId);
                     }
            system.debug('workOrderIdToCaseIdMap.Values' +  workOrderIdToCaseIdMap.Values());
            system.debug('workOrderIdToCaseIdMap.keySet()' +  workOrderIdToCaseIdMap.keySet());
            
            List<WorkOrder> workOrderClaimListCustCheck=new List<WorkOrder>();
            try {
                workOrderClaimListCustCheck = [select id,CaseId,WorkTypeId,WorkType.Name,Job_Type__c,Status,TotalPrice,
                                               Claim_Job__c,Internal_Resource__c, Invoice_Type__c
                                               from WorkOrder 
                                               where CaseId=:workOrderIdToCaseIdMap.Values() AND 
                                               Job_Type__c=:workOrderIdToJobTypeMap.Values() AND
                                               Status != 'Closed' AND
                                               Do_Not_Invoice_AR__c != true AND
                                               WorkType.Name != 'Assessment' AND
                                               Internal_Resource__c != true //AND
                                             //  Invoice_Type__c != 'Credit Memo'
                                               //AND LineItemCount > 0 No effect of excl or incl of WO w/o WOLIs. Can be ignored.
                                              ];
            } catch (System.QueryException se) {
            }
            
            system.debug('workOrderClaimListCustChecksize'+ workOrderClaimListCustCheck.size());
         
         //If Zero then all the WO under that CJ is in closed status, then proceed with Customer Invoice creation.   
         if(workOrderClaimListCustCheck.size() == 0){        
            
            List<WorkOrder> workOrderClaimList=new List<WorkOrder>();
           try {
                workOrderClaimList = [select id,CaseId,WorkTypeId,WorkType.Name,TotalPrice,Claim_Job__c,Internal_Resource__c,Invoice_Type__c,
                                      (select id,WorkOrderId,WorkTypeId,WorkType.Name,Status,UnitPrice,TotalPrice,Quantity,Description,Total_inc_GST__c,
                                       Work_Order_Work_Type__c,WO_Internal_Resource__c, Invoice_Type__c, Subtotal,Total_Amount_ex_GST__c,
                                       Labour_Amount__c ,Material_Amount__c,Product_Description__c,UOM__c
                                       from WorkOrderLineItems where Cash_Settled__c != true // and Do_Not_Invoice__c != true (commented as Do_Not_Invoice_AR__c is checked now)
                                       and Do_Not_Invoice_AR__c != true and Do_Not_Invoice_Prepay_AR__c != true and
                                       Work_Order_Work_Type__c != 'Assessment' and WO_Internal_Resource__c != true and
                                       Product_Code__c != 'VAR' and Product_Code__c != 'PREPAY'
                                       )
                                      from WorkOrder 
                                      where CaseId=:workOrderIdToCaseIdMap.Values() AND
                                      Job_Type__c=:workOrderIdToJobTypeMap.Values() AND
                                      Status = 'Closed' AND
                                      Do_Not_Invoice_AR__c != true AND
                                      WorkType.Name != 'Assessment' AND
                                      Internal_Resource__c != true //AND
                                   // Invoice_Type__c != 'Credit Memo'
                                   // AND LineItemCount > 0 Determines creation of Cust invoice when WO w/o WOLIs gets closed.Can be removed.
                                     ];
            } catch (System.QueryException se) {
               }
            
            Map<string,invWorkOrderWrapper> workOrderWrapperMap=new Map<string,invWorkOrderWrapper>();
            Map<string,WorkOrder> workOrderMap=new Map<string,WorkOrder>();        
            Map<string,List<invWorkOrderLineItemWrapper>> workOrderlineWrapperMap=new Map<string,List<invWorkOrderLineItemWrapper>>();        
            
            system.debug('workOrderClaimList :'+workOrderClaimList);
             
     
            for(WorkOrder wo : workOrderClaimList){            
                if(wo.WorkOrderLineItems.size() > 0){
                    Set<invWorkOrderLineItemWrapper> invWorkOrderLineItemWrapperSet = new Set<invWorkOrderLineItemWrapper>();
                    List<invWorkOrderLineItemWrapper> workOrderLineItemListInv=new List<invWorkOrderLineItemWrapper>();  
                    for(WorkOrderLineItem woli : wo.WorkOrderLineItems){
                        system.debug('caseId:'+ workOrderIdToCaseIdMap.Values() + '--'+ woli.WorkType.Name + '--' + woli.Id);
                        if(workOrderlineWrapperMap.containsKey(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name)) {
                            if(workOrderIdToCaseIdMap.Values() != null){                             
                             // workOrderLineItemListInv.addAll(workOrderlineWrapperMap.get(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name));  //Commented to avoid duplicate woli's                   
                                invWorkOrderLineItemWrapperSet.addAll(workOrderlineWrapperMap.get(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name));
                                workOrderLineItemListInv.addAll(invWorkOrderLineItemWrapperSet);                             
                                workOrderLineItemListInv.add(new invWorkOrderLineItemWrapper(woli));
                                workOrderlineWrapperMap.put(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name, workOrderLineItemListInv);
                            }                        
                        }else{
                            workOrderlineWrapperMap.put(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name, new List<invWorkOrderLineItemWrapper>{new invWorkOrderLineItemWrapper(woli)});
                        }
                        workOrderMap.put(wo.id,wo); 
                    }
                }
            }
             
             // Calculate Total L&M Costs
             Decimal tempLabourSum = 0.00; Decimal tempMaterialSum = 0.00;
             Decimal tempCreditMemoLabourSum = 0.00; Decimal tempCreditMemoMaterialSum = 0.00;
             Decimal tempTotalLabour = 0.00; Decimal tempTotalMaterial = 0.00;                             
             
             Set<invWorkOrderLineItemWrapper> cusWoliTotalsFiltered = new Set<invWorkOrderLineItemWrapper>();       
                   
             for (string caToWkType : workOrderlineWrapperMap.keySet())
                 {   
                     for (invWorkOrderLineItemWrapper cusWoliTotals : workOrderlineWrapperMap.get(caToWkType))
                         {
                            cusWoliTotalsFiltered.add(cusWoliTotals); //Removes duplicate WOLIs.
                         }
                 }
             
             
             for (invWorkOrderLineItemWrapper wolisToTotal : cusWoliTotalsFiltered) {
                  System.debug('wolisToTotalKan:  ' + wolisToTotal);
                            
                        if (wolisToTotal.InvoiceType == 'Credit Memo') {
                                 tempCreditMemoLabourSum += wolisToTotal.LabourAmount;
                                 tempCreditMemoMaterialSum += wolisToTotal.MaterialAmount;                              
                                 
                             }
                             
                             if (wolisToTotal.InvoiceType != 'Credit Memo') {
                                 tempLabourSum += wolisToTotal.LabourAmount;
                                 tempMaterialSum += wolisToTotal.MaterialAmount;                              
                                 
                             } 

             }                     
 
             				
             tempTotalLabour = tempLabourSum - tempCreditMemoLabourSum;
             tempTotalMaterial = tempMaterialSum - tempCreditMemoMaterialSum;
             
             system.debug('tempLabourSum ' + tempLabourSum);
             system.debug('tempMaterialSum ' + tempMaterialSum);
             system.debug('tempCreditMemoLabourSum ' + tempCreditMemoLabourSum);
             system.debug('tempCreditMemoMaterialSum ' + tempCreditMemoMaterialSum);                
             system.debug('tempTotalLabour ' + tempTotalLabour);
             system.debug('tempTotalMaterial ' + tempTotalMaterial);
  
            //Create Customer Invoice
            Map<String,AR_SOW__c> CustinvLIMap = new Map<String,AR_SOW__c>();
            
            system.debug('workOrderClaimListsize' + workOrderClaimList.size());
          
            //Filter for Single WorkOrder record
            List<WorkOrder> workOrderClaimListFiltered = workOrderClaimList.clone();
             List<WorkOrder> workOrderClaimListFinal=new List<WorkOrder>();
         
             Integer j = 0;
             if(workOrderClaimList.size() > 1)
             {
                 while (j < workOrderClaimListFiltered.size())
                 {
                     if(workOrderClaimListFiltered.get(j).Id != workOrderID)
                     {
                         workOrderClaimListFiltered.remove(j);
                     }else
                     {
                         j++;
                     }
                 }
             }else{
                 workOrderClaimListFiltered = workOrderClaimList.clone();
             }     
             
           
            system.debug('BeforeFilterworkOrderClaimList' + workOrderClaimList);
            system.debug('AfterFilterworkOrderClaimList' + workOrderClaimListFiltered);
            
            
                //Get QueueID
                queuesobject que = [Select Id,QueueId from QueueSObject where Queue.Name = 'AR Invoice Queue' limit 1];
             
                //Create Customer Invoice record
                for(WorkOrder cuswo : workOrderClaimListFiltered) {                    
                        AR_Invoice__c CusInvToCreate = new AR_Invoice__c();
                        CusInvToCreate.Claim_Job__c = cuswo.Claim_Job__c;
                        CusInvToCreate.Status__c = 'Submitted';
                    	CusInvToCreate.Invoice_Type__c = 'Customer';
                        CusInvToCreate.Generate_Invoice_Statement__c = true;                    
                        CusInvToCreate.Labour_ex_GST__c = tempTotalLabour; 
                        CusInvToCreate.Material_ex_GST__c = tempTotalMaterial;                    	
     
                    //	CusInvToCreate.OwnerId = que.QueueId;    //Cannot owner due to MD relationship with Claimjob.         	
                        cusInvMap.put(cuswo.Id,CusInvToCreate);                
              }
            
                      
            if (cusInvMap.size() > 0){
                insert cusInvMap.Values();
                     
             }
            
             string cusInvoiceID;
             for (String key : cusInvMap.keySet()) {
                  cusInvoiceID = cusInvMap.get(key).Id;
             }
                            
           
            //Create Customer Invoice LineItems
            for (string caToWkType : workOrderlineWrapperMap.keySet())
                {
                    for (invWorkOrderLineItemWrapper cuswoli : workOrderlineWrapperMap.get(caToWkType))
                    {              
                        AR_SOW__c InvLiItemToCreate = new AR_SOW__c();
                        InvLiItemToCreate.AR_Invoice__c = cusInvoiceID;
                        InvLiItemToCreate.Scope_Of_Work__c = cuswoli.ProductDescription;
                        InvLiItemToCreate.Trade__c = cuswoli.WorkTypeId;
                        InvLiItemToCreate.Quantity__c = cuswoli.Quantity;
                        InvLiItemToCreate.UOM__c = cuswoli.uom;
                            
                        CustinvLIMap.put(cuswoli.workOrderLineItemId,InvLiItemToCreate);
                          
                    }
                }
                
                if (CustinvLIMap.size() > 0){
                    insert CustinvLIMap.Values();
                } 
                
             

             //Update DoNotInvoiceARFlag in WO to avoid including in subsequent AR Invoices.
             for (string caToWkType : workOrderlineWrapperMap.keySet())
             {
                 for (invWorkOrderLineItemWrapper cuswoliDoNotInvAR : workOrderlineWrapperMap.get(caToWkType))
                 { 
                     if(cuswoliDoNotInvAR.WorkOrderId != null)
                     { 
                         List<WorkOrder> wotoUpdateDoNotInvAR = [select id, Do_Not_Invoice_AR__c, D_C_CustInv_Create__c from WorkOrder where Id =: cuswoliDoNotInvAR.WorkOrderId];                              
                         for (WorkOrder woDoNotInvAr : wotoUpdateDoNotInvAR)
                         {
                             woDoNotInvAr.Do_Not_Invoice_AR__c = true;
                             woDoNotInvAr.AR_Invoice_Created_Flag__c = true;                             
                         }
                         update wotoUpdateDoNotInvAR;                                	
                     }
                     
                 }
             } 
             
             
             //Update RecordLockFlag in WO to restrict WO modifications once closed.
             List<WorkOrder> wotoUpdate = [select id, RecordLocked__c from WorkOrder where Id =: workorderRecords.keySet()];
             if(wotoUpdate != null)
             { 
                 for (WorkOrder woSup : wotoUpdate)
                 {
                     woSup.RecordLocked__c = true; 
                     update wotoUpdate;                            
                 }
             }  

             system.debug('CustInvoiceMap :'+cusInvMapAll.Values());
             system.debug('CustInvListMap :'+CustinvLIMap.Values());
      
            system.debug('workOrderWrapperMap :'+workOrderWrapperMap);
            system.debug('workOrderWrapperMap keyset:'+ workOrderWrapperMap.keyset());
            system.debug('workOrderWrapperMap values:'+ workOrderWrapperMap.values());
            
            system.debug('workOrderMap :'+workOrderMap);
            system.debug('workOrderMap keyset:'+workOrderMap.keyset());
            system.debug('workOrderMap values:'+workOrderMap.values());
         
            system.debug('workOrderlineWrapperMap :'+workOrderlineWrapperMap);
            system.debug('workOrderlineWrapperMap keyset:'+ workOrderlineWrapperMap.keyset());
            system.debug('workOrderlineWrapperMap values:'+ workOrderlineWrapperMap.values());
          
         }//workOrderClaimListCustCheck.size if Ends       
    }// try ends
        catch (System.QueryException se) {
        }
        finally {}       
        
  } 
    
}