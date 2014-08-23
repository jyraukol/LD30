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
        private const MARGIN_TOP:int = 80;
        private const MARGIN_LEFT:int = 60;
        private const GAME_AREA_WIDTH:int = 8;
        private const GAME_AREA_HEIGHT:int = 4;
        private const WORLD_SIZE:int = 64;

        private var worldGroup:FlxGroup = new FlxGroup();
        private var selectedWorld:World = null;
        private var worldArray:Array = new Array();
        private var animationRunning:Boolean = false;
        private var animatedRef:World = null;

        public function PlayState()
        {
        }

        override public function create():void
        {
            for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                worldArray[y] = new Array();
                var array:Array = worldArray[y];
                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                    var world:World = new World(MARGIN_LEFT + x * WORLD_SIZE, MARGIN_TOP + y * WORLD_SIZE);
                    worldGroup.add(world);
                    array.push(world);
                }
            }
            add(worldGroup);
        }

        override public function update():void
        {
            if (animationRunning) {
                if (animatedRef.scale.x == 1) {
                    animationRunning = false;
                    animatedRef = null;
                }
            } else if (FlxG.mouse.justPressed()) {
                var gemClicked:Boolean = false;
                for (var i:int = 0; i < worldGroup.length; i++ ) {
                    var world:World = worldGroup.members[i];
                    if (world.checkClick()) {
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

                                checkMatches();
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


        private function getWorldTypeAt(x:uint, y:uint):Number
        {
            if (x < 0 || x >= GAME_AREA_WIDTH || y < 0 || y >= GAME_AREA_HEIGHT) {
                return -999;
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

        private function checkMatches():void
        {


            for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                    var type1:Number = getWorldTypeAt(x, y);
                    var type2:Number = getWorldTypeAt(x + 1, y);
                    var type3:Number = getWorldTypeAt(x + 2, y);
                    var removedWorlds:Array = new Array();
                    // Horizontal
                    if (type1 == type2 && type1 == type3) {
                        var targetType:Number = getWorldTypeAt(x, y);
                        var offset:uint = 0;

                        while (x + offset < GAME_AREA_WIDTH && worldArray[y][x + offset].worldType == targetType) {
                            removedWorlds.push(worldArray[y][x + offset]);
                            offset++;
                        }
                    }

                    // Vertical
                    type1 = getWorldTypeAt(x, y);
                    type2 = getWorldTypeAt(x, y + 1);
                    type3 = getWorldTypeAt(x, y + 2);
                    if (type1 == type2 && type1 == type3) {
                        targetType = getWorldTypeAt(x, y);
                        offset = 0;

                        while (y + offset < GAME_AREA_HEIGHT && worldArray[y + offset][x].worldType == targetType) {
                            removedWorlds.push(worldArray[y + offset][x]);
                            offset++;
                        }
                    }

                    for (var idx:uint = 0; idx < removedWorlds.length; idx++ ) {
                        removedWorlds[idx].dieAndBornAnew();
                        animatedRef = removedWorlds[0];
                        animationRunning = true;
                    }

                }
            }
        }
    }

}