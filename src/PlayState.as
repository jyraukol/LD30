package
{
    import gameObjects.Board;
    import gameObjects.Frame;
    import gameObjects.World;
    import org.flixel.FlxPoint;
    import org.flixel.FlxText;

    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTilemap;

    public class PlayState extends FlxState
    {
        [Embed(source = "../assets/topBackground.png")] private var topBackgroundImage:Class;

        private const MARGIN_TOP:int = 80;
        private const MARGIN_LEFT:int = 60;
        private const GAME_AREA_WIDTH:int = 8;
        private const GAME_AREA_HEIGHT:int = 4;
        private const WORLD_SIZE:int = 64;

        private var gameBoard:Board = new Board();
        public var selector:Frame = new Frame();
        private var score:int = 0;
        private var scoreText:FlxText;
        private var worldArray:Array = new Array();

        public function PlayState()
        {
        }

        override public function create():void
        {
            gameBoard.initBoard(this);
            add(selector);
            var topBackground:FlxSprite = new FlxSprite(0, 0, topBackgroundImage);
            add(topBackground);
            scoreText = new FlxText(20, 10, 200, "Score: " + score);
            scoreText.size = 14;
            add(scoreText);
        }

        override public function update():void
        {
            var worldsAnimated:Boolean = gameBoard.animationRunning();

            gameBoard.update();
            if (!worldsAnimated) {
                if (FlxG.mouse.justPressed()) {
                    gameBoard.checkMouseClick();
                }
            }
            super.update();
        }

        public function addScore(value:int):void
        {
            score += value;
            scoreText.text ="Score: " + score;
        }
    }

}