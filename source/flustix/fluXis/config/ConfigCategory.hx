package flustix.fluXis.config;

class ConfigCategory {
    public var entries:Map<String, ConfigEntry> = [];
    public var catName:String;
	public var linkedConf:Dynamic;

	public function new(name:String, config:Dynamic) {
        catName = name;
        linkedConf = config;
    }

    public function addEntry(name:String, defaultValue:Dynamic) {
        entries.set(name, new ConfigEntry(this, name, defaultValue));
    }

    public function getEntry(entry:String):ConfigEntry {
        return entries[entry];
    }
}