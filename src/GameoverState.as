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
        [Embed(source = "../assets/clickToContinue.png")] private var clickToContinue:Class;

        private var scoreSprite:FlxSprite;
        private var comboSprite:FlxSprite;
        private var clickSprite:FlxSprite;

        private var textFading:Boolean = true;

        public function GameoverState()
        {
            add(new FlxSprite(0, 0, Registry.backGroundImage));
            add(new FlxSprite(70, 60, gameOverText));
            scoreSprite = new FlxSprite(170, 160, scoreText);
            add(scoreSprite);
            comboSprite = new FlxSprite(170, 200, comboText);
            add(comboSprite);

            var score:FlxText = new FlxText(scoreSprite.x + scoreSprite.width + 20, scoreSprite.y, 250, Registry.score.toString());
            score.size = 22;
            score.color = 0xffF0FBFF;
            add(score);

            var combo:FlxText = new FlxText(comboSprite.x + comboSprite.width + 20, comboSprite.y, 250, Registry.longestCombo.toString() + "X");
            combo.size = 22;
            combo.color = 0xffF0FBFF;
            add(combo);

            clickSprite = new FlxSprite(160, 400, clickToContinue);
            add(clickSprite);
        }

        override public function update():void
        {
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
                FlxG.switchState(new MenuState());
            }
            super.update();
        }
    }

}