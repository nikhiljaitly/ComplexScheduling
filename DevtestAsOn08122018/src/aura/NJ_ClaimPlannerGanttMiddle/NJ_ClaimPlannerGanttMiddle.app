<aura:application controller="NJ_ClaimPlannerController" extends="force:slds" implements = "force:hasRecordId" >
    
    <aura:attribute name="recordId" type="String" default="5005D00000342DSQAY" />
    
    <aura:handler name="init" value="{!this}" action="{!c.handleInit}"/>
    <aura:handler event="c:SvcApptMgrScheduledEvent" action="{!c.handleSvcApptMgrScheduledEvent}"/>

    <aura:attribute name="claimInfo" type="NJ_ClaimPlannerController.ClaimPlannerInitInfo" />
    <lightning:overlayLibrary aura:id="overlayLib"/>
    
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
        <lightning:layout multipleRows="true">
            <lightning:layoutItem size="12" flexibility="auto" >
                 <c:NJ_HighlightPanel summaries="{!v.claimInfo.summaries}"  />
            </lightning:layoutItem>
            
            <lightning:layoutItem size="5" padding="around-small" flexibility="auto"  >
                <div class="page-section page-left" style="text-align:left" size="50%">
                    <c:NJ_ClaimAppointments claimId="{!v.recordId}" />
                </div>
            </lightning:layoutItem>
            
                  <lightning:layoutItem size="5" padding="around-small" flexibility="auto" >
                        <div class="page-section page-right">
                            <c:NJ_ServiceAppointmentManager />
                        </div>
            </lightning:layoutItem>

        </lightning:layout>
        
        <lightning:layout>
        <lightning:layoutItem size="11" padding="around-small" flexibility="auto" >
                <div class="page-section page-main">
                    <c:HRGanttChartChild claimId="{!v.recordId}" />
                </div>
            </lightning:layoutItem>
        </lightning:layout> 
        
        
    </div>

</aura:application>