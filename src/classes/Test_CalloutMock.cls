
	global class Test_CalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
      string resText = '{}';
      integer status = 202;

			if( req.getEndPoint().indexOf('messages/send.json') > -1 ){ resText = send(); status = 200; }

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resText);
        res.setStatusCode(status);
        return res;
    }


    public static string send(){


    	string res =  '[' ;
			
    		res+='{';
        res+='"email": "recipient.email@example.com",';
        res+='"status": "sent",';
        res+='"reject_reason": "hard-bounce",';
        res+='"_id": "abc123abc123abc123abc123abc123"';
    		res+='}';
				res+=']';
				return res;
		}
	}