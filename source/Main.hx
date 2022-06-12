package;

import flustix.fluXis.config.Config;
import flixel.FlxGame;
import flustix.fluXis.overlay.fps.FluXisFPS;
import flustix.fluXis.preloader.FluXisLoading;
import openfl.display.Sprite;

class Main extends Sprite {
	var instance:FlxGame;

	public function new() {
		super();
		Config.load();

		instance = new FlxGame(0, 0, FluXisLoading, 1, 120, 120, true, false);
		addChild(instance);
		addChild(new FluXisFPS());
	}
}
