public with sharing class ContactTriggerHandler extends TriggerHandler {
    private Map<Id,Contact> contactNewMap;
    private Map<Id,Contact> contactOldMap;

    public ContactTriggerHandler() {
        this.contactNewMap = (Map<Id,Contact>)Trigger.newMap;
    }

    //Our handler acts as the orchestration layer for the lead trigger.
    @TestVisible
    public override void afterInsert(){
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Contact contact : contactNewMap.values()) {
            if (contact.DummyJSON_Id__c == null) {
                contact.DummyJSON_Id__c = String.valueOf(Math.round(Math.random() * 100));
                contactsToUpdate.add(contact);
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            Database.update(contactsToUpdate);
        }

        if (!Test.isRunningTest()) {
            List<Id> contactIdList = new List<Id>(contactNewMap.keySet());
            System.enqueueJob(new AsyncDummyJSONUserQueueable(contactIdList));
        }
    }

    @TestVisible
    public override void beforeUpdate(){
        List<Id> contactIdList = new List<Id>();

        for (Contact contact : contactNewMap.values()) {
            contactIdList.add(contact.Id);
        }
        if (!Test.isRunningTest()) {
            System.enqueueJob(new AsyncDummyJSONUserQueueable(contactIdList));
        }
    }
}