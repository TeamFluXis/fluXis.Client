package flustix.fluXis.input;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

/**
 * used for mobile
 */
class Controls {
    #if mobile
	// just pressed
	public static var JPR = [false, false, false, false];
	// pressed
	public static var PR = [false, false, false, false];
	// released
	public static var RL = [false, false, false, false];

	public static function update(staticNotes:FlxSpriteGroup) {
		for (n in staticNotes) {
			var isTouched = false;
			for (t in FlxG.touches.list) {
				if (t.overlaps(n)) {
					if (!PR[n.ID])
						JPR[n.ID] = true;
					else
						JPR[n.ID] = false;

					PR[n.ID] = true;
					isTouched = true;
				}
			}
			if (!isTouched) {
				if (PR[n.ID])
					RL[n.ID] = true;
				else
					RL[n.ID] = false;

				PR[n.ID] = false;
			}

			n.alpha = PR[n.ID] ? 0.1 : 0.05;
		}

		if (FlxG.touches.list.length == 0) {
			for (n in staticNotes) {
				if (PR[n.ID])
					RL[n.ID] = true;
				else
					RL[n.ID] = false;

				PR[n.ID] = false;
				JPR[n.ID] = false;
			}
		}
	}

	public static function justTouched() {
		for (t in FlxG.touches.list) {
			if (t.justPressed)
				return true;
		}
		return false;
	}
    #end
}
