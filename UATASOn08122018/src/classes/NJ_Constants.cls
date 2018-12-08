/**
 * Constants Class 
 * @CreatedDate : 06/11/2018
 * @CreatedBy : Nikhil Jaitly
 */
public with sharing class NJ_Constants {
	public static final String SA_STATUS_TENTATIVE = 'Tentative';
	public static final String SA_STATUS_NEW = 'New';
	public static final String SA_STATUS_CONFIRMED = 'Confirmed';
	public static final String SA_STATUS_AWAITINGCONFIRMATION = 'Awaiting Confirmation';
	public static final String SA_STATUS_COMPLETED = 'Completed';
	public static final String SA_STATUS_CANCELLED = 'Cancelled';
	public static final String SA_STATUS_CANNOTCOMPLETE = 'Cannot Complete';

	public static final String WO_STATUS_ASSIGNED = 'Work Order Assigned';
	public static final String WO_STATUS_SCHEDULED = 'Work Order Scheduled';
	public static final String WO_STATUS_ACCEPTED = 'Accepted WO';
	public static final String WO_STATUS_REJECTED = 'Rejected WO';
	public static final String WO_STATUS_WORKCOMMENCED = 'Work Commenced';
	public static final String WO_STATUS_WORKCOMPLETE = 'Work Complete';
	public static final String WO_STATUS_CLOSED = 'Closed';

}