package gameObjects
{
    import org.flixel.FlxState;
    import org.flixel.FlxPoint;

    public class Board
    {
        private const MARGIN_TOP:int = 80;
        private const MARGIN_LEFT:int = 60;
        private const GAME_AREA_WIDTH:int = 8;
        private const GAME_AREA_HEIGHT:int = 4;
        private const WORLD_SIZE:int = 64;

        private var worldArray:Array = new Array();
        private var gameState:FlxState;
        private var previouslySelectedWorld:World = null;
        private var currentlySelectedWorld:World = null;
        private var needToCheckMatches:Boolean = true;
        private var needToRevertLastSwap:Boolean = false;
        private var lastSwap:Array = new Array();

        public function Board()
        {

        }

        public function update():void {
            if (needToCheckMatches && !animationRunning()) {
                var matches:Array = findMatchingWorlds();
                if (matches.length > 0) {
                    for (var i:int = 0; i < matches.length; i++ ) {
                        matches[i].dieAndBornAnew();
                    }

                } else {
                    needToCheckMatches = false;
                    if (previouslySelectedWorld != null && currentlySelectedWorld != null) {
                        moveWorlds(previouslySelectedWorld, currentlySelectedWorld);
                        previouslySelectedWorld = null;
                        currentlySelectedWorld = null;
                    }
                }
            }
        }


        public function initBoard(gameState:FlxState):void {
            this.gameState = gameState;

            for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                worldArray[y] = new Array();
                var array:Array = worldArray[y];
                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                    var world:World = new World(MARGIN_LEFT + x * WORLD_SIZE, MARGIN_TOP + y * WORLD_SIZE);
                    array.push(world);
                    gameState.add(world);
                }
            }

        }

        public function animationRunning():Boolean {
            for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                    if (worldArray[y][x].animationRunning) {
                        return true;
                    }
                }
            }
            return false;
        }

        public function checkMouseClick():void {
            var gemClicked:Boolean = false;
            for (var y:int = 0; y < worldArray.length; y++ ) {
                for (var x:int = 0; x < worldArray[y].length; x++ ) {
                    var world:World = worldArray[y][x];
                    if (world.checkClick()) {
                        // Two worlds selected
                        if (previouslySelectedWorld != null) {
                            currentlySelectedWorld = world;
                            checkSwap(previouslySelectedWorld, currentlySelectedWorld)
                            needToCheckMatches = true;
                            break;
                        } else {
                            world.highlight();
                            previouslySelectedWorld = world;
                            gemClicked = true;
                            break;
                        }
                    }
                }
            }

            // Clear selection if clicked outside play area
            if (!gemClicked && previouslySelectedWorld != null) {
                previouslySelectedWorld.removeHighlight();
                previouslySelectedWorld = null;
            }
        }

        public function checkMatches():void
        {
            var matches:Array = findMatchingWorlds();
            for (var i:int = 0; i < matches.length; i++ ) {
                matches[i].dieAndBornAnew();
            }

        }

        private function coordinatesToArray(x:uint, y:uint):FlxPoint
        {
            var col:int = (x - MARGIN_LEFT) / WORLD_SIZE;
            var row:int = (y - MARGIN_TOP) / WORLD_SIZE;
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

        private function findMatchingWorlds():Array
        {
            var removedWorlds:Array = new Array();

            for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                    var type1:Number = getWorldTypeAt(x, y);
                    var type2:Number = getWorldTypeAt(x + 1, y);
                    var type3:Number = getWorldTypeAt(x + 2, y);

                    // Horizontal
                    if (type1 == type2 && type1 == type3) {
                        var targetType:Number = getWorldTypeAt(x, y);
                        var offset:int = 0;

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
                }
            }
            return removedWorlds;
        }

        private function checkSwap(world1:World, world2:World):void
        {
            //lastSwap[0] = new FlxPoint(world1.x, world1.y);
            //lastSwap[1] = new FlxPoint(world2.x, world2.y);

            moveWorlds(world1, world2);
            if (findMatchingWorlds().length == 0) {
                needToRevertLastSwap = true;
            }
        }

        private function moveWorlds(world1:World, world2:World):void
        {
            lastSwap[0] = new FlxPoint(world1.x, world1.y);
            lastSwap[1] = new FlxPoint(world2.x, world2.y);
            world1.moveTo(new FlxPoint(world2.x, world2.y));
            world2.moveTo(lastSwap[0]);
            previouslySelectedWorld.removeHighlight();
            world2.removeHighlight();
            var arrayIndexes:FlxPoint = coordinatesToArray(world2.moveTarget.x, world2.moveTarget.y);
            worldArray[arrayIndexes.y][arrayIndexes.x] = world2;
            arrayIndexes = coordinatesToArray(world1.moveTarget.x, world1.moveTarget.y);
            worldArray[arrayIndexes.y][arrayIndexes.x] = world1;
        }
    }
}