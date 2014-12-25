# 3VOT Transaction Emails for Salesforce

Use this package to Send Transaction Emails from Salesforce using Mandrill API.

This is not only an Integration with Mandrill but a pattern developers can use to send transaction emails from any object standard or custom while being able to send specific merge variables.

## Installation

1. Opensource, you can integrate the code into the Salesforce Dev Org simply by deploying. 
2. Use Github Deployment: https://githubsfdeploy.herokuapp.com/app/githubdeploy/3vot/mandrill

## Overview

3VOT for Salesforce and Mandrill provides an interface to send transaction emails. It makes it really easy and organized by using Object Oriented Programming.

As a library it caters for all use cases. Emails can be send personalized for each recipient, the sames email can be sent to several recipients and personalize emails can be send to multiple recipients.

3VOT philosophy is not Point and Click and is not One Size Fits All. In 3VOT we build products the way they should be. In this case we should be able to have a Template in Mandrill and a way to build merge variables in a every imaginable way, send those merge variables to Mandrill, so that emails are created and sent.

The way we propose is to create a class for each template, in that class we'll assemble the required data from any data source and then send it to Mandrill. That class name will contain the name of the template and of the SOBJECT that represent the email. That could be a Lead, and Order, and Account or any Custom Object.

3VOT uses Type.forName to dynamically create and search for that class, whose interface is so simple all that must be send is the entry point Id. So if we'll be sending a transactional email for an order, we would call 3VOT with the template 'Order Received' and the Id of the Order. If we be sending Transactional ( Feedback ) Emails for all Cases resolved today we would just send the template Name 'Case Feedback' and the list of all Ids. The List of Id's is essential for using in Future or Batch Apex Calls.

 The template name must match a template name in Mandrill and the Id can be one or more comma separated string of id's.

The 3VOT library takes care of the rest. It will look for a class named r2_Mandrill_OBJECT-TYPE_TEMPLATE-NAME where OBJECT-TYPE is automatically researched from the first object id and TEMPLATE-NAME is provided to the function.

For example: To send a Sample Email to a lead we'll use ` r2_MandrillService.sendSync( 'sample', '1XJB83u3DndhdjUcIO' ) ` which will look for the class r2_Mandrill_Lead_Sample. 

In the class r2_Mandrill_Lead_Sample developers can query the lead and any other related objects until all the information required to send the email is ready.

The 3VOT Lib includes helpers to assemble the Recipient List, Merge Variables and MetaData; which makes this step simple enought.

### Sending Simple Emails
For the simplest use case, simply create a Class that implements r2_IMandrillOperation. Use r2_Mandrill_Lead as an example.

Call MandrillService passing the template name and the Id.

### Sending Multiple Emails
To send the same email to multiple emails, create a class that implements r2_IMandrillOperation passing the template name and the Ids as a comma separated String. On the class make sure to add each email using the r2_MandrillTo Helper. Next in the documentation we'll cover this.

### Sending Multiple Personalized Emails 
The most complex and interesting use case is very simple to execute. 3VOT and Mandrill include several features and helpers that will allow us to Map Variables to an Email Address. This way Mandrill API can then prepare personalized emails and send them to specific data. Look at r2_Mandrill_Lead_Sample for inspiration

## Usage

In Mandrill Web site, register with Mandrill, get an API Key and create a Template.

In Salesforce create a class called r2_Mandrill_OBJECT_TEMPLATE where TEMPLATE is the name of the template you just created and OBJECT is the name of the Object related to the email you are sending.

The relationship with the Object can be confusing at first, it's important for two reasons. First for order, but most importantly so that we can execute this code in Future or Batch Apex Calls. It's for bulkification.

Figure out what object this template could related to, and use that one. Also think ahead of time how you'll call the Mandrill Service. Calls must be related to an Id of an SOBJECT, that Object Type that represents that ID is what you should use for OBJECT in the class name.

Developers won't use this class directly, we save them lot's of work by creating a dynamic router that executes each template operation automatically. The contract inside the

### MandrillService

In order to use the service call the static method MandrillService.sendSync( String Template, String Ids )

Mandrill Services looks for a class named r2_Mandrill_OBJECT_TEMPLATE where OBJECT is the SOBJECT Type of the first Id and TEMPLATE is the name of the Template that's going to be used in Mandrill API.



### Mandrill Operations
Mandrill Operation classes must implement r2_IMandrillOperation with the prepare and getMessage methods.

Prepare
	` void prepare( List<Id> ids ) get's a list of ids from the MandrillService, this Id's where passed by you to MandrillService.sendSync method. In this function you can query related data and store it for later use `

getMessage
 This method is called by MandrillService to generate the JSON String that will be sent to Mandrill API. Notice the use if r2_MandrillTo Helper to register recipients.

`	global Map<String, Object> getMessage( ){
		Map<String, Object> result = new Map<String, Object>();

		List<Object> tos = new List<Object>();

		for( Lead lead : this.leads ){
			tos.add( new r2_MandrillTo( lead.Name, lead.Email ) );
		}

    result.put( 'to', tos );
    
    result.put('subject', 'Lead Email');

    return result;
	}
	`


## Additional Setup

You must set the Mandrill API Key, there are two ways of doing this. Think on which is the best way for you.

### Hardcoding API KEY
Hardcode the API KEY in MandrillService Class, this is not recommended but might be useful for simple deployments. 

### Custom Setting
Create the R2MandrillSetting Custom Setting and add the ApiKey__c option as a Text data type with a length of 100; Uncomment the code in Line 32-35 in MandrillService Class.


## Complex Use Case
If you want to send multiple personalized emails, use the following class as a template. The way this works is Mandrill maps email addresses to data and then use the template to generate an Email. We use the merge_vars property to set those and the getContent method to prepare them using the r2_MandrillMergeVar helper.

Finally recipient_metadata are used for web-hook or later analytics on Email Deliver-ability.

`
global without sharing class r2_Mandrill_Lead_Sample implements iMandrillOperation{

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
`



