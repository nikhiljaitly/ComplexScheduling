<aura:application description="LookupFilteredApp" extends="force:slds">

    <!-- with Filter -->
    <c:HRLookupFiltered fieldLabel="PricebookEntry" objectAPIName="PricebookEntry"
            subHeadingFieldsAPI="Product2Id,ProductCode"
              placeholder="Search Products"
              filter="WorkType__c='Renderer'"/>

    <!-- without Filter -->
    <c:HRLookupFiltered fieldLabel="PricebookEntry" objectAPIName="PricebookEntry"
              subHeadingFieldsAPI="Product2Id,ProductCode"
              placeholder="Search Products"/>

</aura:application>