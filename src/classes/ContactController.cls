public with sharing class ContactController {
    class ContactsList {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String email { get; set; }
        @AuraEnabled
        public Date birthdate { get; set; }
        @AuraEnabled
        public String AccountName { get; set; }
    }

    @AuraEnabled
    public static List<ContactsList> fetchContacts() {
        List<ContactsList> contactsLists = new List<ContactsList>();
        for (Contact contact_i : [
                SELECT Name, Email, Birthdate, Account.Name
                FROM Contact
                WITH SECURITY_ENFORCED
                ORDER BY Name ASC
                LIMIT 20
        ]) {
            ContactsList conTest = new ContactsList();
            conTest.name = contact_i.Name;
            conTest.email = contact_i.Email;
            conTest.birthdate = contact_i.Birthdate;
            conTest.AccountName = contact_i.Account.Name;
            contactsLists.add(conTest);
        }
        return contactsLists;
    }

    @AuraEnabled
    public static void deleteContact(List<String> contacName){
        List<Contact> deleteList = [SELECT Id, Name FROM Contact WHERE Name IN :contacName WITH SECURITY_ENFORCED];

        if(Contact.getSObjectType().getDescribe().isDeletable()) {

            Database.delete(deleteList, false);
        }
    }
}

