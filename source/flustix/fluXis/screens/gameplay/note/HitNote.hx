package flustix.fluXis.screens.gameplay.note;

import flustix.fluXis.config.Config;
import flixel.FlxG;
import flixel.FlxSprite;
import flustix.fluXis.assets.Skin;
import flustix.fluXis.song.Conductor;

class HitNote extends FlxSprite {
	public var noteTime:Float;
	public var noteLane:Int;
	public var noteHitable:Bool = false;
	public var noteMissed:Bool = false;
	public var noteAlreadyHit:Bool = false;
	public var noteType:NoteType = SINGLE;

	// hold note stuff
	public var noteSustainLength:Float;
	public var noteLinkedEnd:HitNote;
	public var noteLinkedHold:HitNote;
	public var noteHolding:Bool;

	public function new(time:Float, lane:Int, type:NoteType) {
		super();

		noteTime = time;
		noteLane = lane;
		noteType = type;

		loadGraphic(Skin.getTexture('note/${noteType == HOLD || noteType == HOLDEND ? "hold" : "hit"}${noteType == HOLDEND ? "End" : ""}${lane}'));
		setGraphicSize(19 * 6);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		noteHolding = false;

		if (Conductor.songPosition - noteTime > -150)
			noteHitable = true;
		else
			noteHitable = false;

		if (Conductor.songPosition - noteTime > 150)
			noteMissed = true;
		else
			noteMissed = false;
	}

	 public function sustainStuff() { // just dont ask, if anyone has a better way of doing this, please make a pull request
		if (noteType == HOLD) {
			var beginY = noteLinkedEnd.y + noteLinkedEnd.height;
			var endY = ((FlxG.height * 0.8) + 0.45 * ((Conductor.songPosition - noteTime) * Config.get("gameplay", "scrollspeed"))) + (114 / 2);

			if (Conductor.songPosition > noteTime)
				endY = (FlxG.height * 0.8) + (114 / 2);

			setGraphicSize(19 * 6, Std.int(endY - beginY));
			updateHitbox();
		}
	}
}

enum NoteType {
	SINGLE;
	HOLD;
	HOLDEND;
}
