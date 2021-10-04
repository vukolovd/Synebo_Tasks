@IsTest
public with sharing class ContactControllerTest {
    @TestSetup
    static void testData() {
        List<Contact> contactsLists = new List<Contact>();
        for (Integer i = 0; i < 20; i++) {
            Contact contact = new Contact();
            contact.LastName = 'testName' + i;
            contactsLists.add(contact);
        }
        insert contactsLists;
    }

    @IsTest
    static void fetchContactsTest(){
        List<ContactController.ContactsList> contactList = ContactController.fetchContacts();
        System.assertEquals(20, contactList.size());
    }

    @IsTest
    static void deleteContactTest(){
        List<Contact> contactList = [SELECT Id FROM Contact];
        System.assertEquals(20, contactList.size());

        List<Id> idList = new List<Id>();
        for(Contact contact_i: contactList){
            idList.add(contact_i.Id);
        }

        ContactController.deleteContact(idList);
        contactList = [SELECT Id FROM Contact];
        System.assertEquals(0, contactList.size());

    }
}