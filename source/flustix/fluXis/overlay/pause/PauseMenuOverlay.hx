package flustix.fluXis.overlay.pause;

import flustix.fluXis.ui.FluXisSprite;
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

	var itemGrp = new FlxTypedSpriteGroup<FlxSprite>();
    var selections = ["continue", "restart", "back"];
    var curSelec = 0;

    public function new(p:GameplayScreen) {
        super();
        this.parent = p;

        bg = new FlxSprite().loadGraphic(Skin.getTexture("pause/bg"));
        bg.setGraphicSize(FlxG.width);
        bg.updateHitbox();
        bg.antialiasing = true;
        add(bg);

        add(itemGrp);

        for (i in 0...selections.length) {
			var item = new FlxSprite(Skin.getTexture('pause/${selections[i]}'));
			item.x = i != 0 ? itemGrp.members[i - 1].x + itemGrp.members[i - 1].width + 20 : 0;
            item.antialiasing = true;
            item.ID = i;
            item.alpha = 0.6;
            /* item.hoverData = {
                time: 0.3,
				hovered: {alpha: 1},
                normal: {alpha: 0.6}
            }; */
            itemGrp.add(item);
        }

        itemGrp.screenCenter();
        changeSelec();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.LEFT)
            changeSelec(-1);
		if (FlxG.keys.justPressed.RIGHT)
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
            item.alpha = item.ID == curSelec ? 1 : 0.6;
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