import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class SupplementMenuItem extends WatchUi.CustomMenuItem {
    private var _label as String;
    private var _subLabel as String;
    
    function initialize(id as Object, label as String, subLabel as String) {
        CustomMenuItem.initialize(id, {});
        _label = label;
        _subLabel = subLabel;
    }
    
    function updateLabel(label as String) as Void {
        _label = label;
        WatchUi.requestUpdate();
    }
    
    function updateSubLabel(subLabel as String) as Void {
        _subLabel = subLabel;
        WatchUi.requestUpdate();
    }
    
    function draw(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        
        // Black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, w, h);
        
        // White text for label
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h/2 - 15, Graphics.FONT_SMALL, _label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Light gray text for subLabel
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h/2 + 15, Graphics.FONT_XTINY, _subLabel, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Separator
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(0, h-1, w, h-1);
    }
}
