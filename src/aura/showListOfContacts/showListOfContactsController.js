({
    fetchCon: function(cmp, event, helper){
        helper.fetcContactList(cmp, event, helper);
    },

    createRecord: function(cmp, event, helper){
        helper.createRecord(cmp, event, helper);
    },

    updateSorting: function (cmp, event, helper) {
         var fieldName = event.getParam('fieldName');
         var sortDirection = event.getParam('sortDirection');
         cmp.set("v.sortedBy", fieldName);
         cmp.set("v.sortedDirection", sortDirection);
         helper.sortData(cmp, fieldName, sortDirection);
        },

    updateSelectedRows: function (cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var ids = [];
        for(var i = 0; i < selectedRows.length; i++ ) {
		ids.push(selectedRows[i].Id);
		}
		cmp.set("v.selectedRecord", ids);
	  },

	deleteSelectedRow : function(cmp, event, helper) {
              var recordsIds = cmp.get("v.selectedRecord");
              var action = cmp.get("c.deleteContact");
                  action.setParams({
                      "Ids" : recordsIds
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
          },

    handleRowAction: function(cmp, event, helper){
              var row = event.getParam('row');
              helper.deleteContact(cmp, row);
          }
});