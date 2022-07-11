package flustix.fluXis.integration.quaver;

import flustix.fluXis.song.Song;
import haxe.Json;
import flustix.fluXis.song.SongData.SongChartDataJSON;
import flustix.fluXis.integration.quaver.QuaverData;
import yaml.Parser;
import yaml.Yaml;
import sys.io.File;
import sys.FileSystem;
import flustix.fluXis.song.SongData.SongMetaDataJSON;

using StringTools;

class QuaverImport {
    public static function importMap(id:String) {
		if (!FileSystem.exists('${FluXis.getDataPath()}songs/${id}')) {
			var maps:Array<QuaverData> = [];
			var mapsFileNames:Array<String> = [];

			for (file in FileSystem.readDirectory('${FluXis.getDataPath()}data/import/${id}')) {
				if (file.endsWith(".qua")) {
					var qdata:QuaverData = cast Yaml.read('${FluXis.getDataPath()}data/import/${id}/${file}', Parser.options().useObjects());
					maps.push(qdata);
					mapsFileNames.push(file);
				}
			}
			if (maps.length > 0) {
				try {
					convert(maps, mapsFileNames, id);
				} catch (ex) {
                    FluXis.log('Error while converting map: ${ex}');
				}
			}
        }
    }

	static function convert(maps:Array<QuaverData>, filenames:Array<String>, id:String) {
		var metadata:SongMetaDataJSON = {
			name: maps[0].Title,
			artist: maps[0].Artist,
			diffs: []
		}

		FileSystem.createDirectory('${FluXis.getDataPath()}songs/${id}');

		copy('${FluXis.getDataPath()}data/import/${id}/${maps[0].AudioFile}', '${FluXis.getDataPath()}songs/${id}/audio.ogg');

		if (maps[0].BackgroundFile != "" || maps[0].BackgroundFile != null) {
			copy('${FluXis.getDataPath()}data/import/${id}/${maps[0].BackgroundFile}', '${FluXis.getDataPath()}songs/${id}/bg.png');
		}

		for (diffname in filenames) {
			metadata.diffs.push(diffname.replace(".qua", ""));
		}

		var i = 0;
		for (qmap in maps) {
			var chart:SongChartDataJSON = {
				songMapper: qmap.Creator,
				songNotes: convertNotes(qmap.HitObjects),
				songBpm: qmap.TimingPoints[0].Bpm,
				songDifficulty: qmap.DifficultyName
			}
			File.saveContent('${FluXis.getDataPath()}songs/${id}/${filenames[i].replace(".qua", "")}.fluxsc', Json.stringify({song: chart}));
			i++;
		}

		File.saveContent('${FluXis.getDataPath()}songs/${id}/metadata.fluxsm', Json.stringify({metadata: metadata}));
        Song.addSong(id, FluXis.songs);
    }

	static function convertNotes(hits:Array<QuaverHitObject>):Array<Dynamic> {
		var notes:Array<Dynamic> = [];

		for (hit in hits) {
			var note:Array<Dynamic> = [];

			note[0] = hit.StartTime;
			note[1] = hit.Lane - 1;
			if (hit.EndTime != 0)
				note[2] = hit.EndTime - hit.StartTime;
			else
				note[2] = 0;

			notes.push(note);
		}

		notes.sort(function(a:Array<Dynamic>, b:Array<Dynamic>):Int {
			var a2 = a[0];
			var b2 = b[0];

			if (a2 < b2) {
				return -1;
			} else if (a2 > b2) {
				return 1;
			} else {
				return 0;
			}
		});
		return notes;
	}

	static function copy(from:String, to:String) {
		var fromBytes = File.getBytes(from);
		File.saveBytes(to, fromBytes);
	}
}