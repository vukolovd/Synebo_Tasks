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
        var names = [];
       for ( var i = 0; i < selectedRows.length; i++ ) {
		     names.push(selectedRows[i].name);
		}
		cmp.set("v.selectedRecord", names);
	  },

	  deleteSelectedRow : function(component, event, helper) {
              var recordsIds = component.get("v.selectedRecord");
               var action = component.get("c.deleteContact");
                  action.setParams({
                      "contacName" : recordsIds
                  });
                  action.setCallback(this, function(response) {
                      var state = response.getState();
                      if (state === "SUCCESS") {
                          alert(response.getReturnValue());
                          if (response.getReturnValue() != "") {
                              alert(
                                  "The following error has occurred. while Delete record-->" +
                                  response.getReturnValue()
                              );
                          }else{
      			alert( "Records deleted successfully" );
      			helper.loadData(component, event, helper);
      	         }
                      }
                  });
                  $A.enqueueAction(action);
          },
});