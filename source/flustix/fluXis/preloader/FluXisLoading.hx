package flustix.fluXis.preloader;

import flustix.fluXis.utils.SortUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flustix.fluXis.screens.gameplay.GameplayScreen;
import flustix.fluXis.screens.menu.MainMenuScreen;
import flustix.fluXis.screens.songselect.SongSelectScreen;
import flustix.fluXis.song.Song;
import flustix.fluXis.song.SongSession;
import flustix.fluXis.ui.FluXisText;
import sys.thread.Thread;

class FluXisLoading extends FlxState {
	var ready = false;
	var textGrp = new FlxSpriteGroup(); // makes centering easier
	var overlay:FlxSprite;

	override function create() {
		super.create();
		#if desktop
		FlxG.mouse.useSystemCursor = true;
		#end
		FlxG.autoPause = false;

		add(textGrp);

		var fluXisText = new FluXisText(0, 0, "welcome to fluXis!", 64);
		fluXisText.screenCenter(X);
		textGrp.add(fluXisText);

		var infoText = new FluXisText(0, 100,
			"an open-source vertical scrolling rhythm game.\n\nthis project is still very in development.\nif encounter any bugs, please report them on the github!",
			28);
		infoText.alignment = CENTER;
		infoText.screenCenter(X);
		textGrp.add(infoText);

		textGrp.screenCenter(Y);

		var continueText = new FluXisText(0, FlxG.height * 0.8, "press any key to continue.");
		continueText.alpha = 0;
		continueText.screenCenter(X);
		add(continueText);

		overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		add(overlay);
		FlxTween.tween(overlay, {alpha: 0}, 0.6);

		Thread.create(() -> {
			FluXis.songs = Song.loadSongs();
			SortUtils.sortSonglist();
			FluXis.log("Loaded songs!");
			FlxTween.tween(continueText, {alpha: 1}, 0.8);
			ready = true;
		});
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ANY && ready)
			contineToGame();
	}

	function contineToGame() {
		ready = false;
		FlxTween.tween(overlay, {alpha: 1}, 0.6, {
			onComplete: (twn) -> {
				FluXis.setClient(new FluXisClient(new MainMenuScreen()));
			}
		});
	}
}
