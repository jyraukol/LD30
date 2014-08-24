package
{
    import gameObjects.Board;
    import gameObjects.Selector;
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
        public var selector:Selector = new Selector();
        private var score:int = 0;
        private var addTimeLimit:int = 1000;
        private var scoreText:FlxText;
        private var worldArray:Array = new Array();
        private var gameTimeLeft:Number = 120;
        private var gameTimeLeftText:FlxText;
        private var gameOver:Boolean = false;
        private var comboText:FlxText;

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

            gameTimeLeftText = new FlxText(500, 10, 100, "Time: " + gameTimeLeft);
            gameTimeLeftText.size = 14;
            add(gameTimeLeftText);

            comboText = new FlxText(260, 10, 100, "1X Combo!");
            comboText.size = 14;
            comboText.visible = false;
            add(comboText);
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

            if (gameBoard.getRunningCombo() > 1) {
                comboText.text = gameBoard.getRunningCombo() + "X Combo!";
                comboText.visible = true;
            } else {
                comboText.visible = false;
            }

            gameTimeLeft -= FlxG.elapsed;
            calculateGameTime();
            if (gameTimeLeft < 0) {
                gameOver = true;
                FlxG.switchState(new GameoverState());
            }
            super.update();
        }

        public function addScore(value:int):void
        {
            score += value;
            scoreText.text = "Score: " + score;
            if (score >= addTimeLimit) {
                addGameTime(5);
                addTimeLimit += addTimeLimit;
            }
        }

        public function addGameTime(seconds:int):void {
            gameTimeLeft += seconds;
        }

        private function calculateGameTime():void
        {
            var minutes:int = gameTimeLeft / 60;
            var seconds:int = gameTimeLeft % 60;
            if (seconds < 10) {
                gameTimeLeftText.text = "Time: " + minutes + ":0" + seconds;
            } else {
                gameTimeLeftText.text = "Time: " + minutes + ":" + seconds;
            }
        }
    }

}