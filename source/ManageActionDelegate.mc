import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

class ManageActionDelegate extends WatchUi.Menu2InputDelegate {
    
    private var _targetId as String;
    
    function initialize(targetId as String) {
        Menu2InputDelegate.initialize();
        _targetId = targetId;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId() as String;
        
        if (id != null && id.length() >= 7) {
            if (id.length() >= 7 && id.substring(0, 7).equals("delete_")) {
                var supplements = Storage.getValue("supplements");
                var suppsArray = [];
                if (supplements != null && supplements instanceof Array) {
                    suppsArray = supplements as Array;
                    
                    // Filter out the deleted item
                    var newArray = [];
                    for (var i = 0; i < suppsArray.size(); i++) {
                        var supp = suppsArray[i] as Dictionary;
                        if (supp != null && !supp["id"].equals(_targetId)) {
                            newArray.add(supp);
                        }
                    }
                    Storage.setValue("supplements", newArray);
                }
                
                MenuBuilder.refreshManageMenu();
                MenuBuilder.refreshMainMenu();
                
                // Return to manage menu
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            }
        }
    }
}
