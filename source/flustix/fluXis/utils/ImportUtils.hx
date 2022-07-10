package flustix.fluXis.utils;

import flustix.fluXis.song.SongData.SongMetaData;
import flustix.fluXis.song.Song;
import sys.FileSystem;
using StringTools;

/**
* Importing utils for supported file types
*/
class ImportUtils {
    public static function fluxmp(p:String) {
		var splitPath = #if windows p.split("\\") #else p.split("/") #end;
		var fileName = splitPath[splitPath.length - 1];
		var fileNameSplit = fileName.split(".");
		var folderName = fileNameSplit[0];

		FluXis.log("Importing " + folderName);

		if (!FileSystem.exists('${FluXis.getDataPath()}songs/${folderName}'))
			FileSystem.createDirectory('${FluXis.getDataPath()}songs/${folderName}');
		else {
			FluXis.log("map already exists lmao");
			return;
		}

        ZipUtils.unzip(p, '${FluXis.getDataPath()}songs/${folderName}');
		Song.addSong(folderName, FluXis.songs);
		
		FluXis.songs.sort(function(a:SongMetaData, b:SongMetaData):Int {
			var a2 = a.name.toUpperCase();
			var b2 = b.name.toUpperCase();

			if (a2 < b2) {
				return -1;
			} else if (a2 > b2) {
				return 1;
			} else {
				return 0;
			}
		});
    }
}