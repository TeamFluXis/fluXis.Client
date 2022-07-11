package flustix.fluXis.utils;

import flustix.fluXis.song.SongData.SongMetaData;

class SortUtils {
	public static function sortSonglist() {
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