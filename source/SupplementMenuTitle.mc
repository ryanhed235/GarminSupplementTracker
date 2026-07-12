import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class SupplementMenuTitle extends WatchUi.Drawable {
    private var _title as String;
    
    function initialize(title as String) {
        var settings = System.getDeviceSettings();
        Drawable.initialize({
            :locX => 0,
            :locY => 0,
            :width => settings.screenWidth,
            :height => 70
        });
        _title = title;
    }
    
    function draw(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        
        // Black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, w, h);
        
        // White text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, 65, Graphics.FONT_MEDIUM, _title, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Separator
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(0, h-1, w, h-1);
    }
}
