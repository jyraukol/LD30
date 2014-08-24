package gameObjects
{
    import org.flixel.FlxG;
    import org.flixel.FlxState;
    import org.flixel.FlxPoint;

    public class Board
    {


        private const MARGIN_TOP:int = 70;
        private const MARGIN_LEFT:int = 60;
        private const GAME_AREA_WIDTH:int = 8;
        private const GAME_AREA_HEIGHT:int = 6;
        private const WORLD_SIZE:int = 64;
        private const SPACING_X:int = 4;
        private const SPACING_Y:int = 4;
        private const comboTimeLimit:int = 2;

        private var worldArray:Array = new Array();
        private var gameState:PlayState;
        private var previouslySelectedWorld:World = null;
        private var currentlySelectedWorld:World = null;
        private var needToCheckMatches:Boolean = true;
        private var needToRevertLastSwap:Boolean = false;
        private var lastSwap:Array = new Array();
        private var comboTimer:Number = 0;
        private var runningCombo:int = 0;

        public function Board()
        {

        }

        public function update():void {
            if (needToCheckMatches && !animationRunning()) {
                var matches:Array = findMatchingWorlds();
                if (matches.length > 0) {
                    for (var i:int = 0; i < matches.length; i++ ) {
                        matches[i].dieAndBornAnew();
                        MusicManager.playSound(MusicManager.MATCH);
                    }
                    gameState.addScore(10 * matches.length * (runningCombo + 1));
                    runningCombo++;
                    comboTimer = comboTimeLimit;
                    if (runningCombo > 5) {
                        MusicManager.playSound(MusicManager.COMBO);
                    }
                } else {
                    needToCheckMatches = false;
                    if (needToRevertLastSwap) {
                        var world1Indexes:FlxPoint = coordinatesToArray(lastSwap[0].x, lastSwap[0].y);
                        var world2Indexes:FlxPoint = coordinatesToArray(lastSwap[1].x, lastSwap[1].y);
                        var world1:World = getWorldAt(world1Indexes.x, world1Indexes.y);
                        var world2:World = getWorldAt(world2Indexes.x, world2Indexes.y);
                        moveWorlds(world1, world2);
                        previouslySelectedWorld = null;
                        currentlySelectedWorld = null;
                        needToRevertLastSwap = false;
                    }
                }
            }
            if (comboTimer > 0) {
                comboTimer -= FlxG.elapsed;
                if (comboTimer <= 0) {
                    runningCombo = 0;
                }
            }
        }


        public function initBoard(gameState:PlayState):void {
            this.gameState = gameState;

            for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                worldArray[y] = new Array();
                var array:Array = worldArray[y];
                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                    var world:World = new World(MARGIN_LEFT + x * WORLD_SIZE + x * SPACING_X, MARGIN_TOP + y * WORLD_SIZE + SPACING_Y * y);
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
                        gameState.selector.x = world.x;
                        gameState.selector.y = world.y;
                        // Two worlds selected
                        if (previouslySelectedWorld != null) {
                            if (previouslySelectedWorld == world) {
                                previouslySelectedWorld.removeHighlight();
                                previouslySelectedWorld = null;
                                gameState.selector.hide();
                                break;
                            }
                            currentlySelectedWorld = world;
                            checkSwap(previouslySelectedWorld, currentlySelectedWorld)
                            needToCheckMatches = true;
                            gameState.selector.hide();
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
                gameState.selector.hide();
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
            var world1Index:FlxPoint = coordinatesToArray(world1.x, world1.y);
            var world2Index:FlxPoint = coordinatesToArray(world2.x, world2.y);
            if (Math.abs(world1Index.x - world2Index.x) > 1 || Math.abs(world1Index.y - world2Index.y) > 1
                || (Math.abs(world1Index.x - world2Index.x) == 1 && Math.abs(world1Index.y - world2Index.y) == 1)) {
                FlxG.shake(0.02, 0.3);
                MusicManager.playSound(MusicManager.EXPLOSION);
            } else {
                moveWorlds(world1, world2);
                if (findMatchingWorlds().length == 0) {
                    needToRevertLastSwap = true;
                }
            }
        }

        private function moveWorlds(world1:World, world2:World):void
        {
            lastSwap[0] = new FlxPoint(world1.x, world1.y);
            lastSwap[1] = new FlxPoint(world2.x, world2.y);
            world1.moveTo(new FlxPoint(world2.x, world2.y));
            world2.moveTo(lastSwap[0]);
            var arrayIndexes:FlxPoint = coordinatesToArray(world2.moveTarget.x, world2.moveTarget.y);
            worldArray[arrayIndexes.y][arrayIndexes.x] = world2;
            arrayIndexes = coordinatesToArray(world1.moveTarget.x, world1.moveTarget.y);
            worldArray[arrayIndexes.y][arrayIndexes.x] = world1;
        }

        public function getRunningCombo():int
        {
            return runningCombo;
        }
    }
}