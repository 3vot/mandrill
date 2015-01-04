<<<<<<< HEAD
global without sharing class r2_Mandrill_Lead_Sample implements r2_iMandrillOperation{
=======


global without sharing class r2_Mandrill_Lead_Sample implements iMandrillOperation{
>>>>>>> 0c28fc157e6e051e9d71a9a549b9cd00edc336c1

	global List<id> ids;
	global List<Lead> leads;

	global void prepare( List<Id> ids ){
		this.ids = ids;
		this.leads =  [select id, name, email from Lead where Id in :ids];
	}

	global Map<String, Object> getMessage( ){
		Map<String, Object> result = new Map<String, Object>();

		List<Object> tos = new List<Object>();

		for( Lead lead : this.leads ){
			tos.add( new r2_MandrillTo( lead.Name, lead.Email ) );
		}

    result.put( 'to', tos );
    
    result.put('subject', 'Lead Email');

    result.put( 'merge_vars', getContent() );

    result.put( 'recipient_metadata', getMetadata() );

    return result;
	}

	global List<Object> getContent( ){
		List<Object> result = new List<Object>();

		for( Lead lead : this.leads ){
			r2_MandrillMergeVar mergevar = new r2_MandrillMergeVar( lead.email );

			mergevar.addVar( 'Name', lead.Name );

			result.add( mergevar );
		}
  
    return result;
	}

	global  List<Object> getMetadata( ){
		List<Object> result = new List<Object>();

		for( Lead lead : this.leads ){
			r2_MandrillMetadata metadata = new r2_MandrillMetadata( lead.email );			
			metadata.addValue('id', lead.id);
			result.add(metadata);
		}

	  return result;
	}

	



}