package
{
    import gameObjects.World;
    import org.flixel.FlxPoint;

    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTilemap;

    public class PlayState extends FlxState
    {
        private var MARGIN_TOP:int = 80;
        private var MARGIN_LEFT:int = 60;
        private var GAME_AREA_WIDTH:int = 8;
        private var GAME_AREA_HEIGHT:int = 4;
        private var worldGroup:FlxGroup = new FlxGroup();
        private var selectedWorld:World = null;

        public function PlayState()
        {
        }

        override public function create():void
        {
            for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                    var world:World = new World(MARGIN_LEFT + x * 64, MARGIN_TOP + y * 64);
                    worldGroup.add(world);
                }
            }
            add(worldGroup);
        }

        override public function update():void
        {
            if (FlxG.mouse.justPressed()) {
                var gemClicked:Boolean = false;
                for (var i:int = 0; i < worldGroup.length; i++ ) {
                    var world:World = worldGroup.members[i];
                    if (world.checkClick()) {
                        // Figure out row and column
                        var col:int = (world.x - MARGIN_LEFT) / 64;
                        var row:int = (world.y - MARGIN_TOP) / 64;
                        trace("Row: " + row + " Col: " + col);

                        // Two worlds selected
                        if (selectedWorld != null) {
                            if (selectedWorld.checkSwap(world)) {
                                var selectedWorldCoordinates:FlxPoint = new FlxPoint(selectedWorld.x, selectedWorld.y);
                                selectedWorld.x = world.x;
                                selectedWorld.y = world.y;
                                world.x = selectedWorldCoordinates.x;
                                world.y = selectedWorldCoordinates.y;
                                selectedWorld.removeHighlight();
                                world.removeHighlight();
                            }

                        } else {
                            world.highlight();
                            selectedWorld = world;
                            gemClicked = true;
                            break;
                        }
                    }
                }

                // Clear selection if clicked outside play area
                if (!gemClicked && selectedWorld != null) {
                    selectedWorld.removeHighlight();
                    selectedWorld = null;
                }
            }
            super.update();
        }


    }

}