/************************************************************************************************************
Name: AssessmentItemConfig
=============================================================================================================
Purpose: Class which uses singleton approach to retieve report item config metadata.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Vasu         16/08/2018        Created       For Mobile APP API
*************************************************************************************************************/

public with sharing class AssessmentItemCaseConfig {
    
    private static AssessmentItemCaseConfig instance = NULL;
    public Map<String, ClaimDeclineClause__mdt> mobileReportItemsMap;
    
    private AssessmentItemCaseConfig() {
        //List of field describes
        mobileReportItemsMap = new Map<String, ClaimDeclineClause__mdt>();
        for(ClaimDeclineClause__mdt amt : [Select MasterLabel, DeveloperName,Claim_Decline_Clause__c, Brand__c, Decline_Clause__c, Decline_Reason_Details__c
                                                       FROM ClaimDeclineClause__mdt]){
           mobileReportItemsMap.put(amt.Claim_Decline_Clause__c, amt);
        }
        //system.debug('mobileReportItemsMap'+mobileReportItemsMap);        
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
    
    public static AssessmentItemCaseConfig getInstance() {
        
        if(instance == NULL) instance = new AssessmentItemCaseConfig();
        
        return instance;
        
    }
    
}