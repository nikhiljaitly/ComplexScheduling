/************************************************************************************************************
Name: AssessmentItemConfig
=============================================================================================================
Purpose: Class which uses singleton approach to retieve report item config metadata.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Mathew         23/02/2017        Created       For Mobile APP API
*************************************************************************************************************/

public with sharing class AssessmentItemConfig {
    
    private static AssessmentItemConfig instance = NULL;
    public Map<String, AssessmentReportItemsForMobile__mdt> mobileReportItemsMap;
    public Map<String, Schema.DescribeFieldResult> fieldNameToDescribeMap;
    public List<String> reportItemTypeValuesList= new List<String>();
    public Map<String,List<String>> selectFieldToValues= new Map<String,List<String>> ();
    public Map<String, String>itemCodeToProdIdMap;
    
    private AssessmentItemConfig() {
        
        //List of field describes
        List<String> pickValues;
        List<String>productCodes = new List <string> ();
        mobileReportItemsMap = new Map<String, AssessmentReportItemsForMobile__mdt>();
        itemCodeToProdIdMap = new Map<String, String>();
        
        List<Schema.DescribeFieldResult> describes = new List<Schema.DescribeFieldResult>();
        fieldNameToDescribeMap = new Map<String, Schema.DescribeFieldResult>();
        //Schema.DescribeFieldResult describe;
        List<Schema.FieldSetMember> selectOptionfields = 
            Schema.SObjectType.Case.fieldSets.AssessmentReportSelectOptions.getFields();
        List<Schema.FieldSetMember> assessmentReportItemfields = 
            Schema.SObjectType.Case.fieldSets.AssessmentReportItems.getFields();
        string fieldName; 
        for(Schema.FieldSetMember fld : selectOptionfields){
            fieldName = fld.getFieldPath();
            pickValues = new List<String>();
            Schema.DescribeFieldResult describe = Case.sObjectType.getDescribe().fields.getMap().get(fieldName).getDescribe();
            List<Schema.PicklistEntry> ple = describe.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickValues.add(pickListVal.getLabel());
            }
            selectFieldToValues.put(fieldName,pickValues);
            
        }
        
        for(Schema.FieldSetMember fld : assessmentReportItemfields){
            fieldName = fld.getFieldPath();
            fieldNameToDescribeMap.put(fieldName, Case.sObjectType.getDescribe().fields.getMap().get(fieldName).getDescribe());
        }
        
        for(AssessmentReportItemsForMobile__mdt amt : [Select MasterLabel, DeveloperName, Item_Code__c, ItemDescription__c, Type__c
                                                       FROM AssessmentReportItemsForMobile__mdt]){
                                                           productCodes.add(amt.Item_Code__c);
                                                           mobileReportItemsMap.put(amt.MasterLabel, amt);
                                                       }
        
        if(!productCodes.IsEmpty()){
            for(Product2 prod : [Select Id, work_code__c from product2 where work_code__c IN : productCodes]){
                itemCodeToProdIdMap.put(prod.work_code__c, prod.Id);
            }
            
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
    public static AssessmentItemConfig getInstance() {
        
        if(instance == NULL) instance = new AssessmentItemConfig();
        
        return instance;
        
    }
    
}