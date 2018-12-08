<aura:application extends="force:slds">
    <!-- Create attribute to store lookup value as a sObject--> 
    <aura:attribute name="selectedPricebookEntryLookUpRecord" type="sObject" default="{}"/>
    <aura:attribute name="selectedWorkOrderLookUpRecord" type="sObject" default="{}"/>
    
    <c:HRPriceBookWkTypePagination objectAPIName="PricebookEntry" 
                         subHeadingFieldsAPI="ProductCode"
                         IconName="standard:pricebook" 
                         selectedRecord="{!v.selectedPricebookEntryLookUpRecord}" 
                         label="Product Name"/>
    <!-- here c: is org. namespace prefix-->
    
    <br/>

   
</aura:application>