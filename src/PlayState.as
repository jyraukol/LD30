package
{
    import flash.utils.getTimer;
    import gameObjects.Board;
    import gameObjects.World;
    import org.flixel.FlxPoint;

    import org.flixel.FlxG;
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

        private var gameBoard:Board = new Board();

        private var worldArray:Array = new Array();
        private var checkMatchTimer:int;

        public function PlayState()
        {
        }

        override public function create():void
        {
            checkMatchTimer = getTimer() + 1000;
            gameBoard.initBoard(this);
        }

        override public function update():void
        {
            var worldsAnimated:Boolean = gameBoard.animationRunning();

            gameBoard.update();
            if (!worldsAnimated) {
                if (checkMatchTimer > getTimer()) {
                    //gameBoard.checkMatches();
                    checkMatchTimer += 1000;
                }

                if (FlxG.mouse.justPressed()) {
                    gameBoard.checkMouseClick();
                }
            }
            super.update();
        }
    }

}