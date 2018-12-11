/***************************************************************** 
Purpose: Batch job to process instance of a PriceBookEntry object into the resulting 
update related Parent Product UnitPrice.
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          16/04/2018      Created      Home Repair Claim System  
*******************************************************************/
global class BatchPriceBookEntryProcess implements Database.Batchable<sObject> {
    
    /***************************************************************** 
    Purpose: Batch start method to fetch records from PriceBookEntry 
    Staging with status Pending.
    Parameters:None
    Returns: Query 
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          16/04/2018     Created  Home Repair Claim system 
    *******************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordTypeName= 'Repair Item';
        String query = 'SELECT Id,Pricebook2Id,Product2Id,Product2.Name,Product2.RecordType.Name FROM PriceBookEntry WHERE SystemModStamp = today and Product2.RecordType.Name=:recordTypeName and PriceBook2.isStandard=true';
        system.debug('query '+query);
        return Database.getQueryLocator(query);
    }
    /***************************************************************** 
    Purpose: Batch execute method to Update UnitPrice of Parent Record from Start method result
    Parameters:List<PriceBookEntry>
    Returns: none
    Throws [Exceptions]: DML                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          13/03/2018     Created  Home Repair Claim system 
    *******************************************************************/   
    global void execute(Database.BatchableContext BC, List<PriceBookEntry> scope) {
        system.debug('Entering List of PriceBookEntry : '+scope);
        HomeRepairUtil.updateUnitPrice(true,false,scope,false,null);
    }
    /***************************************************************** 
    Purpose: Batch finish method to Reschedule batch
    Parameters: Database.BatchableContext
    Returns: none
    Throws [Exceptions]: none
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          16/04/2018    Created  Home Repair Claim system 
    *******************************************************************/ 
    global void finish(Database.BatchableContext BC) {        
        
    }
}