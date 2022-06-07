package flustix.fluXis.song;

class Conductor {
	public static var songPosition:Float;
	public static var songBPM:Float = 100;
	public static var songCrochet:Float = ((60 / songBPM) * 1000);
	public static var songStepCrochet:Float = songCrochet / 4;

	public static function updateBPM(newBPM:Float) {
		songBPM = newBPM;
		songCrochet = ((60 / songBPM) * 1000);
		songStepCrochet = songCrochet / 4;
	}
}
