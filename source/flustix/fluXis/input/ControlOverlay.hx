package flustix.fluXis.input;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class ControlOverlay extends FlxSpriteGroup {
	var colors = [0xFFe45801, 0xFFc5c5c5, 0xFFe45801, 0xFFc5c5c5];

	public var hitboxes:FlxSpriteGroup;

	public function new() {
		super();

		hitboxes = new FlxSpriteGroup();
		add(hitboxes);

		for (i in 0...4) {
			var box = new FlxSprite((FlxG.width * 0.25) * i, 0).makeGraphic(Std.int(FlxG.width * 0.25), FlxG.height, colors[i]);
			box.ID = i;
			hitboxes.add(box);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		#if mobile 
		Controls.update(hitboxes);
		#end
	}
}
