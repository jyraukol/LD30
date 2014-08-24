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
        [Embed(source = "../assets/resetButton.png")] private var resetButtonImage:Class;

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
        private var resetButton:FlxSprite;
        private var resetLimit:Number = 0;

        public function PlayState()
        {
        }

        override public function create():void
        {
            Registry.fadeInProgress = true;

            FlxG.flash(0xff000000, 1, Registry.fadeDone);
            add(new FlxSprite(0, 0, Registry.backGroundImage));
            Registry.playTime = gameTimeLeft;
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
            calculateGameTime();

            comboText = new FlxText(260, 10, 200, "1X Combo!");
            comboText.size = 16;
            comboText.color = 0xffFF8040;
            comboText.visible = false;
            add(comboText);

            resetButton = new FlxSprite(400, 10);
            resetButton.loadGraphic(resetButtonImage, true, false, 40, 40);
            resetButton.addAnimation("ready", [0], 0, false);
            resetButton.addAnimation("reloading", [1], 0, false);
            resetButton.play("ready");
            add(resetButton);

        }

        override public function update():void
        {
            if (!Registry.fadeInProgress) {
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
                resetLimit -= FlxG.elapsed;
                if (resetLimit <= 0) {
                    resetButton.play("ready");
                }
                if (FlxG.mouse.justPressed()&& resetLimit <= 0 && resetButton.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
                    resetLimit = 30;
                    resetButton.play("reloading");
                    gameBoard.resetAllPlanets();
                }
                if (gameTimeLeft < 0 && !gameOver) {
                    gameOver = true;
                    MusicManager.playSound(MusicManager.GAME_OVER);
                    Registry.score = score;
                    Registry.fadeInProgress = true;
                    if (Registry.highScores.data.scores < score) {
                        Registry.highScores.data.scores = score;
                    }
                    FlxG.fade(0xff000000, 1, Registry.loadEndState);
                }
                super.update();
            }
        }

        public function addScore(value:int):void
        {
            score += value;
            scoreText.text = "Score: " + score;
            if (score >= addTimeLimit) {
                addGameTime(5);
                addTimeLimit += 1000;
            }
        }

        public function addGameTime(seconds:int):void {
            gameTimeLeft += seconds;
            Registry.playTime += seconds;
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