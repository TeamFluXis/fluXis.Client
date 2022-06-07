package flustix.fluXis.preloader;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flustix.fluXis.screens.gameplay.GameplayScreen;
import flustix.fluXis.screens.songselect.SongSelectScreen;
import flustix.fluXis.song.Song;
import flustix.fluXis.song.SongSession;
import sys.thread.Thread;

class FluXisLoading extends FlxState {
	override function create() {
		super.create();
		#if desktop
		FlxG.mouse.useSystemCursor = true;
		#end

		var fluXisText = new FlxText(0, 0, 0, "fluXis", 64);
		fluXisText.screenCenter();
		add(fluXisText);

		Thread.create(() -> {
			FluXis.songs = Song.loadSongs();
			FluXis.log("Loaded songs!");
			FluXis.setClient(new FluXisClient(new SongSelectScreen()));
		});
	}
}
