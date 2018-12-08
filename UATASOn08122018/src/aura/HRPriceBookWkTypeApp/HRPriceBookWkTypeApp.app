<aura:application extends="force:slds">
    <!-- Create attribute to store lookup value as a sObject--> 
    <aura:attribute name="selectedPricebookEntryLookUpRecord" type="sObject" default="{}"/>
    <aura:attribute name="selectedWorkOrderLookUpRecord" type="sObject" default="{}"/>
    
    <c:HRPriceBookWkType objectAPIName="PricebookEntry" 
                         subHeadingFieldsAPI="ProductCode"
                         IconName="standard:pricebook" 
                         selectedRecord="{!v.selectedPricebookEntryLookUpRecord}" 
                         label="Product Name"/>
    <!-- here c: is org. namespace prefix-->
    
    <br/>
    
    <c:HRCreateWkOrderLineItem/>
    
    <br/>
    <!--   <c:HRWorkOrderLookUp objectAPIName="WorkOrder" 
                         subHeadingFieldsAPI="WorkOrderNumber"
                         IconName="standard:account" 
                         selectedRecord="{!v.selectedWorkOrderLookUpRecord}" 
                         label="Work Order"/>
    <br/> !-->   
    
    <c:LtngLookUpNewButton/>
</aura:application>