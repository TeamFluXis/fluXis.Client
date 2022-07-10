package flustix.fluXis;

import flixel.tweens.FlxTween;
import flustix.fluXis.config.Config;
import openfl.filters.BitmapFilterQuality;
import openfl.filters.BlurFilter;
import flixel.FlxCamera;
import flustix.fluXis.layers.FluXisOverlay;
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
	public var overlay:FluXisOverlay;

	// layer cameras
	public var bgCamera:FlxCamera;
	public var screenCamera:FlxCamera;
	public var overlayCamera:FlxCamera;

	// camera filters
	var blurFilter = new BlurFilter(50 * Config.get("ui", "bgblur"), 50 * Config.get("ui", "bgblur"), BitmapFilterQuality.HIGH);

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

		FlxG.autoPause = false;

		bgCamera = new FlxCamera();
		bgCamera.bgColor = 0x00000000;
		bgCamera.setFilters([blurFilter]);
		FlxG.cameras.add(bgCamera);

		screenCamera = new FlxCamera();
		screenCamera.bgColor = 0x00000000;
		FlxG.cameras.add(screenCamera);

		overlayCamera = new FlxCamera();
		overlayCamera.bgColor = 0x00000000;
		FlxG.cameras.add(overlayCamera);

		bg = new FluXisBackground();
		bg.cameras = [FlxG.camera, bgCamera];
		add(bg);

		screen.client = this;
		screen.camera = screenCamera;
		add(screen);
	}

	public function updateScreen(newScreen:FluXisScreen) {
		remove(screen);
		screen = newScreen;
		@:privateAccess { // guess i'll force my way into it :shrug:
			FlxG.inputs.onStateSwitch();
		}
		screen.client = this;
		screen.camera = screenCamera;
		add(screen);
	}

	public function setOverlay(newOverlay:FluXisOverlay) {
		closeOverlay();
		overlay = newOverlay;
		overlay.client = this;
		overlay.camera = overlayCamera;
		add(overlay);
	}

	public function closeOverlay() {
		if (overlay == null)
			return;

		remove(overlay);
		overlay = null;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.playing) {
			if (Config.get("gameplay", "smoothsync")) { // aparently this doesnt work very well sometimes so i made it a setting
				Conductor.songPosition += elapsed * 1000;
				if (Conductor.songPosition - FlxG.sound.music.time > 16 || Conductor.songPosition - FlxG.sound.music.time < -16) {
					resyncMusic();
				}
			} else {
				resyncMusic();
			}
		}

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

			if (FlxG.keys.pressed.CONTROL) {
				if (FlxG.keys.justPressed.COMMA) {
					musicSpeed -= 0.1;
				}
				if (FlxG.keys.justPressed.PERIOD) {
					musicSpeed += 0.1;
				}
			}
		}
	}

	function updateStep() {
		curStep = Math.floor(Conductor.songPosition / Conductor.songStepCrochet);
	}

	function updateBeat() {
		curBeat = Math.floor(curStep / 4);
	}

	function resyncMusic() {
		Conductor.songPosition = FlxG.sound.music.time;
	}

	function changeVolume(to:Float) {
		FlxTween.tween(FlxG.sound, {volume: to}, 0.1);
	}
}
