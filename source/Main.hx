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

		var gameW:Int = Config.get("display", "width");
		var gameH:Int = Config.get("display", "height");
		var gameFullscreen:Bool = Config.get("display", "fullscreen");
		var gameFramerate:Int = Config.get("display", "framerate");

		var screenW:Float = Capabilities.screenResolutionX;
		var screenH:Float = Capabilities.screenResolutionY;

		if (gameFullscreen) {
			gameW = Std.int(screenW);
			gameH = Std.int(screenH);
		}

		Lib.current.stage.window.width = gameW;
		Lib.current.stage.window.height = gameH;
		Lib.current.stage.window.x = Std.int((screenW - gameW) / 2);
		Lib.current.stage.window.y = Std.int((screenH - gameH) / 2);
		Lib.current.stage.frameRate = gameFramerate;

		instance = new FlxGame(gameW, gameH, FluXisLoading, 1, gameFramerate, gameFramerate, true, gameFullscreen);
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
