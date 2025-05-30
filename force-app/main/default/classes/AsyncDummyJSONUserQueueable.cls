public with sharing class AsyncDummyJSONUserQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> contactIdListFromHelperMethod;
    
    public AsyncDummyJSONUserQueueable(List<Id> contactIdList){
        this.contactIdListFromHelperMethod = contactIdList;
    }
    
    public void execute(QueueableContext context) {

        List<Contact> contactsToUpdate = new List<Contact>();

        List<Contact> contacts = [ SELECT Id, DummyJSON_Id__c, Email 
                                    FROM Contact
                                    WHERE Id IN :contactIdListFromHelperMethod ];

        for (Contact contact : contacts) {

            if (Integer.valueOf(contact.DummyJSON_Id__c) <= 100) {
                DummyJSONCallout.getDummyJSONUserFromId(contact.DummyJSON_Id__c);
            }

            if (Integer.valueOf(contact.DummyJSON_Id__c) > 100) {
                DummyJSONCallout.postCreateDummyJSONUser(contact.Id);
            }
        }
    }
}