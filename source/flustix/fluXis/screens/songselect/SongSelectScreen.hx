package flustix.fluXis.screens.songselect;

import flixel.tweens.FlxTween;
import flustix.fluXis.screens.menu.MainMenuScreen;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.screens.gameplay.GameplayScreen;
import flustix.fluXis.screens.songselect.ui.SongBox;
import flustix.fluXis.song.SongSession;

class SongSelectScreen extends FluXisScreen {
	var songGrp = new FlxTypedGroup<SongBox>();

	public function new(?wasDead:Bool) {
		super();

		if (wasDead)
				FlxTween.tween(FluXis.getClient(), {musicSpeed: 1}, 0.3);

		add(songGrp);

		for (i in 0...FluXis.songs.length) {
			var songBox = new SongBox(FluXis.songs[i], songGrp);
			songBox.ID = i;
			songGrp.add(songBox);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		for (box in songGrp.members) {
			box.selected = SongSession.curSong == box.ID;
		}

		#if desktop
		if (FlxG.keys.justPressed.UP)
			changeSelec(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelec(1);
		if (FlxG.keys.justPressed.ENTER)
			acceptSelec();

		if (FlxG.keys.justPressed.ESCAPE)
			client.updateScreen(new MainMenuScreen());
		#end

		#if mobile
		if (Controls.justTouched())
			acceptSelec();
		#end
	}

	function changeSelec(by:Int = 0) {
		var prevSong = SongSession.curSong;
		SongSession.curSong += by;

		if (SongSession.curSong < 0)
			SongSession.curSong = 0;

		if (SongSession.curSong > FluXis.songs.length - 1)
			SongSession.curSong = FluXis.songs.length - 1;

		if (prevSong != SongSession.curSong) {
			client.bg.changebg(FluXis.songs[SongSession.curSong].id, by < 0);
			FlxG.sound.playMusic(FluXis.songs[SongSession.curSong].soundData);
		}
	}

	function acceptSelec() {
		SongSession.song = {
			songName: FluXis.songs[SongSession.curSong].name,
			songArtist: FluXis.songs[SongSession.curSong].artist,
			songMapper: FluXis.songs[SongSession.curSong].charts[0].mapper,
			songDifficulty: FluXis.songs[SongSession.curSong].charts[0].diffname,
			songBPM: FluXis.songs[SongSession.curSong].charts[0].bpm,
			songNotes: FluXis.songs[SongSession.curSong].charts[0].notes,
			songID: FluXis.songs[SongSession.curSong].id,
			soundData: FluXis.songs[SongSession.curSong].soundData
		};
		FluXis.setScreen(new GameplayScreen());
	}
}
