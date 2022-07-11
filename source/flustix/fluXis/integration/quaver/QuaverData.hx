package flustix.fluXis.integration.quaver;

typedef QuaverData = {
	var Title:String;
	var Artist:String;
	var DifficultyName:String;
	var Creator:String;
	var AudioFile:String;
	var BackgroundFile:String;

	var HitObjects:Array<QuaverHitObject>;
	var TimingPoints:Array<QuaverTimingPoint>;
}

typedef QuaverHitObject = {
	var StartTime:Int;
	var EndTime:Int;
	var Lane:Int;
}

typedef QuaverTimingPoint = {
	var Bpm:Int;
}