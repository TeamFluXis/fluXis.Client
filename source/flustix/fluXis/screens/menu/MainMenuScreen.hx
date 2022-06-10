package flustix.fluXis.screens.menu;

import flixel.FlxG;
import flustix.fluXis.assets.FluXisText;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.screens.songselect.SongSelectScreen;

class MainMenuScreen extends FluXisScreen {
	public function new() {
		super();

		var text = new FluXisText(0, 0, "b");
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		#if desktop
		if (FlxG.keys.justPressed.ENTER) {
			FluXis.setScreen(new SongSelectScreen());
		}
		#end
	}
}
