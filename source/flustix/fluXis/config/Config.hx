package flustix.fluXis.config;

import sys.io.File;
import haxe.Json;

class Config {
    static var conf:Map<String, ConfigCategory> = [];
    static var confjson:Dynamic;

    public static function load() {
		try {
			confjson = Json.parse(File.getContent(FluXis.getDataPath() + "config.fluxcfg"));
        } catch (ex) {
            confjson = Json.parse("{}"); // create new config
        }

        var gameplay = new ConfigCategory("gameplay", confjson);
        gameplay.addEntry("scrollspeed", 3);
        addCat(gameplay);

        save();
    }

    static function addCat(cat:ConfigCategory) {
        conf.set(cat.catName, cat);
    }

    public static function get(cat:String, entry:String):Dynamic {
        try {
            return conf[cat].getEntry(entry).value;
        } catch (ex) {
            FluXis.log(ex.toString());
            return null;
        }
    }

	public static function set(cat:String, entry:String, val:Dynamic) {
		try {
			conf[cat].getEntry(entry).value = val;
		} catch (ex) {
			FluXis.log(ex.toString());
		}
	}

    public static function save() {
        for (category in conf) {
            var catdata = {};

            for (entry in category.entries) {
                Reflect.setProperty(catdata, entry.entryName, entry.value);
			}
			Reflect.setProperty(confjson, category.catName, catdata);
        }

		File.saveContent(FluXis.getDataPath() + "config.fluxcfg", Json.stringify(confjson));
    }
}