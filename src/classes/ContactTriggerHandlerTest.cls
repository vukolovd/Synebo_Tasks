@IsTest
public with sharing class ContactTriggerHandlerTest {
    @TestSetup
    static void testSetup() {
        List<Contact> confirmTestList = new List<Contact>();
        List<Contact> notConfirmTestList = new List<Contact>();
        Account testAccount = new Account(
                Name = 'testAccountName'
        );
        insert testAccount;

        for(Integer i = 0; i < 5; i++) {
            Contact testCont = new Contact(
                    LastName = 'testLastName' + i,
                    AccountId = testAccount.Id,
                    Confirmation_status__c = true
            );
            confirmTestList.add(testCont);
        }
        insert confirmTestList;
        for(Integer i = 0; i < 5; i++){
            Contact testCont = new Contact(
                    LastName = 'testLastNames' + i,
                    AccountId = testAccount.Id,
                    Confirmation_status__c = false
            );
            notConfirmTestList.add(testCont);
        }
        insert notConfirmTestList;
    }


    @IsTest
    static void afterInsert() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = new Contact(
                LastName = 'testLastName',
                AccountId = testAcc.Id,
                Confirmation_status__c = true
        );
        insert testContact;
        testAcc = [SELECT Confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(6, testAcc.Confirmed_contacts__c);
    }

    @IsTest
    static void afterUpdate() {
        Contact testContact = [SELECT Id, Confirmation_status__c FROM Contact LIMIT 1];
        testContact.Confirmation_status__c = true;
        update testContact;

        Account testAccount = [SELECT Id, Confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(5, testAccount.Confirmed_contacts__c);
    }

    @IsTest
    static void afterDelete() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        delete testContact;
        Account testAccount = [SELECT Id, Not_confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(5, testAccount.Not_confirmed_contacts__c);
    }

    @IsTest
    static void afterUndelete() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        delete testContact;
        Account testAcc = [SELECT Id, Not_confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(5, testAcc.Not_confirmed_contacts__c);

        undelete testContact;
        testAcc = [SELECT Id, Not_confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(5, testAcc.Not_confirmed_contacts__c);
    }
}