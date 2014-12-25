@isTest
private class MandrillService_Test {
	
	@isTest static void shouldSendAMessage() {
		Test.setMock(HttpCalloutMock.class, new Test_CalloutMock());

		Lead lead = new Lead();
		lead.Company = 'clearbit';
		lead.FirstName = 'Alex';
		lead.LastName = 'MacCaw';
		lead.Email = 'alex@respond202.com';
		insert lead;

		Test.startTest();

		MandrillService.sendSync('sample', String.valueOf(lead.Id) );

		Test.stopTest();

	}

	@isTest static void idsToList() {
		Account acc = new Account();
		acc.Name = 'test';
		insert acc;

		Account acc2 = new Account();
		acc2.Name = 'test2';
		insert acc2;

		List<Id> idList = new List<Id>{ acc.Id, acc2.Id };

		List<Id> ids =  MandrillService.idsToList( String.join(idList, ',') );
		System.assertEquals(ids.size(), 2);
	}


	@isTest static void typeFromIds() {
		Account acc = new Account();
		acc.Name = 'test';
		insert acc;

		List<Id> ids = new List<Id>{ acc.id };

		String type =  MandrillService.typeFromIds( ids );
		System.assertEquals(type, 'Account');
	}

	
	@isTest static void getMandrillOperation() {
		Test.setMock(HttpCalloutMock.class, new Test_CalloutMock());

		Lead lead = new Lead();
		lead.Company = 'clearbit';
		lead.FirstName = 'Alex';
		lead.LastName = 'MacCaw';
		lead.Email = 'alex@respond202.com';
		insert lead;

				Lead lead2 = new Lead();
		lead2.Company = 'clearbit';
		lead2.FirstName = 'Alex';
		lead2.LastName = 'MacCaw';
		lead2.Email = 'alex@respond2021.com';
		insert lead2;

		Test.startTest();

		iMandrillOperation operation = MandrillService.getMandrillOperation('any template', String.valueOf(lead.Id) + ',' + String.valueOf(lead2.id) );

		system.assert( operation instanceof Mandrill_Lead );

		Test.stopTest();

	}

		@isTest static void getMandrillOperationWithTemplate() {
		Test.setMock(HttpCalloutMock.class, new Test_CalloutMock());

		Lead lead = new Lead();
		lead.Company = 'clearbit';
		lead.FirstName = 'Alex';
		lead.LastName = 'MacCaw';
		lead.Email = 'alex@respond202.com';
		insert lead;

				Lead lead2 = new Lead();
		lead2.Company = 'clearbit';
		lead2.FirstName = 'Alex';
		lead2.LastName = 'MacCaw';
		lead2.Email = 'alex@respond2021.com';
		insert lead2;

		Test.startTest();

		iMandrillOperation operation = MandrillService.getMandrillOperation('sample', String.valueOf(lead.Id) + ',' + String.valueOf(lead2.id) );

		system.assert( operation instanceof Mandrill_Lead_Sample );

		Test.stopTest();

	}



}