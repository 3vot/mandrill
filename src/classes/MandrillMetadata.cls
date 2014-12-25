public with sharing class MandrillMetadata {
		
	public String rcpt;
	public Map<String,Object> values = new Map<String, Object>();

	public MandrillMetadata( string email ) {
		rcpt = email;
	}

	public void addValue( String name, Object value ){
		values.put( name, value );
	}


}