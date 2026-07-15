import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        System.println("MainMenuDelegate.onSelect called, item ID: " + id);
        
        if (id.equals("sync")) {
            syncData();
        } else if (id.equals("manage")) {
            WatchUi.pushView(MenuBuilder.buildManageMenu(), new ManageMenuDelegate(), WatchUi.SLIDE_LEFT);
        } else {
            // It's a supplement ID
            var supplements = Storage.getValue("supplements");
            var targetSupp = null;
            var targetIndex = -1;
            
            if (supplements != null && supplements instanceof Array) {
                for (var i = 0; i < supplements.size(); i++) {
                    var supp = supplements[i] as Dictionary;
                    if (supp != null && supp["id"].equals(id)) {
                        targetSupp = supp;
                        targetIndex = i;
                        break;
                    }
                }
            }
            
            if (targetSupp != null && targetIndex != -1) {
                var view = new EditSupplementView(targetSupp, targetIndex);
                WatchUi.pushView(view, new EditSupplementDelegate(targetSupp, targetIndex, view), WatchUi.SLIDE_UP);
            }
        }
    }
    
    function syncData() as Void {
        var url = null;
        try {
            url = Application.Properties.getValue("ExportUrl");
        } catch (e) {
            System.println("ExportUrl property not found.");
        }
        
        if (url == null || url.length() < 10) {
            System.println("Invalid Webhook URL configured.");
            return;
        }
        
        // Build the date string for today
        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateStr = today.year + "-" + today.month.format("%02d") + "-" + today.day.format("%02d");

        // Get history backlog
        var history = Storage.getValue("history");
        if (history == null || !(history instanceof Array)) {
            history = [];
        }
        
        // Build the payload records array
        var payloadRecords = [];
        for (var i = 0; i < history.size(); i++) {
            payloadRecords.add(history[i]);
        }
        
        // Add today's live snapshot
        var currentSupps = Storage.getValue("supplements");
        if (currentSupps != null) {
            payloadRecords.add({
                "date" => dateStr,
                "supplements" => currentSupps
            });
        }
        
        var params = {
            "records" => payloadRecords
        };
        
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        
        System.println("Starting web request sync to: " + url);
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }
    
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200 || responseCode == 201) {
            System.println("Sync successful: " + data);
            
            // Clear the history backlog on successful sync
            Storage.setValue("history", []);
            
            if (Toybox.Attention has :vibrate) {
                Toybox.Attention.vibrate([new Toybox.Attention.VibeProfile(50, 500)]);
            }
        } else {
            System.println("Sync failed. Response code: " + responseCode);
            if (Toybox.Attention has :vibrate) {
                Toybox.Attention.vibrate([new Toybox.Attention.VibeProfile(100, 200), new Toybox.Attention.VibeProfile(0, 100), new Toybox.Attention.VibeProfile(100, 200)]);
            }
        }
    }
}
