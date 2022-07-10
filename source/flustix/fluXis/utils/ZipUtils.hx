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
		#if windows
		Sys.command('util\\7z\\7za.exe x ${zipFile} -o${destDir} -r');
		#else
		Sys.command('unzip ${zipFile} -d ${destDir}');
		#end
    }

    /**
    * Creates a zip file from a directory.
    * @param dirPath The path to the directory to zip.
    * @param destPath The path to the destination zip file.
    */
	public static function zip(dirPath:String, destPath:String) {
		// todo: make this shit
	}
}