package flustix.fluXis.background;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flustix.fluXis.assets.Skin;

class FluXisBackground extends FlxTypedGroup<FlxBasic> {
	var currentBGs:Array<FlxSprite> = [];

	public function new() {
		super();

		var defaultbg = new FlxSprite().loadGraphic("assets/skin/gameplay/bg.png");
		defaultbg.setGraphicSize(FlxG.width);
		defaultbg.updateHitbox();
		currentBGs[0] = defaultbg;
		add(currentBGs[0]);
	}

	public function changebg(songID:String) {
		var newbg = new FlxSprite().loadGraphic(Skin.songBackground(songID));
		newbg.setGraphicSize(FlxG.width);
		newbg.updateHitbox();

		if (newbg.height < FlxG.height) {
			newbg.setGraphicSize(0, FlxG.height);
			newbg.updateHitbox();
		}

		newbg.alpha = 0;
		add(newbg);
		currentBGs.push(newbg);

		FlxTween.tween(newbg, {alpha: 1}, 0.3, {
			onComplete: (twn) -> {
				var toRemove = currentBGs.indexOf(newbg) - 1;
				currentBGs[toRemove].kill();
				remove(currentBGs[toRemove]);
				currentBGs[toRemove].destroy();
				currentBGs.remove(currentBGs[toRemove]);
			}
		});
	}
}
