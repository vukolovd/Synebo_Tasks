({
    fetcContactList: function(cmp, event, helper){
        cmp.set('v.colums', [
            {label: 'Contact Name', fieldName: 'name', type: 'text', sortable: true},
            {label: 'Email', fieldName: 'email', type: 'email'},
            {label: 'Birthday', fieldName: 'birthdate', type: 'date'},
            {label: 'Account Name', fieldName: 'AccountName', type: 'text'}
        ]);
        var action = cmp.get("c.fetchContacts");
        action.setParams({});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set("v.contactList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    createRecord : function (component, event, helper) {
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Contact"
            });
            createRecordEvent.fire();
    },


    sortData: function (cmp, fieldName, sortDirection) {
            var fname = fieldName;
            var data = cmp.get("v.contactList");
            var reverse = sortDirection !== 'asc';
            data.sort(this.sortBy(fieldName, reverse))
            cmp.set("v.contactList", data);
    },

    sortBy: function (field, reverse) {
            var key = function(x) {return x[field]};
            reverse = !reverse ? 1 : -1;
            return function (a, b) {
                return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
            }
    }
});