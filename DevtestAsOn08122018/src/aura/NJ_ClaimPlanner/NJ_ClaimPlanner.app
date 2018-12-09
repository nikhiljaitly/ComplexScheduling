<aura:application controller="NJ_ClaimPlannerController" extends="force:slds" implements = "force:hasRecordId" >
    
    <aura:attribute name="recordId" type="String" default="5005D00000341dgQAA" />
    
    <aura:handler name="init" value="{!this}" action="{!c.handleInit}"/>
    <aura:handler event="c:SvcApptMgrScheduledEvent" action="{!c.handleSvcApptMgrScheduledEvent}"/>
    <aura:attribute name="claimInfo" type="NJ_ClaimPlannerController.ClaimPlannerInitInfo" />
    <aura:attribute type="Boolean" name="showError" />
    <aura:attribute type="String" name="errorTitle" />
    <aura:attribute type="String" name="errorMesg" />
    <aura:attribute type="Boolean" name="hasWorkOrder" />

    <lightning:overlayLibrary aura:id="overlayLib"/>
    <c:NJ_GenericToast toastType="error" displayToast="{!v.showError}" title="{!v.errorTitle}"  bodyMessage="{!v.errorMesg}" displayCrossIcon="true" />

    <div class="slds-p-around_small" >
        <div class="slds-page-header hr-page-header">
            <div class="slds-page-header__row">
                <div class="slds-page-header__col-title">
                    <div class="slds-media">
                        <div class="slds-media__figure">
                            <lightning:icon iconName="standard:service_appointment" size="medium" alternativeText="Claim Planner"/>
                        </div>
                        <div class="slds-media__body">
                            <h1 class="slds-text-heading_medium">Claim Service Appointment Manager</h1>
                        </div>
                    </div>
                    
                </div> 
            </div>
        </div> 
        <aura:if isTrue="{!v.hasWorkOrder}">
            <lightning:layout multipleRows="false">
                <lightning:layoutItem size="12" flexibility="auto" >
                     <c:NJ_HighlightPanel summaries="{!v.claimInfo.summaries}"  />
                </lightning:layoutItem>
            </lightning:layout>
            <lightning:layout multipleRows="false">
                <lightning:layoutItem padding="around-small" flexibility="auto"  >
                    <c:NJ_ClaimAppointments claimId="{!v.recordId}" />
                </lightning:layoutItem>
                <lightning:layoutItem padding="around-small" flexibility="auto" >
                    <c:HRGanttChartChild claimId="{!v.recordId}" />
                </lightning:layoutItem>   
                <lightning:layoutItem padding="around-small" flexibility="auto" >
                     <div style="max-width:350px;">
                        <c:NJ_ServiceAppointmentManager />
                     </div>
                </lightning:layoutItem>
            	
            </lightning:layout>
        </aura:if>
    </div>

</aura:application>