package
{
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxText;

    public class GameoverState extends FlxState
    {
        [Embed(source = "../assets/gameOverText.png")] private var gameOverText:Class;
        [Embed(source = "../assets/scoreText.png")] private var scoreText:Class;
        [Embed(source = "../assets/comboText.png")] private var comboText:Class;
        [Embed(source = "../assets/gameTimeText.png")] private var gameTimeText:Class;
        [Embed(source = "../assets/clickToContinue.png")] private var clickToContinue:Class;

        private var scoreSprite:FlxSprite;
        private var comboSprite:FlxSprite;
        private var gameTimeSprite:FlxSprite;
        private var clickSprite:FlxSprite;

        private var textFading:Boolean = true;

        public function GameoverState()
        {
            Registry.fadeInProgress = true;
            FlxG.flash(0xff000000, 1, Registry.fadeDone);

            add(new FlxSprite(0, 0, Registry.backGroundImage));
            add(new FlxSprite(70, 60, gameOverText));

            scoreSprite = new FlxSprite(170, 160, scoreText);
            add(scoreSprite);

            comboSprite = new FlxSprite(170, 200, comboText);
            add(comboSprite);

            gameTimeSprite = new FlxSprite(170, 240, gameTimeText);
            add(gameTimeSprite);

            var score:FlxText = new FlxText(410, scoreSprite.y, 250, Registry.score.toString());
            score.size = 22;
            score.color = 0xffF0FBFF;
            add(score);

            var combo:FlxText = new FlxText(410, comboSprite.y, 250, Registry.longestCombo.toString() + "X");
            combo.size = 22;
            combo.color = 0xffF0FBFF;
            add(combo);

            var gameTime:FlxText = new FlxText(410, gameTimeSprite.y, 250, "");
            gameTime.size = 22;
            gameTime.color = 0xffF0FBFF;
            add(gameTime);

            var minutes:int = Registry.playTime / 60;
            var seconds:int = Registry.playTime % 60;
            if (seconds < 10) {
                gameTime.text = minutes + ":0" + seconds;
            } else {
                gameTime.text = minutes + ":" + seconds;
            }

            clickSprite = new FlxSprite(160, 400, clickToContinue);
            add(clickSprite);
        }

        override public function create():void
        {
            Registry.fadeInProgress = true;
            FlxG.flash(0xff000000, 1, Registry.fadeDone);
        }

        override public function update():void
        {
            if (!Registry.fadeInProgress) {
                if (textFading) {
                    if (clickSprite.alpha > 0) {
                        clickSprite.alpha -= FlxG.elapsed;
                    } else {
                        textFading = false;
                    }
                } else {
                    if (clickSprite.alpha < 1) {
                        clickSprite.alpha += FlxG.elapsed;
                    } else {
                        textFading = true;
                    }
                }


                if (FlxG.mouse.justPressed()) {
                    Registry.fadeInProgress = true;
                    FlxG.fade(0xff000000, 1, Registry.loadMenuState);
                }
                super.update();
            }
        }
    }

}