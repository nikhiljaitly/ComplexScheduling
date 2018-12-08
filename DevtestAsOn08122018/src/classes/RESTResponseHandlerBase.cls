/**************************************************************
* Name: RESTResponseHandlerBase
* Created By: Mathew Jose
* Date: 23rd Feb 2018
* Description: Base Response Handler class to handle responses
*              from REST API classes
**************************************************************/

public virtual class RESTResponseHandlerBase {
	
	// custom attributes to use when sending a response
	public String Status {get; set;}
	public String Message {get; set;}
	public String ErrorCode {get; set;}
}