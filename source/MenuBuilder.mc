import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;

var gMainMenu;
var gManageMenu;

module MenuBuilder {

    function buildMainMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({:title=>"Main Menu"});
        
        menu.addItem(new WatchUi.MenuItem("Supplements", "Tap to Manage", "manage", {}));
        
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            for (var i = 0; i < supplements.size(); i++) {
                var supp = supplements[i] as Dictionary;
                if (supp != null) {
                    var subLabel = supp["count"] + "g";
                    menu.addItem(new WatchUi.MenuItem(supp["name"], subLabel, supp["id"], {}));
                }
            }
        }
        
        menu.addItem(new WatchUi.MenuItem("Sync", "Send data", "sync", {}));
        
        gMainMenu = menu;
        return menu;
    }

    function buildManageMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({:title=>"Manage"});
        
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            for (var i = 0; i < supplements.size(); i++) {
                var supp = supplements[i] as Dictionary;
                if (supp != null) {
                    var subLabel = supp["count"] + "g";
                    menu.addItem(new WatchUi.MenuItem(supp["name"], subLabel, supp["id"], {}));
                }
            }
        }
        
        gManageMenu = menu;
        return menu;
    }
    
    function refreshMainMenu() as Void {
        if (gMainMenu == null) { return; }
        var itemsDeleted = true;
        while (itemsDeleted) {
            var item = gMainMenu.getItem(0);
            if (item != null) {
                gMainMenu.deleteItem(0);
            } else {
                itemsDeleted = false;
            }
        }
        
        gMainMenu.addItem(new WatchUi.MenuItem("Supplements", "Tap to Manage", "manage", {}));
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            for (var i = 0; i < supplements.size(); i++) {
                var supp = supplements[i] as Dictionary;
                if (supp != null) {
                    var subLabel = supp["count"] + "g";
                    gMainMenu.addItem(new WatchUi.MenuItem(supp["name"], subLabel, supp["id"], {}));
                }
            }
        }
        gMainMenu.addItem(new WatchUi.MenuItem("Sync", "Send data", "sync", {}));
    }
    
    function refreshManageMenu() as Void {
        if (gManageMenu == null) { return; }
        
        var itemsDeleted = true;
        while (itemsDeleted) {
            var item = gManageMenu.getItem(0);
            if (item != null) {
                gManageMenu.deleteItem(0);
            } else {
                itemsDeleted = false;
            }
        }
        
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            for (var i = 0; i < supplements.size(); i++) {
                var supp = supplements[i] as Dictionary;
                if (supp != null) {
                    var subLabel = supp["count"] + "g";
                    gManageMenu.addItem(new WatchUi.MenuItem(supp["name"], subLabel, supp["id"], {}));
                }
            }
        }
    }
}
