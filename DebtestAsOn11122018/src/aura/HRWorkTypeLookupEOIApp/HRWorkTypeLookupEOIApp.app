<aura:application extends="force:slds">
    <!-- Create attribute to store lookup value as a sObject--> 
    <aura:attribute name="selectedWorktypeEntryLookUpRecord" type="sObject" default="{}"/>
    
 <!--   <c:HRWorkTypeLookupEOI objectAPIName="WorkType" 
                           subHeadingFieldsAPI="Name"
                           IconName="standard:work_type" 
                           selectedRecord="{!v.selectedWorktypeEntryLookUpRecord}" 
                           label="WorkType Name"/> !-->
    
    <c:HRCreateTradeType />
  <!--  <c:HRTradeTypeTableView /> !-->
    <c:sampleFileUpload />  
    
</aura:application>