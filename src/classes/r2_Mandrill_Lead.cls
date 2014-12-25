

global class r2_Mandrill_Lead implements IMandrillOperation{

	global List<id> ids;

	global  Map<String, Object> getMessage( ){
		Map<String, Object> result = new Map<String, Object>();

		Map<String,Object> to1 = new Map<String, Object>();
		to1.put('email', 'roberto@rodcocr.com');

    result.put( 'to', new List<Map<String,Object>>{to1} );
    return result;
	}

	global List<Object> getContent( ){
		List<Object> result = new List<Object>();
	
    return result;
	}

	global  Map<String, Object> getMetadata( ){
		Map<String, Object> result = new Map<String, Object>();

	  return result;
	}

	global  boolean isPerRecipient( ){ return false; }

	global  void prepare( List<Id> ids ){
		this.ids = ids;
	}

}