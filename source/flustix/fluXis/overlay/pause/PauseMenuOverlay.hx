package flustix.fluXis.overlay.pause;

import flustix.fluXis.screens.songselect.SongSelectScreen;
import flixel.group.FlxSpriteGroup;
import flustix.fluXis.screens.gameplay.GameplayScreen;
import flixel.FlxG;
import flustix.fluXis.assets.Skin;
import flixel.FlxSprite;
import flustix.fluXis.layers.FluXisOverlay;

class PauseMenuOverlay extends FluXisOverlay {
    var bg:FlxSprite;
    var parent:GameplayScreen;
    var justOpened = true;

    var itemGrp = new FlxSpriteGroup();
    var selections = ["continue", "restart", "back"];
    var curSelec = 0;

    public function new(parent:GameplayScreen) {
        super();
        this.parent = parent;

        bg = new FlxSprite().loadGraphic(Skin.getTexture("pause/bg"));
        bg.setGraphicSize(FlxG.width);
        bg.updateHitbox();
        bg.antialiasing = true;
        add(bg);

        add(itemGrp);

        for (i in 0...selections.length) {
            var item = new FlxSprite().loadGraphic(Skin.getTexture('pause/${selections[i]}'));
			item.y = i != 0 ? itemGrp.members[i - 1].y + itemGrp.members[i - 1].height : 0;
            item.antialiasing = true;
            item.ID = i;
            itemGrp.add(item);
        }

        itemGrp.screenCenter();
        changeSelec();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)
            changeSelec(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelec(1);

        if (FlxG.keys.justPressed.ESCAPE && !justOpened) 
            closeMenu();

		if (FlxG.keys.justPressed.ENTER) 
			acceptSelec();

        justOpened = false;
    }

    function changeSelec(by:Int = 0) {
        curSelec += by;
        if (curSelec > selections.length - 1)
			curSelec = selections.length - 1;
		if (curSelec < 0)
			curSelec = 0;

		for (item in itemGrp.members) {
			item.screenCenter(X);
			if (item.ID == curSelec)
                item.x += 50;
		}
    }

    function acceptSelec() {
        var selected = selections[curSelec];

        switch (selected) {
			case 'continue':
					closeMenu();
			case 'back': {
					FlxG.sound.music.resume();
                    closeMenu();
                    client.updateScreen(new SongSelectScreen());
            }
        }
    }

	override function closeMenu() {
		FlxG.sound.music.resume();
		parent.paused = false;
        super.closeMenu();
    }
}