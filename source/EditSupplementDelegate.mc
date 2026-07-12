import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

class EditSupplementDelegate extends WatchUi.BehaviorDelegate {

    private var _index as Number;
    private var _view as EditSupplementView;
    
    function initialize(supplement as Dictionary, index as Number, view as EditSupplementView) {
        BehaviorDelegate.initialize();
        _index = index;
        _view = view;
    }

    function onTap(clickEvent as ClickEvent) as Boolean {
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];
        var w = 454;
        
        // Toggle Switch (approx centerX-60 to centerX+60, centerY-20 to centerY+40)
        var centerX = w / 2;
        var centerY = w / 2;
        if (x > centerX - 70 && x < centerX + 70 && y > centerY - 30 && y < centerY + 50) {
            _view.toggleUnit();
            WatchUi.requestUpdate();
            return true;
        }
        
        if (y > 150 && y < 285) {
            // Tap - or +
            if (x < 170) {
                // Tap - : instantly subtract 1
                updateCount(-1);
                return true;
            } else if (x > w - 170) {
                // Tap + : instantly add 1
                updateCount(1);
                return true;
            }
        } else if (y >= 285) {
            // Quick buttons: 5, 10, 0, 100 in 2x2 grid
            var isLeft = (x < w / 2);
            var isTop = (y < 355);
            var amount = 0;
            
            if (isLeft && isTop) {
                amount = 5;
            } else if (!isLeft && isTop) {
                amount = 10;
            } else if (isLeft && !isTop) {
                // 0 button resets count
                setCount(0);
                return true;
            } else if (!isLeft && !isTop) {
                amount = 100;
            }
            
            if (_view.getMode() == 0) { // Sub
                updateCount(-amount);
            } else { // Add
                updateCount(amount);
            }
            return true;
        }
        
        return false;
    }
    
    function onHold(clickEvent as ClickEvent) as Boolean {
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];
        var w = 454;
        
        if (y > 150 && y < 285) {
            if (x < 170) {
                // Hold - : switch mode to subtract
                _view.setMode(0);
                WatchUi.requestUpdate();
                return true;
            } else if (x > w - 150) {
                // Hold + : switch mode to add
                _view.setMode(1);
                WatchUi.requestUpdate();
                return true;
            }
        }
        return false;
    }
    
    private function updateCount(amount as Number) as Void {
        var multiplier = 1;
        if (_view.getUnit() == 1) {
            multiplier = 1000; // if unit is g, amount is in grams -> convert to mg
        }
        
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            var supp = supplements[_index] as Dictionary;
            if (supp != null) {
                var currentCount = supp["count"] as Number;
                var newCount = currentCount + (amount * multiplier);
                
                if (newCount < 0) {
                    newCount = 0;
                }
                
                supp["count"] = newCount;
                supp["lastLogged"] = System.getTimer();
                supp["unit"] = _view.getUnit(); // save preference
                
                Storage.setValue("supplements", supplements);
                MenuBuilder.refreshMainMenu();
                WatchUi.requestUpdate();
            }
        }
    }
    
    private function setCount(val as Number) as Void {
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            var supp = supplements[_index] as Dictionary;
            if (supp != null) {
                supp["count"] = val;
                supp["lastLogged"] = System.getTimer();
                supp["unit"] = _view.getUnit();
                
                Storage.setValue("supplements", supplements);
                MenuBuilder.refreshMainMenu();
                WatchUi.requestUpdate();
            }
        }
    }
}
