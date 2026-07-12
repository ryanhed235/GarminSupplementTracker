import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

class ManageMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        System.println("ManageMenuDelegate.onSelect called, item ID: " + id);
        
        if (id != null) {
            // It's an existing supplement ID, push action menu
            var actionMenu = new WatchUi.Menu2({:title=>"Options"});
            actionMenu.addItem(new WatchUi.MenuItem("Delete", "", "delete_" + id, {}));
            WatchUi.pushView(actionMenu, new ManageActionDelegate(id as String), WatchUi.SLIDE_UP);
        }
    }
}
