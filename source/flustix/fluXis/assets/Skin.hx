package flustix.fluXis.assets;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.typeLimit.OneOfTwo;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem;

class Skin {
	static var textSkin = "akiwi";

	public static function getTexture(tex:String):FlxGraphicAsset {
		if (FileSystem.exists(FluXis.getDataPath() + 'skins/${textSkin}/${tex}.png')) {
			return BitmapData.fromFile(FluXis.getDataPath() + 'skins/${textSkin}/${tex}.png');
		} else {
			return 'assets/skin/' + tex + '.png';
		}
	}

	public static function songBackground(songID:String):FlxGraphicAsset {
		if (FileSystem.exists(FluXis.getDataPath() + 'songs/${songID}/bg.png')) {
			return BitmapData.fromFile(FluXis.getDataPath() + 'songs/${songID}/bg.png');
		} else {
			return 'assets/skin/gameplay/bg.png';
		}
	}
	/* public static function getSound(snd:String):FlxSoundAsset {
		if (FileSystem.exists('skins/${textSkin}/${snd}.png')) {
			return new Sound().loadCompressedDataFromByteArray();
		} else {
			return 'assets/skin/' + snd + '.png';
		}
	}*/
}
