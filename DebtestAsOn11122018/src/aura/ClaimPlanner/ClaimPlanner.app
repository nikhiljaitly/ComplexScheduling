<aura:application controller="ClaimPlannerController" extends="force:slds">
    
    <aura:attribute name="recordId" type="String" default="5005D00000341e4QAA" />
    
    <aura:handler name="init" value="{!this}" action="{!c.init}"/>
    
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
            
            <lightning:layoutItem size="12">
                <c:CP_HighlightPanel />
            </lightning:layoutItem>
            
            <lightning:layoutItem size="12">
               
                <lightning:layout>
                    <lightning:layoutItem padding="around-small" flexibility="auto">
                        <div class="page-section page-left">
                            <c:CP_ClaimAppointments claimId="{!v.recordId}" />
                        </div>
                    </lightning:layoutItem>
                    
                    <lightning:layoutItem padding="around-small" flexibility="auto">
                        <div class="page-section page-right">
                            <c:ServiceAppointmentManager />
                        </div>
                    </lightning:layoutItem>
                    
                    <!--<lightning:layoutItem padding="around-small" flexibility="auto">
                        <div class="page-section page-main">
                          <tr> 
                            <td>
                            	<c:HRGanttChartChild claimId="{!v.recordId}" />
                        	</td>
                          </tr>    
                        </div>
                    </lightning:layoutItem>-->
                </lightning:layout>
             
                
            </lightning:layoutItem>
        </lightning:layout>
        
      </div>  
      
      <div>
           <lightning:layout multipleRows="true">
                <lightning:layoutItem padding="around-small" flexibility="auto" size="12">
                        <div class="page-section page-main">
                          <tr> 
                            <td>
                            	<c:HRGanttChartChild claimId="{!v.recordId}" />
                        	</td>
                          </tr>    
                        </div>
                    </lightning:layoutItem>
         </lightning:layout>
    </div>

</aura:application>