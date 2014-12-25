

/**
  * Encapsulates all service layer logic for a given function or module in the application
  * 
  * It can be invoked in two ways, async( future call ) our in sync
  * The Service gathes API Settings, Lead and Cleabit Object and makes an API Call  
  * After receiving the API Response, process the result
  *
  *
  *   Service Works in collaboration with the S.P. Widget in Lead Page Layout, that polls the Clearbit API
  *   This is a shorter and simpler alternative than using a Scheduled Apex Job to Poll, also better UX
  *
  *
  * Invocation: The Service is invoked with Lead Id, from the Lead Post Insert Trigger and from Widget_Controller
  * Response: Response is void to stick to patterns , probably should refactor to respond with INT 
  *  now that there is a Sync Version
  *
  *
  **/

global class r2_MandrillService{

  public static integer lastStatus;

  public static string namespace;

  @future(callout=true)
  public static void send(){
    //sendSync();
  }

  private static string getApiKey(){
    //R2MandrillSetting__c setting = R2MandrillSetting__c.getOrgDefaults();
    //if( setting == null ) return null;
    //if( setting.ApiKey__c == null ) return null;
    //return setting.ApiKey__c;
    return 'AGnJY23HhEWL6uklIkt_WQ';//setting.ApiKey__c;
  }

  //Template: Name of Template, must match a Mandrill Operation
  //Ids: Comma-Separated list of ids of objects to be passed to Operation.
  //ObjectType: Type of Object
  public static void sendSync( string template , String sobjectIds ){
    
    r2_iMandrillOperation operation = getMandrillOperation(template, sobjectIds);


    String apiKey = getApiKey();
    if( apiKey == null ){
      lastStatus = 503;
      return; //API KEY NOT FOUND
    }

    Map<String,Object> postMap = new Map<String, Object>();
    postMap.put('key', apiKey);
    postMap.put('template_name', template );
    postMap.put( 'template_content', new List<String>() );
    Map<String,Object> message = new Map<String, Object>();
    
    postMap.put( 'message', operation.getMessage() );
    
		Http h = new Http();
		HttpRequest req = new HttpRequest();

		req.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json' );
		req.setMethod('POST');
		//req.setHeader( 'Authorization', 'Bearer ' + apiKey);
		string postJson = JSON.serialize( postMap );
		system.debug( postJson );
		req.setBody( postJson );

		// Send the request, and return a response
		HttpResponse res = h.send(req);

		system.debug( res.getBody() );
		lastStatus = res.getStatusCode();
 }       
  
 public static List<Id> idsToList( string ids ){
 	return ids.split(',');
 }

 public static string typeFromIds( List<Id> ids ){
 	string type = null;
 	Id firstId = ids.get(0);
 	Schema.SObjectType sType = firstId.getSobjectType();
 	type = sType.getDescribe().getName();

 	return type;
 }


 public static r2_iMandrillOperation getMandrillOperation(string template, string sobjectIds ){
 	List<id> ids = idsToList( sobjectIds );
 	String objType = typeFromIds( ids );

 	Type Operation;
 	r2_iMandrillOperation mandrillOperation;

 	try{
 		if( r2_MandrillService.namespace != null )  Operation = Type.forName(namespace, 'r2_Mandrill_' + objType + '_' +  template );
 		else   Operation = Type.forName( 'r2_Mandrill_' + objType + '_' +  template );

		mandrillOperation =  (r2_iMandrillOperation)Operation.newInstance();
 	}catch( Exception e ){}

 	if( mandrillOperation == null ){

	 	try{
	 		if( r2_MandrillService.namespace != null )  Operation = Type.forName(namespace, 'r2_Mandrill_' + objType);
	 		else   Operation = Type.forName( 'r2_Mandrill_' + objType );

			mandrillOperation = (r2_iMandrillOperation)Operation.newInstance();
	 		}catch( Exception e ){ throw e; throw new MandrillException('No Mandrill Operation found for Template: ' + template + ' and Type: ' + objType); }

		}

 		mandrillOperation.prepare(ids);
 		return mandrillOperation;

 }
  
  public class MandrillException extends Exception {

  }



}