package flustix.fluXis.background;

import flustix.fluXis.config.Config;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flustix.fluXis.assets.Skin;

class FluXisBackground extends FlxTypedGroup<FlxBasic> {
	public function new() {
		super();

		var defaultbg = new FlxSprite().loadGraphic("assets/skin/gameplay/bg.png");
		defaultbg.setGraphicSize(FlxG.width);
		defaultbg.updateHitbox();
		defaultbg.antialiasing = true;
		add(defaultbg);

		var dim = FlxColor.fromHSL(0, 0, 1 - Config.get("ui", "bgdim"), 1);
		defaultbg.color = dim;
	}

	public function changebg(songID:String, top:Bool = false) { 
		var newbg = new FlxSprite(0, FlxG.height).loadGraphic(Skin.songBackground(songID));
		newbg.setGraphicSize(Std.int(FlxG.width * 1.1));
		newbg.updateHitbox();
		newbg.antialiasing = true;

		var dim = FlxColor.fromHSL(0, 0, Config.get("ui", "bgdim"), 1);
		newbg.color = dim;

		if (newbg.height < FlxG.height) {
			newbg.setGraphicSize(0, FlxG.height);
			newbg.updateHitbox();
		}

		newbg.screenCenter(X);
		add(newbg);

		if (top)
			newbg.y = 0 - newbg.height;

		FlxTween.tween(newbg, {y: (FlxG.height / 2) - (newbg.height / 2)}, 0.5, {
			ease: FlxEase.cubeOut,
			onComplete: (twn) -> {
				var toRemove = members.indexOf(newbg) - 1;
				remove(members[toRemove], true);
			}
		});
	}
}
