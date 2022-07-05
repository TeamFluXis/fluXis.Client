package flustix.fluXis.utils;

import haxe.crypto.Crc32;
import haxe.zip.Entry;
import haxe.zip.Writer;
import sys.FileSystem;
import sys.io.File;
import haxe.zip.Reader;

using StringTools;

/**
* things for unziping and zipping stuff
*/
class ZipUtils {
    /**
    * Unzip a file to a directory
    * @param zipFile The zip file to unzip
    * @param destDir The directory to unzip to
    */
	public static function unzip(zipFile:String, destDir:String):Void {
		if (!destDir.endsWith("/"))
			destDir += "/";

		var el = Reader.readZip(File.read(zipFile));
        for (e in el) {
            var b = Reader.unzip(e);
			File.saveBytes('${destDir}${e.fileName}', b);
        }
    }

    /**
    * Creates a zip file from a directory.
    * @param dirPath The path to the directory to zip.
    * @param destPath The path to the destination zip file.
    */
	public static function zip(dirPath:String, destPath:String) {
		if (!dirPath.endsWith("/"))
			dirPath += "/";

		var l = new List<Entry>();
		var o = File.write('${destPath}');
		var z = new Writer(o);
		for (s in FileSystem.readDirectory(dirPath)) {
			var f = File.read(dirPath + s);
			var b = f.readAll();

			var e:Entry = {
				fileName: s,
				fileSize: b.length,
				fileTime: Date.now(),
				compressed: false,
				dataSize: b.length,
				data: b,
				crc32: Crc32.make(b)
			};
			l.add(e);
		};
		z.write(l);
		o.flush();
	}
}