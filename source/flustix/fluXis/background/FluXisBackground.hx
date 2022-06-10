package flustix.fluXis.background;

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
	}

	public function changebg(songID:String) {
		var newbg = new FlxSprite().loadGraphic(Skin.songBackground(songID));
		newbg.setGraphicSize(FlxG.width);
		newbg.updateHitbox();
		newbg.antialiasing = true;

		if (newbg.height < FlxG.height) {
			newbg.setGraphicSize(0, FlxG.height);
			newbg.updateHitbox();
		}

		newbg.alpha = 0;
		newbg.screenCenter();
		add(newbg);

		FlxTween.tween(newbg, {alpha: 1}, 0.3, {
			onComplete: (twn) -> {
				var toRemove = members.indexOf(newbg) - 1;
				remove(members[toRemove], true);
			}
		});
	}
}
