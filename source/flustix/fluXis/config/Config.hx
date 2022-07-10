package flustix.fluXis.config;

import flixel.input.keyboard.FlxKey;
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
        gameplay.addEntry("smoothsync", false);
        addCat(gameplay);

		var ui = new ConfigCategory("ui", confjson);
		ui.addEntry("bgdim", 0.4);
		ui.addEntry("bgblur", 0);
		addCat(ui);

        var display = new ConfigCategory("display", confjson);
        display.addEntry("width", 1600);
        display.addEntry("height", 900);
		display.addEntry("fullscreen", false);
		display.addEntry("framerate", 120);
        addCat(display);

        var sound = new ConfigCategory("sound", confjson);
        sound.addEntry("master", 0.5);
		sound.addEntry("unfocused", 0.1);
        sound.addEntry("music", 0.5);
        sound.addEntry("sfx", 0.5);
        sound.addEntry("hitsounds", 0.5);
        addCat(sound);

        var input = new ConfigCategory("input", confjson);
		input.addEntry("left", FlxKey.A);
		input.addEntry("down", FlxKey.S);
		input.addEntry("up", FlxKey.K);
		input.addEntry("right", FlxKey.L);
        addCat(input);

        save();
    }

    static function addCat(cat:ConfigCategory) {
        conf.set(cat.catName, cat);
    }

    public static function get(cat:String, entry:String):Dynamic {
		try {
			return conf[cat].getEntry(entry).value;
		} catch (ex) {
            return null;
		}
    }

	public static function set(cat:String, entry:String, val:Dynamic) {
		try {
			conf[cat].getEntry(entry).value = val;
            save();
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