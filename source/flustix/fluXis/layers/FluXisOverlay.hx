package flustix.fluXis.layers;

import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class FluXisOverlay extends FlxTypedGroup<FlxBasic> {
	public var client:FluXisClient;

	public function new() {
		super();
	}

    public function closeMenu() {
        client.closeOverlay();
    }
}
