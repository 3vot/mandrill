global without sharing class Mandrill_Lead_Sample implements iMandrillOperation{

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
			tos.add( new MandrillTo( lead.Name, lead.Email ) );
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
			MandrillMergeVar mergevar = new MandrillMergeVar( lead.email );

			mergevar.addVar( 'Name', lead.Name );

			result.add( mergevar );
		}
  
    return result;
	}

	global  List<Object> getMetadata( ){
		List<Object> result = new List<Object>();

		for( Lead lead : this.leads ){
			MandrillMetadata metadata = new MandrillMetadata( lead.email );			
			metadata.addValue('id', lead.id);
			result.add(metadata);
		}

	  return result;
	}

	



}

