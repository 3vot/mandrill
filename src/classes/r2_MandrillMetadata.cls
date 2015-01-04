public with sharing class r2_MandrillMetadata {
		
	public String rcpt;
	public Map<String,Object> values = new Map<String, Object>();

	public r2_MandrillMetadata( string email ) {
		rcpt = email;
	}

	public void addValue( String name, Object value ){
		values.put( name, value );
	}


}