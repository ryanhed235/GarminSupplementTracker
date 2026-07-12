import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;

class EditSupplementView extends WatchUi.View {

    private var _supplement as Dictionary;
    private var _index as Number;
    
    // State: 0 = mg, 1 = g
    private var _unit as Number = 0;
    
    // State: 1 = Add, 0 = Subtract
    private var _mode as Number = 1;

    function initialize(supplement as Dictionary, index as Number) {
        View.initialize();
        _supplement = supplement;
        _index = index;
        
        if (_supplement.hasKey("unit")) {
            _unit = _supplement["unit"] as Number;
        }
    }
    
    function toggleUnit() as Void {
        _unit = _unit == 0 ? 1 : 0;
    }
    
    function getUnit() as Number {
        return _unit;
    }
    
    function setMode(mode as Number) as Void {
        _mode = mode;
    }
    
    function getMode() as Number {
        return _mode;
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        var supplements = Storage.getValue("supplements");
        if (supplements != null && supplements instanceof Array) {
            _supplement = supplements[_index] as Dictionary;
        }

        View.onUpdate(dc);
        
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;
        var centerY = h / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // Draw Supplement name at the top
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, 60, Graphics.FONT_MEDIUM, _supplement["name"], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Calculate and Draw current amount
        var internalCount = _supplement["count"] as Number;
        var displayStr = "";
        var unitStr = "";
        
        if (_unit == 0) {
            displayStr = internalCount.toString();
            unitStr = "mg";
        } else {
            // Convert to grams, formatted to 1 decimal place if needed
            var grams = internalCount / 1000.0;
            displayStr = grams.format("%.1f");
            unitStr = "g";
        }
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 80, Graphics.FONT_NUMBER_HOT, displayStr, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Draw Toggle Switch (mg vs g) - Centered at centerY + 10, scaled up slightly to 100x50
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(centerX - 50, centerY - 15, 100, 50, 25);
        
        if (_unit == 0) {
            dc.fillRoundedRectangle(centerX - 50, centerY - 15, 50, 50, 25);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX - 25, centerY + 10, Graphics.FONT_XTINY, "mg", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX + 25, centerY + 10, Graphics.FONT_XTINY, "g", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            dc.fillRoundedRectangle(centerX, centerY - 15, 50, 50, 25);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX - 25, centerY + 10, Graphics.FONT_XTINY, "mg", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX + 25, centerY + 10, Graphics.FONT_XTINY, "g", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        
        // Draw "-" button (Left) - Centered at centerY + 10
        if (_mode == 0) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawCircle(80, centerY + 10, 25);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        dc.drawLine(65, centerY + 10, 95, centerY + 10);
        
        // Draw "+" button (Right) - Centered at centerY + 10
        if (_mode == 1) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawCircle(w - 80, centerY + 10, 25);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        dc.drawLine(w - 95, centerY + 10, w - 65, centerY + 10);
        dc.drawLine(w - 80, centerY - 5, w - 80, centerY + 25);
        dc.setPenWidth(1);

        // Draw quick add buttons (5, 10, 0, 100) in 2x2 grid (Trapezoid layout to fit curve)
        var btnWidth = 100;
        var btnHeight = 60;
        
        var topSpacing = 120; // pushed even further to sides
        var bottomSpacing = 15; // close together in middle
        
        var col1Top = centerX - btnWidth - (topSpacing / 2);
        var col2Top = centerX + (topSpacing / 2);
        
        var col1Bot = centerX - btnWidth - (bottomSpacing / 2);
        var col2Bot = centerX + (bottomSpacing / 2);
        
        var row1 = centerY + 65; // moved up slightly
        var row2 = centerY + 140;
        
        drawQuickButton(dc, col1Top, row1, btnWidth, btnHeight, "5");
        drawQuickButton(dc, col2Top, row1, btnWidth, btnHeight, "10");
        drawQuickButton(dc, col1Bot, row2, btnWidth, btnHeight, "0");
        drawQuickButton(dc, col2Bot, row2, btnWidth, btnHeight, "100");
    }

    private function drawQuickButton(dc as Dc, x as Number, y as Number, w as Number, h as Number, label as String) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawRectangle(x, y, w, h);
        dc.setPenWidth(1);
        dc.drawText(x + w / 2, y + h / 2, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() as Void {
    }

}
