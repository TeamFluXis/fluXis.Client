package flustix.fluXis.ui;

import flixel.text.FlxText;

class FluXisText extends FlxText {
    public function new(X:Float, Y:Float, Text:String, Size:Int = 16) {
        super(X, Y, 0, Text, Size);

        antialiasing = true;
        font = "assets/skin/font/QuicksandSB.ttf";
    }

    public function setOutline(Thickness:Int = 2, Color:Int = 0xFF000000) {
        setBorderStyle(OUTLINE, Color, Thickness, 1);
    }
}