import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class SupplementItemDrawable extends WatchUi.Drawable {
    private var _label as String;
    private var _subLabel as String;

    function initialize(label as String, subLabel as String) {
        var settings = System.getDeviceSettings();
        Drawable.initialize({
            :locX => 0,
            :locY => 0,
            :width => settings.screenWidth,
            :height => 80
        });
        _label = label;
        _subLabel = subLabel;
    }

    function setLabel(label as String) as Void {
        _label = label;
    }

    function setSubLabel(subLabel as String) as Void {
        _subLabel = subLabel;
    }

    function draw(dc as Graphics.Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();

        // Black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, w, h);

        // White label text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 - 12, Graphics.FONT_SMALL, _label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Gray sub-label text
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 + 14, Graphics.FONT_XTINY, _subLabel, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Bottom separator line
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(0, h - 1, w, h - 1);
    }
}
