package flustix.fluXis.layers;

import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class FluXisScreen extends FlxTypedGroup<FlxBasic> {
	public var client:FluXisClient;
	public var allowInput:Bool = true;

	public function new() {
		super();
	}

	public function onBeat() {}

	public function onStep() {}
}
