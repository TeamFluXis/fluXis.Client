package flustix.fluXis.screens.menu;

import flixel.FlxG;
import flixel.text.FlxText;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.screens.gameplay.GameplayScreen;

class MainMenuScreen extends FluXisScreen {
	public function new() {
		super();

		var text = new FlxText(0, 0, 0, "b");
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		#if desktop
		if (FlxG.keys.justPressed.ENTER) {
			FluXis.setScreen(new GameplayScreen());
		}
		#end
	}
}
