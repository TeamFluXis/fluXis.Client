package flustix.fluXis.utils;

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

		if (!FileSystem.exists('${FluXis.getDataPath()}songs/${folderName}'))
			FileSystem.createDirectory('${FluXis.getDataPath()}songs/${folderName}');    
        else 
            return;

        ZipUtils.unzip(p, '${FluXis.getDataPath()}songs/${folderName}');
    }
}