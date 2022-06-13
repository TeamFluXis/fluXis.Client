package flustix.fluXis.config;

class ConfigEntry {
    var category:ConfigCategory;
	public var entryName:String;
    var defaultValue:Dynamic;
    public var value:Dynamic; 

	public function new(cat:ConfigCategory, name:String, val:Dynamic) {
        category = cat;
        entryName = name;
        defaultValue = val;

        load();
        trace(value);
    }

    function load() {
        value = Reflect.field(category.linkedConf, entryName);
        if (value == null)
            value = defaultValue;
    }
}