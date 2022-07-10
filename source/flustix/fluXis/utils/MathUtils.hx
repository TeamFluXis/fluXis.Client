package flustix.fluXis.utils;

import flustix.fluXis.config.Config;
import flixel.math.FlxMath;

class MathUtils {
	/**
	 * A fps based lerp.
	 */
	public static function lerp(a:Float, b:Float, r:Float) {
		return FlxMath.lerp(a, b, r * (Config.get("display", "framerate") / 360));
	}
}
