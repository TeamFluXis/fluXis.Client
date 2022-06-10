package flustix.fluXis;

import flixel.FlxG;
import flixel.FlxState;
import flustix.fluXis.background.FluXisBackground;
import flustix.fluXis.layers.FluXisScreen;
import flustix.fluXis.song.Conductor;
import lime.media.openal.AL;

class FluXisClient extends FlxState {
	// layers
	public var bg:FluXisBackground;
	public var screen:FluXisScreen;

	// music stuff
	public var curBeat:Int;
	public var curStep:Int;
	var lastStep:Int;
	public var musicSpeed = 1.00;

	public function new(initScreen:FluXisScreen) {
		super();
		screen = initScreen;
	}

	override function create() {
		super.create();

		bg = new FluXisBackground();
		add(bg);

		screen.client = this;
		add(screen);
	}

	public function updateScreen(newScreen:FluXisScreen) {
		remove(screen);
		screen = newScreen;
		@:privateAccess { // guess i'll force my way into it :shrug:
			FlxG.inputs.onStateSwitch();
		}
		screen.client = this;
		add(screen);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;

		lastStep = curStep;
		updateStep();
		updateBeat();

		if (lastStep != curStep) {
			screen.onStep();
			if (curStep % 4 == 0)
				screen.onBeat();
		}

		if (FlxG.sound.music != null && FlxG.sound.music.playing) {
			@:privateAccess {
				AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, AL.PITCH, musicSpeed);
			}
		}
	}

	function updateStep() {
		curStep = Math.floor(Conductor.songPosition / Conductor.songStepCrochet);
	}

	function updateBeat() {
		curBeat = Math.floor(curStep / 4);
	}
}
