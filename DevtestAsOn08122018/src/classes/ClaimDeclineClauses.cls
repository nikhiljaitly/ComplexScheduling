/************************************************************************************************************
Name: ClaimDeclineClauses
=============================================================================================================
Purpose: Class which uses singleton approach to retieve Decline Clause data
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Vasu         16/08/2018        Created       For Mobile APP API
*************************************************************************************************************/

public with sharing class ClaimDeclineClauses {
    
    private static ClaimDeclineClauses instance = NULL;
    public Map<String, ClaimDeclineClause__mdt> declineClauseMap;
    
    private ClaimDeclineClauses() {
        //List of field describes
        declineClauseMap = new Map<String, ClaimDeclineClause__mdt>();
        for(ClaimDeclineClause__mdt amt : [Select MasterLabel, DeveloperName,Claim_Decline_Clause__c, Brand__c, Decline_Clause__c, Decline_Reason_Details__c
                                                       FROM ClaimDeclineClause__mdt]){
           declineClauseMap.put(amt.Claim_Decline_Clause__c, amt);
        }
       
    }
    /***************************************************************** 
    Purpose: Used to lazy load the custom metadata type - only initialize if it doesn't already exist 
    Parameters: none
    Returns: none
    Throws [Exceptions]: No                                                         
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL       Description 
    1.0            Mathew        23/10/2018      Created     For Mobile APP API  
    *******************************************************************/  
    
    public static ClaimDeclineClauses getInstance() {
        
        if(instance == NULL) instance = new ClaimDeclineClauses();
        
        return instance;
        
    }
    
}