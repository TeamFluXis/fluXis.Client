package flustix.fluXis.overlay.fps;

import openfl.display.FPS;
import flustix.fluXis.assets.FluXisText;

/**
 * Basically 'openfl.display.FPS' but with a different font and text layout
 */
class FluXisFPS extends FPS {
	override function __enterFrame(deltaTime:Float) {
		super.__enterFrame(deltaTime);
        text = '${currentFPS} FPS';

		x = stage.stageWidth - width;
		y = stage.stageHeight - height - 40;
        textColor = 0xFFFFFF;
    }
}