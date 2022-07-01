package flustix.fluXis.screens.songselect.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flustix.fluXis.assets.Skin;
import flustix.fluXis.song.SongData.SongMetaData;
import flustix.fluXis.song.SongSession;
import flustix.fluXis.ui.FluXisText;

class SongBox extends FlxSpriteGroup {
	public var selected:Bool = false;
	public var parentgrp:FlxTypedGroup<SongBox>;

	var linkedSong:SongMetaData;

	var songbg:FlxSprite;
	var songbgselected:FlxSprite;

	public function new(s:SongMetaData, p:FlxTypedGroup<SongBox>) {
		super();
		linkedSong = s;
		parentgrp = p;

		songbg = new FlxSprite().loadGraphic(Skin.getTexture("songselect/songbg"));
		add(songbg);

		songbgselected = new FlxSprite().loadGraphic(Skin.getTexture("songselect/songbgselected"));
		add(songbgselected);

		var songname = new FluXisText(74, 26, linkedSong.name, 32);
		add(songname);

		var songartist = new FluXisText(64, 58, linkedSong.artist, 16);
		add(songartist);

		x = FlxG.width;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		alpha = selected ? 1 : 0.6;
		songbgselected.visible = selected;

		if (selected) {
			x = FlxMath.lerp(FlxG.width - 500, x, 0.8);
			y = FlxMath.lerp((FlxG.height / 2) - (height / 2), y, 0.8);
		} else {
			if (!FluXis.getClient().screen.allowInput) {
				x = FlxMath.lerp(FlxG.width, x, 0.8);
			} else {
				if (ID < SongSession.curSong) {
					x = parentgrp.members[ID + 1].x + 57;
					y = parentgrp.members[ID + 1].y - height;
				} else if (ID > SongSession.curSong) {
					x = parentgrp.members[ID - 1].x - 57;
					y = parentgrp.members[ID - 1].y + height;
				}
			}
		}
	}
}
