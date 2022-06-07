package flustix.fluXis.layers;

import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import haxe.PosInfos;

class FluXisScreen extends FlxTypedGroup<FlxBasic> {
	public var client:FluXisClient;

	public function new() {
		super();
	}

	public function onBeat() {}

	public function onStep() {}
}
