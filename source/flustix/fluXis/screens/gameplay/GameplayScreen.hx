package flustix.fluXis.screens.gameplay;

import flustix.fluXis.utils.MathUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flustix.fluXis.assets.Skin;
import flustix.fluXis.config.Config;
import flustix.fluXis.integration.Discord;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.overlay.pause.PauseMenuOverlay;
import flustix.fluXis.screens.gameplay.note.HitNote;
import flustix.fluXis.screens.songselect.SongSelectScreen;
import flustix.fluXis.song.Conductor;
import flustix.fluXis.song.SongSession;
import flustix.fluXis.ui.FluXisText;

class GameplayScreen extends FluXisScreen {
	// notes
	var staticNotes:FlxSpriteGroup;
	var litStaticNotes:FlxSpriteGroup;
	var notes = new FlxTypedGroup<HitNote>();
	var ftrNotes:Array<HitNote> = [];

	// health
	var health = 2.00;
	var dispHealth = 2.00;
	var healthBar:FlxBar;
	var dead = false;

	// performance stuff
	var accuracy = 100.00;
	var dispAccuracy = 100.00;
	var grade = "X";
	var score = 0;
	var performance = new FluXisText(0, 20, '100%', 32);
	var scoreText = new FluXisText(20, 20, '0', 32);
	var judgements:JudgementCounter = {
		flawless: 0,
		perfect: 0,
		great: 0,
		alright: 0,
		okay: 0,
		miss: 0
	};

	// song time stuff
	var songStarting = true;
	var songPosition:Float = 0;
	var startTime:Float = 0;
	var endTime:Float = 0;
	var progressbar:FlxBar;
	var timeElapsed = new FluXisText(10, FlxG.height - 36, '', 16);
	var timeLeft = new FluXisText(0, FlxG.height - 36, '', 16);
	var percentText = new FluXisText(0, FlxG.height - 36, '', 16);

	public var paused = false;

	public function new() {
		super();

		staticNotes = new FlxSpriteGroup();
		genStaticNotes();
		staticNotes.screenCenter(X);
		add(staticNotes);

		litStaticNotes = new FlxSpriteGroup();
		genStaticNotes(true);
		litStaticNotes.screenCenter(X);
		add(litStaticNotes);

		add(notes);

		healthBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, 10, this, 'dispHealth', 0, 2);
		healthBar.createFilledBar(0x00000000, 0xFFFFFFFF);
		healthBar.numDivisions = 1000000;
		add(healthBar);

		add(performance);
		add(scoreText);

		progressbar = new FlxBar(0, FlxG.height - 10, LEFT_TO_RIGHT, FlxG.width, 10, this, 'songPosition', 0, 1);
		progressbar.createFilledBar(0x00000000, 0xFFFFFFFF);
		progressbar.numDivisions = 1000000;
		add(progressbar);

		add(timeElapsed);
		add(timeLeft);
		add(percentText);

		#if mobile
		add(new ControlOverlay());
		#end

		loadSong();

		#if cpp
		Discord.update({
			details: "Playing a song",
			state: '${SongSession.song.songName} - ${SongSession.song.songArtist} [${SongSession.song.songDifficulty}]',
			largeImageKey: "icon",
			largeImageText: "fluXis - v0.1-recode"
		});
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (songStarting) {
			Conductor.songPosition += elapsed * 1000;
			if (Conductor.songPosition >= 0) {
				songStarting = false;
				FlxG.sound.music.resume();
			}
		}

		songPosition = (Conductor.songPosition - startTime) / (endTime - startTime);

		percentText.text = songPosition > 0 ? '${FlxMath.roundDecimal(songPosition * 100, 2)}%' : "0%";
		percentText.screenCenter(X);

		timeLeft.text = FlxStringUtil.formatTime((Conductor.songPosition - startTime) / 1000);
		timeLeft.x = FlxG.width - timeLeft.width - 10;

		if (((Conductor.songPosition - startTime) / 1000) < 0) {
			timeElapsed.text = "-" + FlxStringUtil.formatTime(((Conductor.songPosition - startTime) / 1000) * -1);
		} else {
			timeElapsed.text = FlxStringUtil.formatTime((Conductor.songPosition - startTime) / 1000);
		}

		if (songPosition > 1 && notes.length == 0)
			endSong();

		if (FlxG.keys.justPressed.ONE)
			endSong();

		dispHealth = MathUtils.lerp(health, dispHealth, 0.94);
		dispAccuracy = MathUtils.lerp(accuracy, dispAccuracy, 0.94);

		if (health > 2)
			health = 2;

		if (health < 0 && !dead)
			onDeath();

		calculatePerformance();

		#if desktop
		if (FlxG.keys.justPressed.ESCAPE && !dead && !songStarting && !paused) {
			FlxG.sound.music.pause();
			client.setOverlay(new PauseMenuOverlay(this));
			paused = true;
		}
		#end

		if (!dead)
			updateInput();

		updateNotes();
	}

	function updateNotes() {
		for (note in ftrNotes) {
			if (note.noteTime - Conductor.songPosition < (2000 * Config.get("gameplay", "scrollspeed"))) {
				notes.add(note);
				ftrNotes.remove(note);
			}
		}

		notes.forEachAlive(function(note:HitNote) {
			note.y = staticNotes.members[note.noteLane].y + 0.45 * ((Conductor.songPosition - note.noteTime) * Config.get("gameplay", "scrollspeed"));
			note.x = staticNotes.members[note.noteLane].x;

			if (note.noteType == HOLDEND) {
				note.noteLinkedHold.y = note.y + note.height;
				note.noteLinkedHold.sustainStuff();
			}
			/* if (note.noteType == HOLDEND) {
				note.y = note.noteLinkedHold.y - note.height;
			}*/

			if (note.noteMissed) {
				if (note.noteType == HOLD) {
					if (!note.noteHolding && !note.noteLinkedEnd.noteHitable) {
						missNote(note);
					}
				} else {
					missNote(note);
				}
			}
		});
	}

	function updateInput() {
		if (paused)
			return;

		#if desktop
		// just pressed
		var JPR = [
			FlxG.keys.justPressed.A,
			FlxG.keys.justPressed.S,
			FlxG.keys.justPressed.K,
			FlxG.keys.justPressed.L
		];
		// pressed
		var PR = [
			FlxG.keys.pressed.A,
			FlxG.keys.pressed.S,
			FlxG.keys.pressed.K,
			FlxG.keys.pressed.L
		];
		// released
		var RL = [
			FlxG.keys.justReleased.A,
			FlxG.keys.justReleased.S,
			FlxG.keys.justReleased.K,
			FlxG.keys.justReleased.L
		];
		#elseif mobile
		// just pressed
		var JPR = Controls.JPR;
		// pressed
		var PR = Controls.PR;
		// released
		var RL = Controls.RL;
		#end

		if (JPR.contains(true)) {
			FlxG.sound.play("assets/skin/sound/hitsound/hit.ogg");

			var hitableNotes:Array<HitNote> = [];
			notes.forEachAlive(function(note:HitNote) {
				if (note.noteHitable && !note.noteMissed && note.noteType == SINGLE && JPR[note.noteLane]) {
					hitableNotes.push(note);
				}
			});
			hitableNotes.sort((a, b) -> Std.int(a.noteTime - b.noteTime));

			var lanes = [false, false, false, false];
			if (hitableNotes.length > 0) {
				for (note in hitableNotes) {
					if (!lanes[note.noteLane]) {
						hitNote(note);
						lanes[note.noteLane] = true;
					}
				}
			}
		}

		if (PR.contains(true)) {
			notes.forEachAlive(function(note:HitNote) {
				if (note.noteHitable && note.noteType == HOLD && PR[note.noteLane]) {
					note.noteHolding = true;
				}
			});
		}

		if (RL.contains(true)) {
			notes.forEachAlive(function(note:HitNote) {
				if (note.noteHitable && !note.noteMissed && note.noteType == HOLDEND && RL[note.noteLane]) {
					FlxG.sound.play("assets/skin/sound/hitsound/hit.ogg");
					hitNote(note);
				}
			});
		}

		litStaticNotes.forEach(function(lsnote:FlxSprite) {
			lsnote.visible = PR[lsnote.ID];
		});

		staticNotes.forEach(function(snote:FlxSprite) {
			snote.visible = !PR[snote.ID];
		});
	}

	function genStaticNotes(lit = false) {
		for (i in 0...4) {
			var sNote = new FlxSprite(0, FlxG.height * 0.8).loadGraphic(Skin.getTexture('note/static${i}${lit ? "-glow" : ""}'));
			sNote.setGraphicSize(19 * 6);
			sNote.updateHitbox();
			sNote.x = (19 * 6) * i;
			sNote.ID = i;
			lit ? litStaticNotes.add(sNote) : staticNotes.add(sNote);
		}
	}

	function loadSong() {
		startTime = SongSession.song.songNotes[0][0];
		endTime = SongSession.song.songNotes[SongSession.song.songNotes.length - 1][0];

		for (note in SongSession.song.songNotes) {
			if (note[2] > 0) {
				var noteHold = new HitNote(note[0], note[1], HOLD);
				noteHold.noteSustainLength = note[2];
				ftrNotes.push(noteHold);

				var noteEnd = new HitNote(note[0] + note[2], note[1], HOLDEND);
				ftrNotes.push(noteEnd);

				noteHold.noteLinkedEnd = noteEnd;
				noteEnd.noteLinkedHold = noteHold;
			}

			var newNote = new HitNote(note[0], note[1], SINGLE);
			notes.add(newNote);
		}

		FlxG.sound.playMusic(SongSession.song.soundData);
		FlxG.sound.music.time = 0;
		FlxG.sound.music.pause();
		Conductor.songPosition = -2000;
		songStarting = true;
	}

	function hitNote(note:HitNote) {
		timingCalculation(note);
		removeNote(note);
	}

	// imagine missing
	function missNote(note:HitNote) {
		if (dead)
			return;

		timingCalculation(note);
		removeNote(note);
	}

	function timingCalculation(note:HitNote) {
		var ms = Conductor.songPosition - note.noteTime;

		if (ms < 0)
			ms *= -1;

		var jugement = "";

		if (ms <= 18) {
			jugement = "Flawless";
			judgements.flawless++;
			health += 0.05;
		} else if (ms <= 40) {
			jugement = "Perfect";
			judgements.perfect++;
			health += 0.02;
		} else if (ms <= 75) {
			jugement = "Great";
			judgements.great++;
			health += 0.01;
		} else if (ms <= 100) {
			jugement = "Alright";
			judgements.alright++;
		} else if (ms <= 140) {
			jugement = "Okay";
			judgements.okay++;
			health -= 0.1;
		} else {
			jugement = "Miss";
			judgements.miss++;
			health -= 0.2;
		}

		jugementPopUp(jugement);
	}

	function jugementPopUp(jugementString:String) {
		var jugement = new FluXisText(0, 0, jugementString, 28);
		jugement.setOutline();
		jugement.screenCenter(X);
		jugement.y = FlxG.height * 0.6;
		jugement.maxVelocity.y = 600;
		jugement.acceleration.y = 300;
		add(jugement);

		FlxTween.tween(jugement, {alpha: 0}, 0.6, {
			onComplete: (twn) -> {
				jugement.kill();
				remove(jugement);
				jugement.destroy();
			}
		});
	}

	function removeNote(note:HitNote, ?howDoICallThis = false) {
		if (!howDoICallThis) {
			if (note.noteType == HOLD) {
				removeNote(note.noteLinkedEnd, true);
			}
			if (note.noteType == HOLDEND) {
				removeNote(note.noteLinkedHold, true);
			}
		}

		note.kill();
		notes.remove(note, true);
		note.destroy();
	}

	var grades:Array<Dynamic> = [["X", 100], ["O", 99], ["A+", 98], ["A", 90], ["B", 80], ["C", 70]];

	function calculatePerformance() {
		var notesHit = judgements.flawless + judgements.perfect + judgements.great + judgements.alright + judgements.okay;
		var notesRated = (judgements.flawless) + (judgements.perfect * 0.98) + (judgements.great * 0.65) + (judgements.alright * 0.25)
			+ (judgements.okay * 0.1);
		var notesTotal = notesHit + judgements.miss;

		// accuracy
		accuracy = (notesRated / notesTotal) * 100;

		if (notesTotal == 0)
			accuracy = 100;

		accuracy = FlxMath.roundDecimal(accuracy, 2);

		// grade
		for (g in grades) {
			if (accuracy >= g[1]) {
				grade = g[0];
				break;
			}
			grade = "D";
		}

		performance.text = '${grade} - ${FlxMath.roundDecimal(dispAccuracy, 2), 2)}%';
		performance.x = FlxG.width - performance.width - 20;

		var totalHits = 0;
		for (note in SongSession.song.songNotes) {
			totalHits++;
			if (note[2] > 0)
				totalHits++;
		}
		score = Math.floor(1000000 * (notesRated / (totalHits)));

		scoreText.text = '${score}';
		while (scoreText.text.length < 7)
			scoreText.text = '0${scoreText.text}'; // this is dumb
	}

	function onDeath() {
		dead = true;
		FlxTween.tween(client, {musicSpeed: 0}, 1.6);
		client.screenCamera.flash(0xFFFF5555, 1.6);

		new FlxTimer().start(0.6, (tmr) -> {
			endSong();
		});
	}

	function endSong() {
		for (i in 0...4) {
			FlxTween.tween(staticNotes.members[i], {y: FlxG.height, alpha: 0}, 0.4, {startDelay: 0.1 * i, ease: FlxEase.cubeInOut});
			FlxTween.tween(litStaticNotes.members[i], {y: FlxG.height, alpha: 0}, 0.4, {startDelay: 0.1 * i, ease: FlxEase.cubeInOut});
		}

		notes.forEachAlive((note) -> {
			FlxTween.tween(note, {alpha: 0}, 0.4, {ease: FlxEase.cubeInOut});
		});

		FlxTween.tween(healthBar, {y: 0 - healthBar.height}, 0.4, {ease: FlxEase.cubeInOut});
		FlxTween.tween(performance, {y: 0 - performance.height}, 0.4, {ease: FlxEase.cubeInOut});
		FlxTween.tween(scoreText, {y: 0 - scoreText.height}, 0.4, {ease: FlxEase.cubeInOut});

		FlxTween.tween(timeElapsed, {y: FlxG.height}, 0.4, {ease: FlxEase.cubeInOut});
		FlxTween.tween(percentText, {y: FlxG.height}, 0.4, {ease: FlxEase.cubeInOut});
		FlxTween.tween(timeLeft, {y: FlxG.height}, 0.4, {ease: FlxEase.cubeInOut});
		FlxTween.tween(progressbar, {y: FlxG.height}, 0.4, {ease: FlxEase.cubeInOut});

		new FlxTimer().start(0.8, (tmr) -> {
			FluXis.setScreen(new SongSelectScreen(dead));
		});
	}
}

typedef JudgementCounter = {
	var flawless:Int;
	var perfect:Int;
	var great:Int;
	var alright:Int;
	var okay:Int;
	var miss:Int;
}
