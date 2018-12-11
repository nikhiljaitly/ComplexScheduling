/************************************************************************************************************
Name: homeRepairCMFeeClaimJobDetailsWrapper
=============================================================================================================
Purpose: Apex Class which act as a wrapper object type for holding ClaimJob transaction details.
This class has invocable variables whose values will be set by the process builder.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xxx         		 xx        		Created      HomeRepair - Finance Module
*************************************************************************************************************/
public class homeRepairCMFeeClaimJobDetailsWrapper {
    @InvocableVariable(required=true)
    public String claimjobId;
    @InvocableVariable(required=true)
    public String claimjobStatus;
   /* @InvocableVariable(required=true)
    public String CaseId;*/
}