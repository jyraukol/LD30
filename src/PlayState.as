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
        private var worldArray:Array = new Array();

        public function PlayState()
        {
        }

        override public function create():void
        {
            for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                worldArray[y] = new Array();
                var array:Array = worldArray[y];
                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                    var world:World = new World(MARGIN_LEFT + x * 64, MARGIN_TOP + y * 64);
                    worldGroup.add(world);
                    array.push(world);
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
                                var arrayIndexes:FlxPoint = coordinatesToArray(world.x, world.y);
                                worldArray[arrayIndexes.y][arrayIndexes.x] = world;
                                arrayIndexes = coordinatesToArray(selectedWorld.x, selectedWorld.y);
                                worldArray[arrayIndexes.y][arrayIndexes.x] = selectedWorld;
                                // Do we have any matches?
                                /*for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                                    for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                                        if (x < GAME_AREA_WIDTH - 2 && getWorldAt(x, y).worldType == getWorldAt(x + 1, y).worldType == getWorldAt(x + 2, y).worldType) {
                                            var targetType:uint = getWorldAt(x, y).worldType;
                                            var offset:uint = 0;
                                            while (getWorldAt(x + offset, y).worldType == targetType) {
                                                trace("Removing world at x " + x + " y " + y);
                                                offset++;
                                            }

                                        }
                                    }
                                }*/
                                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                                    for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                                        if (getWorldTypeAt(x, y) == getWorldTypeAt(x +1, y) && getWorldTypeAt(x, y) == getWorldTypeAt(x + 2, y)) {
                                            var targetType:uint = getWorldTypeAt(x, y);
                                            var offset:uint = 0;
                                            var removedWorlds:Array = new Array();
                                            while (worldArray[y][x + offset].worldType == targetType) {
                                                trace("Removing world at x " + x + " offset " + offset + " y " + y);
                                                removedWorlds.push(worldArray[y][x + offset]);
                                                offset++;
                                            }
                                            for (var idx:uint = 0; idx < removedWorlds.length; idx++ ) {
                                                removedWorlds[idx].kill();
                                            }
                                        }
                                    }
                                }
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


        private function coordinatesToArray(x:uint, y:uint):FlxPoint
        {
            var col:int = (x - MARGIN_LEFT) / 64;
            var row:int = (y - MARGIN_TOP) / 64;
            return new FlxPoint(col, row);
        }


        private function getWorldTypeAt(x:uint, y:uint):uint
        {
            if (x < 0 || x >= GAME_AREA_WIDTH || y < 0 || y >= GAME_AREA_HEIGHT) {
                return null;
            }
            return getWorldAt(x, y).worldType;
        }

        private function getWorldAt(x:uint, y:uint):World
        {
            if (x < 0 || x > GAME_AREA_WIDTH || y < 0 || y > GAME_AREA_HEIGHT) {
                return null;
            }
            return worldArray[y][x];
        }

    }

}