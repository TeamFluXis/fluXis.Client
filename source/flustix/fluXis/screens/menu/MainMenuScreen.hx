package flustix.fluXis.screens.menu;

import flixel.FlxG;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.screens.songselect.SongSelectScreen;
import flustix.fluXis.ui.FluXisText;

class MainMenuScreen extends FluXisScreen {
	public function new() {
		super();

		var text = new FluXisText(0, 0, "this is a very cool main menu");
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
