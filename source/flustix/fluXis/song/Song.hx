package flustix.fluXis.song;

import flustix.fluXis.song.SongData;
import haxe.Json;
import lime.system.System;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class Song {
	public static function loadSongs() {
		checkPath();
		var list = [];
		for (songFolder in FileSystem.readDirectory(FluXis.getDataPath() + "songs/")) {
			if (FileSystem.isDirectory(FluXis.getDataPath() + 'songs/${songFolder}/')) {
				for (songFile in FileSystem.readDirectory(FluXis.getDataPath() + 'songs/${songFolder}/')) {
					if (songFile == "metadata.fluxsm") {
						var leTempData = readMetaData(File.getContent(FluXis.getDataPath() + 'songs/' + songFolder + '/' + songFile));

						var map:SongMetaData = {
							artist: leTempData.artist,
							name: leTempData.name,
							diffs: leTempData.diffs,
							id: songFolder,
							charts: [],
							soundData: loadAudioFile(FluXis.getDataPath() + "songs/" + songFolder + "/audio.ogg")
						};

						for (diff in map.diffs) {
							var diffdata = loadDiff(songFolder, diff);
							if (diffdata != null)
								map.charts.push(diffdata);
						}

						if (map.charts.length > 0) {
							list.push(map);
						} else {
							trace('map ' + songFolder + ' does not have any diffs!');
						}

						leTempData = null;
					}
				}
			}
		}
		return list;
	}

	static function loadAudioFile(path:String) {
		if (!FileSystem.exists(path))
			path = path.replace(".ogg", ".mp3"); 

		var audioData:ByteArray = ByteArray.fromFile(path);
		var audio = new Sound();
		audio.loadCompressedDataFromByteArray(audioData, audioData.length);
		audioData = null;
		return audio;
	}

	static function loadDiff(folder:String, map:String) {
		for (newdiff in FileSystem.readDirectory(FluXis.getDataPath() + 'songs/' + folder)) {
			if (newdiff.endsWith(map + '.fluxsc')) {
				var chartData = readSongChart(File.getContent(FluXis.getDataPath() + 'songs/' + folder + '/' + newdiff));

				var mapdiff:SongChartData = {
					diffname: chartData.songDifficulty,
					bpm: chartData.songBpm,
					mapper: chartData.songMapper,
					notes: chartData.songNotes
				};
				chartData = null;
				return mapdiff;
			}
		}

		return null;
	}

	static function checkPath() {
		if (!FileSystem.exists(FluXis.getDataPath() + "songs")) {
			FileSystem.createDirectory(FluXis.getDataPath() + "songs");
		}
	}

	static function readMetaData(file:String):SongMetaDataJSON {
		return cast Json.parse(file).metadata;
	}

	static function readSongChart(file:String):SongChartDataJSON {
		return cast Json.parse(file).song;
	}
}
