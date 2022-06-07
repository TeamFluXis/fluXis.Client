package flustix.fluXis;

import flixel.FlxG;
import flustix.fluXis.FluXisClient;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.song.SongData.SongMetaData;
import haxe.PosInfos;
import lime.system.System;

class FluXis {
	static var client:FluXisClient;
	public static var songs:Array<SongMetaData>;

	@:allow(flustix.fluXis.preloader.FluXisLoading)
	static function setClient(newClient:FluXisClient) {
		client = newClient;
		FlxG.switchState(client);
	}

	public static function setScreen(newScreen:FluXisScreen) {
		client.updateScreen(newScreen);
	}

	public static function getClient() {
		return client;
	}

	public static dynamic function log(s:Dynamic, ?pos:PosInfos) {
		var splitClassName = pos.className.split(".");
		var className = splitClassName[splitClassName.length - 1];
		Sys.println('[fluXis | ${className}.${pos.methodName}():${pos.lineNumber}] ${Std.string(s)}');
	}

	public static function getDataPath() {
		#if desktop
		return System.applicationStorageDirectory + "/";
		#else
		return "/sdcard/fluxis/";
		#end
	}
}
