package flustix.fluXis.utils;

import flustix.fluXis.integration.quaver.QuaverImport;
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
		SortUtils.sortSonglist();
    }

	public static function qp(p:String) {
		var splitPath = #if windows p.split("\\") #else p.split("/") #end;
		var fileName = splitPath[splitPath.length - 1];
		var fileNameSplit = fileName.split(".");
		var folderName = fileNameSplit[0];

		FluXis.log("Importing " + folderName);

		if (!FileSystem.exists('${FluXis.getDataPath()}data/import/${folderName}'))
			FileSystem.createDirectory('${FluXis.getDataPath()}data/import/${folderName}');
		else {
			FluXis.log("map already exists lmao");
			return;
		}

		ZipUtils.unzip(p, '${FluXis.getDataPath()}data/import/${folderName}');
		QuaverImport.importMap(folderName);
		SortUtils.sortSonglist();
	}
}