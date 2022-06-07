package;

import flustix.fluXis.screens.gameplay.GameplayScreen;
import flixel.FlxGame;
import flustix.fluXis.FluXisClient;
import flustix.fluXis.preloader.FluXisLoading;
import openfl.display.Sprite;

class Main extends Sprite {
	var instance:FlxGame;

	public function new() {
		super();

		instance = new FlxGame(0, 0, FluXisLoading, 1, 120, 120, true, false);
		addChild(instance);
	}
}
