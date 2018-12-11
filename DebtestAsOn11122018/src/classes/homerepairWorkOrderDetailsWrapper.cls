/************************************************************************************************************
Name: homerepairWorkOrderDetailsWrapper
=============================================================================================================
Purpose: Apex Class which act as a wrapper object type for holding WorkOrder transaction details.
This class has invocable variables whose values will be set by the process builder.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xxx         		 xx        		Created      HomeRepair - Finance Module
*************************************************************************************************************/
public class homerepairWorkOrderDetailsWrapper {
    @InvocableVariable(required=true)
    public String workorderId;
    @InvocableVariable(required=true)
    public String workorderStatus;
   /* @InvocableVariable(required=true)
    public String CaseId;*/
}