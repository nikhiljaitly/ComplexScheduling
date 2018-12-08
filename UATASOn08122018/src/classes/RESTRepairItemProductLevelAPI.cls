/***************************************************************** 
Purpose: Retreives Product and respective claims                                                      
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          22/03/2018      Created      Home Repair Claim System  
*******************************************************************/   
@RestResource(urlMapping='/homerepair/api/v1/repairitemproductslevels/*')
 /***************************************************************** 
    Purpose: Get method to retrieve Product Levels corresponding Trade Items (WorkType)
    Parameters:None
    Returns: List of Trade Items 
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          19/04/2018     Created  Home Repair Claim system 
    *******************************************************************/
global with sharing class RESTRepairItemProductLevelAPI{  
    @HttpGet
    global static RESTRepairProductLevelResponseHandler  GET() {        
        // Initialise request context to get request parameters
        // and response handler to return results
        RestRequest req = RestContext.request;
        System.Debug(LoggingLevel.DEBUG, '***Request Context = ' + req);
        RestRepairProductLevelResponseHandler response = new  RestRepairProductLevelResponseHandler();
        List<Worktype> worktypeList=[select id, name,Main__c,Sort_Order__c,(SELECT Id, Name,UOM__c,ProductCode,Description,Level_1__c,Level_1_Description__c,Level_2__c,Level_2_Description__c,Level_3__c,Level_3_Description__c,Level_4__c,Level_4_Description__c,Level_5__c,Level_5_Description__c, Unit_Cost__c,QuantityUnitOfMeasure FROM Products__r where isActive=true) from Worktype
                                    where RecordType.Name = 'Repair Items' order by Sort_Order__c];
        Set<string> productIds=new Set<string>();
        
        for(Worktype wt:worktypeList){
            if (wt.Products__r.size() > 0) {
                for (Product2 pro: wt.Products__r) {
                    productIds.add(pro.Id);
                }
            }
        }
        
        //get state
        String state = req.params.get('state');
        string statePrBk = '%' + state; 
        
        system.debug('productIds : ' +productIds);

        Map<string,PricebookEntry> pricebookEntryMap = new Map<string,PricebookEntry>();

        
        Set<string> pbIds=new Set<string>();
        Map<string,string> pricebookIdMap = new Map<string,string>();
        Map<string,Pricebook2> pricebookMap = new Map<string,Pricebook2>();
        Map<string,List<RESTRepairItemProductPriceBookWrapper>> workOrderlineWrapperMap=new Map<string,List<RESTRepairItemProductPriceBookWrapper>>();
        
        string pbeSoql = 'Select Product2Id,Product2.Name,Name,UnitPrice, Labour_Price__c, Material_Price__c, PriceBook2.Name From PricebookEntry Where PriceBook2.isStandard=false and Product2Id IN:productIds and IsActive=true and Pricebook2.Name like:statePrBk';
        system.debug('pbeSoql ' + pbeSoql);
        List<PricebookEntry> pbeList = Database.query(pbeSoql);
        
        for(PricebookEntry pbe: pbeList){
            pricebookEntryMap.put(pbe.Product2Id,pbe);
            pbIds.add(pbe.PriceBook2Id);
            pricebookIdMap.put(pbe.PriceBook2Id,pbe.Product2Id);
        }
              
        //Query based on state
        string pbSoql = 'SELECT Id, Name, IsActive, IsArchived, Description,Labour_Price__c, Material_Price__c, State__c, Labour_TIME_mins__c FROM Pricebook2 Where Id IN:pbIds and IsActive=true and State__c=:state';
        system.debug('pbSoql ' + pbSoql);
        Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        system.debug('remainingRows' + remainingRows);
        List<Pricebook2> pbList = Database.query(pbSoql);
       
        for(Pricebook2 pb: pbList){
            pricebookMap.put(pricebookIdMap.get(pb.Id),pb);
            if(workOrderlineWrapperMap.containsKey(pricebookIdMap.get(pb.Id))){
                List<RESTRepairItemProductPriceBookWrapper> productPriceBookWrapperListTemp = workOrderlineWrapperMap.get(pricebookIdMap.get(pb.Id));
                productPriceBookWrapperListTemp.add(new RESTRepairItemProductPriceBookWrapper(pb));
                workOrderlineWrapperMap.put(pricebookIdMap.get(pb.Id), productPriceBookWrapperListTemp);
            }else{
                workOrderlineWrapperMap.put(pricebookIdMap.get(pb.Id), new List<RESTRepairItemProductPriceBookWrapper>{new RESTRepairItemProductPriceBookWrapper(pb)});
            }
        }
        
              
        
        List<RestRepairItemLevelWrapper> workTypeLevelsList=new List<RestRepairItemLevelWrapper>();
        List<RestRepairItemProductWrapper> restRepairItemProductWrapperList=new List<RestRepairItemProductWrapper>();
        List<RestRepairItemProductLevelWrapper> restRepairItemProductLevelWrapperList =new List<RestRepairItemProductLevelWrapper>();
        Set<string> workTypeLevelSet=new Set<string>();
        
        for(Worktype wt: worktypeList){
            if (wt.Products__r.size() > 0) {
                List<string> workLevel1List=new List<string>(); 
                List<string> workLevel2List=new List<string>();     
                List<string> workLevel3List=new List<string>();
                List<string> workLevel4List=new List<string>();
                List<string> workLevel5List=new List<string>();                
                for (Product2 pro: wt.Products__r) {
                    //List<RESTRepairItemProductPriceEntryWrapper> restRepairItemProductPriceEntryWrapperList=new List<RESTRepairItemProductPriceEntryWrapper>();
                    List<RESTRepairItemProductPriceBookWrapper> restRepairItemProductPriceBookWrapperList=new List<RESTRepairItemProductPriceBookWrapper>();
                    if(pricebookEntryMap.containsKey(pro.Id)){
                        string unitPrice = String.valueOf(pricebookEntryMap.get(pro.Id).UnitPrice);
                        restRepairItemProductPriceBookWrapperList=workOrderlineWrapperMap.get(pro.Id);
                        //restRepairItemProductPriceEntryWrapperList=workOrderlineWrapperMap.get(pro.Id);
                        restRepairItemProductWrapperList.add(new RestRepairItemProductWrapper(pro,unitPrice,wt.Name,pricebookEntryMap.get(pro.Id).Id,restRepairItemProductPriceBookWrapperList));
                    }else{
                        restRepairItemProductWrapperList.add(new RestRepairItemProductWrapper(pro,'',wt.Name,'',restRepairItemProductPriceBookWrapperList));
                    } 
                    if(!workLevel1List.contains(pro.Level_1_Description__c)){
                        workLevel1List.add(pro.Level_1_Description__c);
                    }
                    if(!workLevel2List.contains(pro.Level_2_Description__c)){
                        workLevel2List.add(pro.Level_2_Description__c);
                    }
                    if(!workLevel3List.contains(pro.Level_3_Description__c)){
                        workLevel3List.add(pro.Level_3_Description__c);
                    }
                    if(!workLevel4List.contains(pro.Level_4_Description__c)){
                        workLevel4List.add(pro.Level_4_Description__c);
                    }
                    if(!workLevel5List.contains(pro.Level_5_Description__c)){
                        workLevel5List.add(pro.Level_5_Description__c);
                    }                   
                }              
                workTypeLevelsList.add(new RestRepairItemLevelWrapper(wt,workLevel1List,workLevel2List,workLevel3List,workLevel4List,workLevel5List));
            }               
        }
        restRepairItemProductLevelWrapper restRepairItemProductLevelWrapper = new restRepairItemProductLevelWrapper(RestRepairItemProductWrapperList,workTypeLevelsList);
        if(workTypeLevelsList.size() > 0){
            system.debug(JSON.serialize(workTypeLevelsList));
            RestContext.response.addHeader('Content-Type', 'application/json');
            response.Status = 'OK';
            response.Message = 'Success';
            response.Data = restRepairItemProductLevelWrapper;
            System.debug('Serialised Response'+JSON.serialize(response));
            return response;
        } else {
            // no Trade Types Found
            response.Status = 'Error';
            response.ErrorCode = 'NO_RECORDS_FOUND';
            response.Message = 'No Trade Types found';
        }
        return response;
     
    }
}