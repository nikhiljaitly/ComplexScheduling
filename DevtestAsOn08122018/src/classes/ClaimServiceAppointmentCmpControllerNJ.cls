/***
 * ClaimServiceAppointmentCmpController is the controller for 
 * the lightning component ClaimServiceAppointments
 * 
***/
public class ClaimServiceAppointmentCmpControllerNJ {
  
  @AuraEnabled  
  public static List<ServiceAppointment> getCaseServiceAppointments(Id appointmentId){
        List<ServiceAppointment> apptList = [select Id, Claim__c from ServiceAppointment where Id = :appointmentId LIMIT 1 ];
        List<ServiceAppointment> returnAppointmentList = new List<ServiceAppointment>();  
        ServiceAppointment returnAppt = null;
        if(!apptList.isEmpty()){
            returnAppt = apptList.get(0);
            System.Debug(LoggingLevel.DEBUG, '***Claim Id = ' + returnAppt.Claim__c);
            returnAppointmentList = [SELECT Id, AppointmentNumber, WorkType.Name, Subject, EarliestStartTime, 
                                            Claim__c, DueDate, Status, SchedStartTime, SchedEndTime, Address
                                     FROM ServiceAppointment WHERE Claim__c = :returnAppt.Claim__c
                                     ORDER BY EarliestStartTime];
        }
        return returnAppointmentList;
  }
    
    @AuraEnabled
    public static List<returnSlot> getAppointmentSlots(Id appointmentId) {
        OperatingHours abOperatingHours = [SELECT Name, Id, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE Name = 'Assessors Calendar' limit 1];

    ServiceAppointment sa = [select id, EarliestStartTime, DueDate from ServiceAppointment where Id = :appointmentId];
    Id schedulingPolicyId=[select id from FSL__Scheduling_Policy__c where Name='Customer First' limit 1].Id;
    Timezone tz = UserInfo.getTimeZone();

    List<FSL.AppointmentBookingSlot> slots = FSL.AppointmentBookingService.GetSlots(sa.Id, schedulingPolicyId, abOperatingHours, tz,  'SORT_BY_DATE', false);

    System.debug('Returned ' + slots.size() + ' appointment slots');
        List <returnSlot> returnSlots = new List<returnSlot>();
    for(integer i=0; i<slots.size(); i++){
            returnSlot r = new returnSlot();
            System.debug(LoggingLevel.INFO, '***Slot ' + i + ': ' + slots[i]);
        system.debug('Slot:'+i+' Start: '+slots[i].Interval.Start+' Finish:'+ slots[i].Interval.Finish+' Grade: '+slots[i].Grade);
            r.SlotNumber = i;
            r.slotGrade = slots[i].Grade;
            r.slotStartTime = slots[i].Interval.Start;
            r.slotFinishTime = slots[i].Interval.Finish;
            returnSlots.add(r);
            System.debug(LoggingLevel.INFO, '***r = ' + r);
    }
        System.debug(LoggingLevel.INFO, '***returnSlots = ' + returnSlots);
        return returnSlots;
    }
    
    private class returnSlot {
        @AuraEnabled
        Integer slotNumber { get; set; }
        @AuraEnabled
        Double slotGrade { get; set; }
        @AuraEnabled
        DateTime slotStartTime { get; set; }
        @AuraEnabled
        DateTime slotFinishTime { get; set; }
    }

}