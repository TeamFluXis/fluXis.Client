package;

import openfl.system.Capabilities;
import flustix.fluXis.utils.ImportUtils;
import openfl.Lib;
import flustix.fluXis.FluXis;
import flustix.fluXis.config.Config;
import flixel.FlxGame;
import flustix.fluXis.overlay.fps.FluXisFPS;
import flustix.fluXis.preloader.FluXisLoading;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite {
	var instance:FlxGame;

	public function new() {
		super();
		Config.load();

		Lib.current.stage.window.onDropFile.add(onFileDropped);

		instance = new FlxGame(Std.int(Capabilities.screenResolutionX), Std.int(Capabilities.screenResolutionY), FluXisLoading, 1, 120, 120, true, true);
		addChild(instance);
		addChild(new FluXisFPS());
	}

	private function onFileDropped(filePath:String):Void {
		FluXis.log("File dropped: " + filePath);

		#if neko
		if (filePath.endsWith(".fluxmp"))
			ImportUtils.fluxmp(filePath);
		#else
		return;
		#end
	}
}
