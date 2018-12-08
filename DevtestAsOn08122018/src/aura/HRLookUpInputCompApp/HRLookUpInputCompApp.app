<aura:application extends="force:slds">
    <ui:scrollerWrapper class="scrollerSize">
        <div aura:id='sfdcDiv' class="sWrapTest">  
            <c:HRLookUpInputComp object="PricebookEntry" lookupField="Product2Id" selectedRecordId="entityId" />
        </div>
    </ui:scrollerWrapper>      
</aura:application>