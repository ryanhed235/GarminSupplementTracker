import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

import Toybox.Time;

class SupplementTrackerApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        // Initialize dynamic list in storage if it doesn't exist
        var supplements = Storage.getValue("supplements");
        if (supplements == null) {
            var initialSupplements = [
                {"id" => "creatine", "name" => "Creatine", "count" => 0, "lastLogged" => 0},
                {"id" => "protein", "name" => "Protein", "count" => 0, "lastLogged" => 0},
                {"id" => "preworkout", "name" => "Pre-workout", "count" => 0, "lastLogged" => 0}
            ];
            Storage.setValue("supplements", initialSupplements);
        }
        
        checkDateAndReset();
    }
    
    function checkDateAndReset() as Void {
        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateStr = today.year + "-" + today.month.format("%02d") + "-" + today.day.format("%02d");
        
        var lastDate = Storage.getValue("lastDate");
        
        if (lastDate != null && !lastDate.equals(dateStr)) {
            // It's a new day! Save yesterday's data to history and reset counters.
            var history = Storage.getValue("history");
            if (history == null || !(history instanceof Array)) { 
                history = []; 
            }
            
            var currentSupps = Storage.getValue("supplements");
            if (currentSupps != null && currentSupps instanceof Array) {
                // Add to history
                history.add({"date" => lastDate, "supplements" => currentSupps});
                Storage.setValue("history", history);
                
                // Reset current counters to 0
                for (var i = 0; i < currentSupps.size(); i++) {
                    var supp = currentSupps[i] as Dictionary;
                    if (supp != null) {
                        supp["count"] = 0;
                    }
                }
                Storage.setValue("supplements", currentSupps);
            }
        }
        
        // Update lastDate to today
        Storage.setValue("lastDate", dateStr);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ MenuBuilder.buildMainMenu(), new MainMenuDelegate() ];
    }
    
    function onSettingsChanged() as Void {
        var appSettingsList = Application.Properties.getValue("SupplementListString");
        if (appSettingsList != null && appSettingsList instanceof String) {
            syncSettingsToStorage(appSettingsList as String);
        }
    }
    
    function syncSettingsToStorage(settingsString as String) as Void {
        var names = parseCommaSeparatedString(settingsString);
        var oldSupps = Storage.getValue("supplements");
        if (oldSupps == null || !(oldSupps instanceof Array)) {
            oldSupps = [];
        }
        
        var newSupps = [];
        for (var i = 0; i < names.size(); i++) {
            var name = names[i];
            var found = null;
            var oldArray = oldSupps as Array;
            for (var j = 0; j < oldArray.size(); j++) {
                var supp = oldArray[j] as Dictionary;
                if (supp != null && supp["name"].equals(name)) {
                    found = supp;
                    break;
                }
            }
            if (found != null) {
                newSupps.add(found);
            } else {
                newSupps.add({
                    "id" => "supp_" + System.getTimer() + "_" + i,
                    "name" => name,
                    "count" => 0,
                    "lastLogged" => 0
                });
            }
        }
        
        Storage.setValue("supplements", newSupps);
        MenuBuilder.refreshMainMenu();
        MenuBuilder.refreshManageMenu();
        WatchUi.requestUpdate();
    }
    
    function parseCommaSeparatedString(str as String) as Array {
        var parts = [];
        var commaIndex = str.find(",");
        
        while (commaIndex != null) {
            var part = str.substring(0, commaIndex);
            part = trimWhitespace(part);
            if (part.length() > 0) {
                parts.add(part);
            }
            str = str.substring(commaIndex + 1, str.length());
            commaIndex = str.find(",");
        }
        
        var lastPart = trimWhitespace(str);
        if (lastPart.length() > 0) {
            parts.add(lastPart);
        }
        return parts;
    }
    
    function trimWhitespace(str as String) as String {
        while (str.length() > 0 && str.substring(0, 1).equals(" ")) {
            str = str.substring(1, str.length());
        }
        while (str.length() > 0 && str.substring(str.length()-1, str.length()).equals(" ")) {
            str = str.substring(0, str.length()-1);
        }
        return str;
    }

}

function getApp() as SupplementTrackerApp {
    return Application.getApp() as SupplementTrackerApp;
}
