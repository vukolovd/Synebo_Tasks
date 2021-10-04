({
    fetcContactList: function(cmp, event, helper){
         var actions = [{ label: 'Delete', name: 'delete' }];
        cmp.set('v.colums', [
            {label: 'Contact Name', fieldName: 'name', type: 'text', sortable: true},
            {label: 'Email', fieldName: 'email', type: 'email'},
            {label: 'Birthday', fieldName: 'birthdate', type: 'date'},
            {label: 'Account Name', fieldName: 'AccountName', type: 'text'},
            { type: 'action', typeAttributes: { rowActions: actions } }
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

    createRecord : function (cmp, event, helper) {
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
    },

    deleteContact:function(cmp, row){
         var recordsId = row.Id;
        var action = cmp.get("c.deleteContact");
          action.setParams({
             "Ids" : recordsId
       });
        action.setCallback(this, function(response) {
             var state = response.getState();
              if (state === "SUCCESS") {
                   var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         "type": "success",
                         "title": "Success!",
                         "message": "The record has been deleted successfully."
                     });
                     toastEvent.fire();
                    }
                  });
                $A.enqueueAction(action);
    }
});