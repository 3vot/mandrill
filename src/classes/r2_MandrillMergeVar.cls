public class r2_MandrillMergeVar {
	

	public String rcpt;
	public List<Object> vars = new List<Object>();

	public r2_MandrillMergeVar( string email ) {
		rcpt = email;
	}

	public void addVar( String name, Object value ){
		Map<String,Object> var = new Map<String,Object>();
		var.put('name', name);
		var.put('content', value);
		vars.add( var );
	}


}