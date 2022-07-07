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
    }

    function load() {
		value = Reflect.field(Reflect.field(category.linkedConf, category.catName), entryName);
        if (value == null)
            value = defaultValue;
    }
}