package flustix.fluXis.song;

import openfl.media.Sound;

typedef SongData = {
	var songName:String;
	var songArtist:String;
	var songMapper:String;
	var songDifficulty:String;
	var songBPM:Float;
	var songNotes:Array<Dynamic>;
	var songID:String;
	var soundData:Sound;
}

typedef SongMetaData = {
	var name:String;
	var artist:String;
	var diffs:Array<String>;
	var charts:Array<SongChartData>;
	var id:String;
	var soundData:Sound;
}

typedef SongChartData = {
	var diffname:String;
	var notes:Array<Dynamic>;
	var bpm:Float;
	var mapper:String;
}

// stuff loaded from the json files
typedef SongMetaDataJSON = {
	var name:String;
	var artist:String;
	var diffs:Array<String>;
}

typedef SongChartDataJSON = {
	var songDifficulty:String;
	var songNotes:Array<Dynamic>;
	var songBpm:Float;
	var songMapper:String;
}
