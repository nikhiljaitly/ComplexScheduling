/************************************************************************************************************
Name: homerepairInvoiceCreationService
=============================================================================================================
Purpose: Class having re-usable logic for invoice creation.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class homerepairInvoiceCreationService {

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
        
        
        boolean rcti;
        for (WorkOrder r : workOrderList) 
            rcti = r.RCTI__c;           
        system.debug('RCTI' +' '+ rcti); 
        
           Integer LineItemCount;
            for (WorkOrder LnItm : workOrderList) 
                LineItemCount = LnItm.LineItemCount;
                system.debug('LineItemCount' +' '+ LineItemCount); 
          
          boolean DoNotInvoiceAPflag;
          for (WorkOrder DNIFlag : workOrderList) 
              DoNotInvoiceAPflag = DNIFlag.Do_Not_Invoice_AP__c; 
          system.debug('Do_Not_Invoice_AP__c' +' '+ DoNotInvoiceAPflag);
          
          boolean SupplierInvFlag;
          for (WorkOrder SUPINFlag : workOrderList) 
              SupplierInvFlag = SUPINFlag.SupplierInvCheck__c; 
          system.debug('SupplierInvFlag' +' '+ SupplierInvFlag);
          
          
          string WorkTypeId;
          for (WorkOrder wktypeid : workOrderList) 
              WorkTypeId = wktypeid.WorkTypeId; 
          system.debug('WorkTypeId' +' '+ WorkTypeId);
          
          string WorkTypeName;
          for (WorkOrder wktypename : workOrderList) 
              WorkTypeName = wktypename.Work_Type_Name__c; 
          system.debug('WorkTypeName' +' '+ WorkTypeName);
          
          boolean intResourceFlag;
          for (WorkOrder intres : workOrderList) 
              intResourceFlag = intres.Internal_Resource__c; 
          system.debug('Internal_Resource__c' +' '+ intResourceFlag);
          
          string invoiceType;
          for (WorkOrder invtype : workOrderList) 
              invoiceType = invtype.Invoice_Type__c; 
          system.debug('invoiceType' +' '+ invoiceType);
          
          string WkOrdrstatus;
          for (WorkOrder wostatus : workOrderList) 
              WkOrdrstatus = wostatus.Status;
          system.debug('WkOrdrstatus' +' '+ WkOrdrstatus);
          
          List<RecordType> supplierInvRecordType, customerInvRecordType, CMFeesInvRecordType;
          if(invoiceType == 'Standard Invoice')
             {
               supplierInvRecordType = [select Id from recordtype where name = 'Supplier'];
               customerInvRecordType = [select Id from recordtype where name = 'Customer'];
             }else
                 supplierInvRecordType = [select Id from recordtype where name = 'Supplier Credit Memo'];
                 customerInvRecordType = [select Id from recordtype where name = 'Customer Credit Memo'];
          
       //Create CMFees Invoice
          if(invoiceType == 'CM Fees' && (WkOrdrstatus == 'Work Order Assigned' || WkOrdrstatus == 'Closed'))
          {       
              //if(LineItemCount > 0 && DoNotInvoiceAPflag != true && WorkTypeName != 'Assessment' && intResourceFlag != true)
              if(LineItemCount > 0 && WorkTypeName != 'Assessment' && intResourceFlag != true)
              {  
                  //Check for Do Not invoice WOLI to set Invoice Progress
                  List<WorkOrderLineItem> WorkOrderLineItemList1 = [Select ID,Do_Not_Invoice__c                                         
                                                                    FROM WorkOrderLineItem 
                                                                    WHERE Id =: workorderRecords.keySet()
                                                                    AND Do_Not_Invoice__c = true
                                                                   ];
                  
                  Map<String,AP_Invoice__c> invMap = new Map<String,AP_Invoice__c>();
                  Map<String,AR_Invoice__c> cusInvMap = new Map<String,AR_Invoice__c>();                  
                  Map<String,String> cusInvMapAll = new Map<String,String>();
                  
                  
                  Map<AP_Invoice__c,List<string>> invMapCustomer = new Map<AP_Invoice__c,List<string>>();
                  Map<Id,List<WorkOrderLineItem>> workOrderLineItemMap = new Map<Id,List<WorkOrderLineItem>>();
                  
                  Map<String,String> workOrderIdToCaseIdMap  = new Map<String,String>();
                  Map<String,String> workOrderIdToJobTypeMap  = new Map<String,String>();
                  Map<String,String> workOrderIdToWorkTypeMap  = new Map<String,String>();
                  
                  CMFeesInvRecordType = [select Id from recordtype where name = 'CM Fees'];
                  string invProgress;
                  //  List<RecordType> supplierInvRecordType;
                  
                  for(WorkOrder wo : workOrderList) {
                      /*    if(WorkOrderLineItemList1.size() > 0)
                            invProgress = 'Progress Invoice';
                            else */
                            invProgress = 'Final Invoice'; 
                      
                      AR_Invoice__c InvToCreate = new AR_Invoice__c();
                      InvToCreate.Claim_Job__c = wo.Claim_Job__c;
                      InvToCreate.Status__c = 'Draft';
                      InvToCreate.Invoice_Type__c = 'CM Fees';                   
                      InvToCreate.Generate_Invoice_Statement__c = true; 
                      InvToCreate.Labour_ex_GST__c = wo.Total_Labour_Amount__c;
                      InvToCreate.Material_ex_GST__c = wo.Total_Material_Amount__c;
                      cusInvMap.put(wo.Id,InvToCreate);
                      
                      workOrderIdToCaseIdMap.put(wo.Id,wo.CaseId);
                      workOrderIdToJobTypeMap.put(wo.Id,wo.Job_Type__c);
                      workOrderIdToWorkTypeMap.put(wo.Id,wo.WorkTypeId);
                  }
                  if (cusInvMap.size() > 0){
                      insert cusInvMap.Values();                      
                  }

                  //Create Invoice Line Items & associate to Invoice
                  List<WorkOrderLineItem> workOrderLineItemList = [Select ID,WorkOrderId,Status,WorkTypeId,
                                                                   Quantity,StartDate,Subtotal,TotalPrice,UnitPrice,Invoice_Type__c,
                                                                   LineItemNumber,Room__c,Product2Id,Work_Item_Description__c,GST__c
                                                                   FROM WorkOrderLineItem  
                                                                   WHERE WorkOrderId =: workorderRecords.keySet()
                                                                   AND Cash_Settled__c != true // AND Do_Not_Invoice__c != true  (Commented on intro of Do_Not_Invoice_AR__c)                                                       
                                                                   AND Do_Not_Invoice_Prepay__c != true
                                                                  ];
                  
                 Map<String,AP_SOW__c> invLIMap = new Map<String,AP_SOW__c>();
                  
                  for(WorkOrderLineItem woli : workOrderLineItemList) {
                      AP_SOW__c InvLiItemToCreate = new AP_SOW__c();
                      InvLiItemToCreate.Scope_Of_Work__c = woli.Product_Description__c;
                      InvLiItemToCreate.Trade__c = woli.WorkTypeId;
                      InvLiItemToCreate.Quantity__c = woli.Quantity;
                      InvLiItemToCreate.UOM__c = woli.UOM__c;
                 
                      //getting the corresponding invoice
                      AP_Invoice__c createdInvoice = invMap.get(woli.WorkOrderId);
                      InvLiItemToCreate.AP_Invoice__c = createdInvoice.Id;
                      invLIMap.put(woli.Id,InvLiItemToCreate);
                      
                  }
                  if (invLIMap.size() > 0){
                      insert invLIMap.Values();
                  }

              }//WorkOrderList Size Ends 
          }//invoiceType Check Ends
          //CM Fees Invoice Creation Ends
  
 
//   If(rcti)
  //  {  
            
        Map<String,AP_Invoice__c> invMap = new Map<String,AP_Invoice__c>();
        Map<String,AR_Invoice__c> cusInvMap = new Map<String,AR_Invoice__c>();
        
        Map<String,String> cusInvMapAll = new Map<String,String>();
        
        
        Map<AP_Invoice__c,List<string>> invMapCustomer = new Map<AP_Invoice__c,List<string>>();
        Map<Id,List<WorkOrderLineItem>> workOrderLineItemMap = new Map<Id,List<WorkOrderLineItem>>();
        
        Map<String,String> workOrderIdToCaseIdMap  = new Map<String,String>();
        Map<String,String> workOrderIdToJobTypeMap  = new Map<String,String>();
        Map<String,String> workOrderIdToWorkTypeMap  = new Map<String,String>();
        
     //Create Vendor Invoice
      if(LineItemCount > 0 && DoNotInvoiceAPflag != true && WorkTypeName != 'Assessment' && intResourceFlag != true && invoiceType != 'CM Fees' && WkOrdrstatus == 'Closed' && SupplierInvFlag != true)
         {  
             //Check for Do Not invoice WOLI to set Invoice Progress
              List<WorkOrderLineItem> WorkOrderLineItemList1 = [Select ID,Do_Not_Invoice__c                                         
                                                                FROM WorkOrderLineItem 
                                                                WHERE Id =: workorderRecords.keySet()
                                                                AND Do_Not_Invoice__c = true
                                                               ];
             string invProgress;
           //  List<RecordType> supplierInvRecordType;
          
         for(WorkOrder wo : workOrderList) {
                if(WorkOrderLineItemList1.size() > 0)
                    invProgress = 'Progress Invoice';
                    else
                        invProgress = 'Final Invoice'; 
             
                    AP_Invoice__c InvToCreate = new AP_Invoice__c();
                    InvToCreate.Work_Order__c = wo.Id;
                    InvToCreate.Status__c = 'Draft';              
                    InvToCreate.Invoice_Description__c = wo.WorkOrderNumber + ' ' + '|' + ' ' + wo.Description;              
                    InvToCreate.Generate_Invoice_Statement__c = true;
                    InvToCreate.Labour_ex_GST__c = wo.Total_Labour_Amount__c;
                    InvToCreate.Material_ex_GST__c = wo.Total_Material_Amount__c;
                    
                    invMap.put(wo.Id,InvToCreate);
                    workOrderIdToCaseIdMap.put(wo.Id,wo.CaseId);
                    workOrderIdToJobTypeMap.put(wo.Id,wo.Job_Type__c);
                    workOrderIdToWorkTypeMap.put(wo.Id,wo.WorkTypeId);
        }
       if (invMap.size() > 0){
            insert invMap.Values();
        }
             
            
        //Create Invoice Line Items & associate to Invoice
        List<WorkOrderLineItem> workOrderLineItemList = [Select ID,WorkOrderId,Status,WorkTypeId,
                                                         Quantity,StartDate,Subtotal,TotalPrice,UnitPrice,
                                                         LineItemNumber,Room__c,Product2Id,Work_Item_Description__c,GST__c,
                                                         Invoice_Type__c
                                                         FROM WorkOrderLineItem  
                                                         WHERE WorkOrderId =: workorderRecords.keySet()
                                                         AND Cash_Settled__c != true // AND Do_Not_Invoice__c != true (commented on intro of Do_Not_Invoice_AR__c)                                                        
                                                         AND Do_Not_Invoice_Prepay__c != true
                                                        ];
        Map<String,AP_SOW__c> invLIMap = new Map<String,AP_SOW__c>();
        
           for(WorkOrderLineItem woli : workOrderLineItemList) {
                   AP_SOW__c InvLiItemToCreate = new AP_SOW__c();
                   InvLiItemToCreate.Scope_Of_Work__c = woli.Product_Description__c;
                   InvLiItemToCreate.Trade__c = woli.WorkTypeId;
                   InvLiItemToCreate.Quantity__c = woli.Quantity;
                   InvLiItemToCreate.UOM__c = woli.UOM__c;
                  
                   //getting the corresponding invoice
                   AP_Invoice__c createdInvoice = invMap.get(woli.WorkOrderId);
                   InvLiItemToCreate.AP_Invoice__c = createdInvoice.Id;
                   invLIMap.put(woli.Id,InvLiItemToCreate);
 
        }
        if (invLIMap.size() > 0){
            insert invLIMap.Values();
        }
      
     //Update SupplierInvCheckFlag in WO        
    
             List<WorkOrder> wotoUpdate = [select id, SupplierInvCheck__c from WorkOrder where Id =: workorderRecords.keySet()];
             if(wotoUpdate != null)
                 { 
                     for (WorkOrder woSup : wotoUpdate)
                         {
                            // if(woSup.SupplierInvCheck__c != false)
                           //  {
                                 woSup.SupplierInvCheck__c = true;
                                 wosup.Process_Builder_Update__c = true;
                                 update wotoUpdate;   
                             //  }
                        }
                 }  
     
    }//WorkOrderList Size Ends    
    
    // If(rcti) //Customer Invoice will not be created for Non-RCTI Account or RCTI flag is false
   //   {   
        If(WorkTypeName != 'Assessment' && intResourceFlag != true && invoiceType != 'CM Fees')
         {
        //Create Customer Invoice.
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
                                           Internal_Resource__c != true AND
                                           Invoice_Type__c != 'CM Fees'
                                           //AND LineItemCount > 0 No effect of excl or incl of WO w/o WOLIs. Can be ignored.
                                          ];
        } catch (System.QueryException se) {
        }
        
        system.debug('workOrderClaimListCustChecksize'+ workOrderClaimListCustCheck.size());
        
     if(workOrderClaimListCustCheck.size() == 0){        
        
        List<WorkOrder> workOrderClaimList=new List<WorkOrder>();
       try {
            workOrderClaimList = [select id,CaseId,WorkTypeId,WorkType.Name,TotalPrice,Claim_Job__c,Internal_Resource__c,Invoice_Type__c,
                                  (select id,WorkOrderId,WorkTypeId,WorkType.Name,Status,UnitPrice,TotalPrice,Quantity,Description,
                                   WO_Internal_Resource__c, Invoice_Type__c, Subtotal,Total_Amount_ex_GST__c,
                                   Labour_Cost__c, Material_Cost__c
                                   from WorkOrderLineItems where Cash_Settled__c != true // and Do_Not_Invoice__c != true (commented as Do_Not_Invoice_AR__c is checked now)
                                   and Do_Not_Invoice_AR__c != true and Do_Not_Invoice_Prepay__c != true and
                                   WO_Internal_Resource__c != true)
                                  from WorkOrder 
                                  where CaseId=:workOrderIdToCaseIdMap.Values() AND
                                  Job_Type__c=:workOrderIdToJobTypeMap.Values() AND
                                  Status =: 'Closed' AND
                                  Do_Not_Invoice_AR__c != true AND
                                  WorkType.Name != 'Assessment' AND
                                  Internal_Resource__c != true AND
                                  Invoice_Type__c != 'CM Fees'
                                  //AND LineItemCount > 0 Determines creation of Cust invoice when WO w/o WOLIs gets closed.Can be removed.
                                 ];
        } catch (System.QueryException se) {
           }
        
        Map<string,invWorkOrderWrapper> workOrderWrapperMap=new Map<string,invWorkOrderWrapper>();
        Map<string,WorkOrder> workOrderMap=new Map<string,WorkOrder>();        
        Map<string,List<invWorkOrderLineItemWrapper>> workOrderlineWrapperMap=new Map<string,List<invWorkOrderLineItemWrapper>>();        
              
        system.debug('workOrderClaimList :'+workOrderClaimList);
        
        for(WorkOrder wo : workOrderClaimList){            
            if(wo.WorkOrderLineItems.size() > 0){
                List<invWorkOrderLineItemWrapper> workOrderLineItemListInv=new List<invWorkOrderLineItemWrapper>();  
                for(WorkOrderLineItem woli : wo.WorkOrderLineItems){
                    system.debug('caseId:'+ workOrderIdToCaseIdMap.Values() + '--'+ woli.WorkType.Name + '--' + woli.Id);
                    if(workOrderlineWrapperMap.containsKey(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name)) {
                        if(workOrderIdToCaseIdMap.Values() != null){
                            workOrderLineItemListInv.addAll(workOrderlineWrapperMap.get(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name));                     
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
         
         //Calculate Total L&M Costs
         Decimal tempLabourSum = 0.00;
         Decimal tempMaterialSum = 0.00;
           for (string caToWkType : workOrderlineWrapperMap.keySet())
                {   
                 for (invWorkOrderLineItemWrapper cusWoliTotals : workOrderlineWrapperMap.get(caToWkType))
                    {
                      //  tempLabourSum += cusWoliTotals.LabourCost;
                       // tempMaterialSum += cusWoliTotals.MaterialCost;
                    }                    
                  }
         
                system.debug('tempLabourSum ' + tempLabourSum);
                system.debug('tempMaterialSum ' + tempMaterialSum);
         
        
         
         
        //Create Customer Invoice
        Map<String,AR_SOW__c> CustinvLIMap = new Map<String,AR_SOW__c>();
        
        system.debug('workOrderClaimListsize' + workOrderClaimList.size());
      
        //Filter for Single WorkOrder record
        List<WorkOrder> workOrderClaimListFiltered = workOrderClaimList.clone();
         List<WorkOrder> workOrderClaimListFinal=new List<WorkOrder>();
     /*   Integer j = 1;
        while (j == workOrderClaimListFiltered.size()-1)
            {
                workOrderClaimListFiltered.remove(j);
                
            } */
         
         string workOrderID;
         for (WorkOrder r : workOrderList) 
             workOrderID = r.Id;
         system.debug('workOrderID' +' '+ workOrderID);
         
         Integer j = 0;
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
         
       
        system.debug('BeforeFilterworkOrderClaimList' + workOrderClaimList);
        system.debug('AfterFilterworkOrderClaimList' + workOrderClaimListFiltered);
        
        //get all workorder to pass into workorder invoice junction object
        for(WorkOrder cuswoAll : workOrderClaimList) {
            //Invoice__c CusInvToCreateAll = new Invoice__c();
            //CusInvToCreateAll.Work_Order__c = cuswoAll.Id;
            cusInvMapAll.put(cuswoAll.Id, cuswoAll.Id);
        }
        
            //Get QueueID
            queuesobject que = [Select Id,QueueId from QueueSObject where Queue.Name = 'AR Invoice Queue' limit 1];
         
            //Create Customer Invoice
            for(WorkOrder cuswo : workOrderClaimListFiltered) {  
               // for (Integer i = workOrderClaimList.size() - 1;i > 0; --i){
                    AR_Invoice__c CusInvToCreate = new AR_Invoice__c();
                    CusInvToCreate.Claim_Job__c = cuswo.Claim_Job__c;
                    CusInvToCreate.Status__c = 'Draft';    
                    CusInvToCreate.Generate_Invoice_Statement__c = true;
                
                    CusInvToCreate.Labour_ex_GST__c = tempLabourSum; //To be replaced
                    CusInvToCreate.Material_ex_GST__c = tempMaterialSum; //To be replaced                
               //     CusInvToCreate.Labour_ex_GST__c = cuswo.Total_Labour_Amount__c; //To be replaced
               //     CusInvToCreate.Material_ex_GST__c = cuswo.Total_Material_Amount__c; //To be replaced
                
                //  CusInvToCreate.OwnerId = que.QueueId;    //check with kay on this               
                    cusInvMap.put(cuswo.Id,CusInvToCreate);
            //} 
          }
        
                  
        if (cusInvMap.size() > 0){
            insert cusInvMap.Values();
           // system.debug('InvoiceID' + cusInvMap.values());
           // system.debug('InvoiceIDKeySet' + cusInvMap.keySet());           
         }
        
                           
        for (String key : cusInvMap.keySet()) {
            system.debug('InvoiceIDKey' + cusInvMap.get(key).Id);                    
        }
        
        //invWorkOrderLineItemWrapper.add(cusInvMap.keySet().get(Id));
        //workOrderlineWrapperMap.put(workOrderIdToCaseIdMap.Values()+woli.WorkType.Name, workOrderLineItemListInv);
        
         //getting the corresponding invoice
                // system.debug('cuswoli' + cuswoli.WorkOrderId);
                 //system.debug('cuswoli WorkOrderId' + cusInvMap.get(cuswoli.WorkOrderId));
                 string cusInvoiceID;
                    for (String key : cusInvMap.keySet()) {
                        //system.debug('InvoiceIDKey' + cusInvMap.get(key).Id);
                        cusInvoiceID = cusInvMap.get(key).Id;
                    }
                        //Invoice__c createdCustInvoice = cusInvMap.get(cuswoli.WorkOrderId);
                       // InvLiItemToCreate.Ora_Invoice_No__c = createdCustInvoice.Id;
                      //  InvLiItemToCreate.Ora_Invoice_No__c = cusInvoiceID;
                       // CustinvLIMap.put(cuswoli.workOrderLineItemId,InvLiItemToCreate); 
        
                    string cusInvoiceType;
                     for (WorkOrder invtype : workOrderClaimList) 
                         cusInvoiceType = invtype.Invoice_Type__c; 
                     system.debug('cusInvoiceType' +' '+ cusInvoiceType); 
         
                /*   string custInvoiceType;
                    for (String key : cusInvMap.keySet()) {
                        //system.debug('InvoiceIDKey' + cusInvMap.get(key).Id);
                        custInvoiceType = cusInvMap.get(key).Invoice_Type__c;
                    } */       
            
       
        //Create Customer Invoice LineItems
        for (string caToWkType : workOrderlineWrapperMap.keySet())
            {
                for (invWorkOrderLineItemWrapper cuswoli : workOrderlineWrapperMap.get(caToWkType))
                {
                   // system.debug('TestWorkTypeId' + woli.WorkTypeId);
                   // system.debug('TestWorkTypeName' + woli.WorkTypeName);
                    AR_SOW__c InvLiItemToCreate = new AR_SOW__c();                    
                    InvLiItemToCreate.Scope_Of_Work__c = cuswoli.ProductDescription;
                    InvLiItemToCreate.Trade__c = cuswoli.WorkTypeId;
                    InvLiItemToCreate.Quantity__c = cuswoli.Quantity;
                    InvLiItemToCreate.UOM__c = cuswoli.uom;
                //}
            //}
                
                    CustinvLIMap.put(cuswoli.workOrderLineItemId,InvLiItemToCreate);
                      
                }
            }
            
            if (CustinvLIMap.size() > 0){
                insert CustinvLIMap.Values();
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
     }//WKType If Ends      
  //  }//RCTI If Ends 
      
    }// try ends
        catch (System.QueryException se) {
           }
        finally {}
  } 
    
}