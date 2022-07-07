package flustix.fluXis.ui;

import flixel.tweens.FlxEase;
import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

/**
*   FlxSprite with more stuff
*/
class FluXisSprite extends FlxSprite {
    // hover stuff
	public var hovering:Bool = false;
	var direction:HoverDirection = RETURN;
    var tween:VarTween = null;
    public var hoverData:HoverAnimation = {
        time: 0,
        normal: {},
        hovered: {}
    };

    public function new(spr:FlxGraphicAsset) {
        super();
        loadGraphic(spr);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (hovering)
            hover();
		else
			unHover();
    }

    function hover() {
		if (direction != HOVER) {
			direction = HOVER;

            var percent = 1.0;
            if (tween != null)
                percent = tween.percent;

			FlxTween.cancelTweensOf(this);
			tween = FlxTween.tween(this, hoverData.hovered, hoverData.time * (1 - percent));
        }
    }

	function unHover() {
		if (direction != RETURN) {
			direction = RETURN;

			var percent = 1.0;
			if (tween != null)
				percent = tween.percent;

            FlxTween.cancelTweensOf(this);
			tween = FlxTween.tween(this, hoverData.normal, hoverData.time * (1 - percent));
        }
    }
}

typedef HoverAnimation = {
	var time:Float;
	var normal:Dynamic;
	var hovered:Dynamic;
    var ?ease:FlxEase;
}

enum HoverDirection {
    HOVER;
    RETURN;
}