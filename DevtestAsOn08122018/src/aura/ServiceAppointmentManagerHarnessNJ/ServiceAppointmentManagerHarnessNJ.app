<aura:application  extends="force:slds" >
    
    <aura:attribute name="recordId" type="String" default="5005D00000341e4QAA" />
    
    <div class="c-container">
        <lightning:layout multipleRows="true">
            <lightning:layoutItem padding="around-small" size="12">
                <div class="page-section page-header">
                    <h2>Claim Service Appointment Manager</h2>
                </div>
            </lightning:layoutItem>
            <lightning:layoutItem padding="around-small" size="12">
                <lightning:layout>
                    <lightning:layoutItem padding="around-small" size="3">
                        <div class="page-section page-right">
                            <c:ClaimSrvApptManager claimId="{!v.recordId}" />
                        </div>
                    </lightning:layoutItem>
                    <lightning:layoutItem padding="around-small" size="6">
                        <div class="page-section page-main">
                            <c:HRGanttChartChild claimId="{!v.recordId}" />
                        </div>
                    </lightning:layoutItem>
                    <lightning:layoutItem padding="around-small" size="3">
                        <div class="page-section page-right">
                            <c:ServiceAppointmentManager />
                        </div>
                    </lightning:layoutItem>
                </lightning:layout>
            </lightning:layoutItem>
        </lightning:layout>
    </div>
	
</aura:application>