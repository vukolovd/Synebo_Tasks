@IsTest
public with sharing class ContactTriggerHandlerTest {
    @TestSetup
    static void testSetup() {
        Account testAccount = new Account(
                Name = 'testAccountName'
        );
        insert testAccount;

        Contact testCont = new Contact(
                LastName = 'testLastName',
                AccountId = testAccount.Id,
                Confirmation_status__c = false
        );
        insert testCont;
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
        System.assertEquals(1, testAcc.Confirmed_contacts__c);
    }

    @IsTest
    static void afterUpdate() {
        Contact testContact = [SELECT Id, Confirmation_status__c FROM Contact LIMIT 1];
        testContact.Confirmation_status__c = true;
        update testContact;

        Account testAccount = [SELECT Id, Confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(1, testAccount.Confirmed_contacts__c);
    }

    @IsTest
    static void afterDelete() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        delete testContact;
        Account testAccount = [SELECT Id, Not_confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(null, testAccount.Not_confirmed_contacts__c);
    }

    @IsTest
    static void afterUndelete() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        delete testContact;
        Account testAcc = [SELECT Id, Not_confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(null, testAcc.Not_confirmed_contacts__c);

        undelete testContact;
        testAcc = [SELECT Id, Not_confirmed_contacts__c FROM Account LIMIT 1];
        System.assertEquals(1, testAcc.Not_confirmed_contacts__c);
    }
}