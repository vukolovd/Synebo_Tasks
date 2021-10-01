public without sharing class ContactTriggerHandler extends TriggerHandler {

    protected override void afterInsert() {
        this.countConfirmedContacts((List<Contact>) Trigger.new, null);
    }

    protected override void afterUpdate() {
        this.countConfirmedContacts((List<Contact>) Trigger.new, (Map<Id, Contact>) Trigger.oldMap);
    }

    protected override void afterDelete() {
        this.countConfirmedContacts(null, (Map<Id, Contact>) Trigger.oldMap);
    }

    protected override void afterUndelete() {
        this.countConfirmedContacts((List<Contact>) Trigger.new, null);
    }

    private void countConfirmedContacts(List<Contact> newList, Map<Id, Contact> oldMap) {
        Set<Id> accountIdToNumOfContactSet = new Set<Id>();
        Map<Id, Integer> accountIdToNumConfirmMap = new Map<Id, Integer>();
        Map<Id, Integer> accountIdToNumNotConfirmMap = new Map<Id, Integer>();
        List<Account> accountToUpdateList = new List<Account>();
        List<Contact> contactProcessList = (!Trigger.isDelete)
                ? newList
                : oldMap.values();

        for (Contact contact_i : contactProcessList) {
            if ((Trigger.isInsert || Trigger.isDelete || Trigger.isUndelete) && contact_i.AccountId != null) {
                accountIdToNumOfContactSet.add(contact_i.AccountId);
            }
            if (Trigger.isUpdate && (contact_i.AccountId != oldMap.get(contact_i.Id).AccountId || contact_i.Confirmation_status__c != oldMap.get(contact_i.Id).Confirmation_status__c)) {
                if (contact_i.AccountId != null) {
                    accountIdToNumOfContactSet.add(contact_i.AccountId);
                }
                if (oldMap.get(contact_i.Id).AccountId != null) {
                    accountIdToNumOfContactSet.add(oldMap.get(contact_i.Id).AccountId);
                }
            }
        }
        if (accountIdToNumOfContactSet.isEmpty()) {
            return;
        }

        List<AggregateResult> aggReslist = [
                SELECT AccountId Id, Confirmation_status__c status, COUNT(Id) countStatus
                FROM Contact
                WHERE AccountId IN :accountIdToNumOfContactSet
                GROUP BY AccountId, Confirmation_status__c
        ];

        if (!aggReslist.isEmpty()) {
            for (AggregateResult result_i : aggReslist) {
                    if ((Boolean) result_i.get('status') == true) {
                        accountIdToNumConfirmMap.put((Id) result_i.get('id'), (Integer) result_i.get('countStatus'));
                    }

                    if ((Boolean) result_i.get('status') == false) {
                        accountIdToNumNotConfirmMap.put((Id) result_i.get('id'), (Integer) result_i.get('countStatus'));
                    }
            }
        }

        for (Id account_i : accountIdToNumOfContactSet) {
            accountToUpdateList.add(
                    new Account(
                            Id = account_i,
                            Confirmed_contacts__c = (Decimal) accountIdToNumConfirmMap.get(account_i),
                            Not_confirmed_contacts__c = (Decimal) accountIdToNumNotConfirmMap.get(account_i)
                    )
            );
        }
        update accountToUpdateList;
    }
}