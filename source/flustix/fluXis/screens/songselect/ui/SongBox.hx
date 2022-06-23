package flustix.fluXis.screens.songselect.ui;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flustix.fluXis.assets.FluXisText;
import flustix.fluXis.song.SongData.SongMetaData;
import flustix.fluXis.song.SongSession;

class SongBox extends FlxSpriteGroup {
	public var selected:Bool = false;
	public var parent:FlxTypedGroup<SongBox>;

	var linkedSong:SongMetaData;
	var ftrX:Float = 0;
	var ftrY:Float = 0;

	public function new(s:SongMetaData, p:FlxTypedGroup<SongBox>) {
		super();
		linkedSong = s;
		parent = p;

		var title = new FluXisText(0, 0, linkedSong.name);
		add(title);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		alpha = selected ? 1 : 0.6;

		if (selected) {
			ftrY = (FlxG.height / 2) - (height / 2);
			ftrX = 20;
			y = FlxMath.lerp(ftrY, y, 0.8);
		} else {
			if (ID < SongSession.curSong) {
				y = parent.members[ID + 1].y - height;
			} else if (ID > SongSession.curSong) {
				y = parent.members[ID - 1].y + height;
			}
			ftrX = 20 + (10 * (SongSession.curSong - ID));
		}
		x = FlxMath.lerp(ftrX, x, 0.8);
	}
}
