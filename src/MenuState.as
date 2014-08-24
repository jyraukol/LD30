package
{
    import org.flixel.FlxG;
    import org.flixel.FlxPoint;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxText;

    public class MenuState extends FlxState
    {
        [Embed(source = "../assets/titleText.png")] private var titleTextImage:Class;
        [Embed(source = "../assets/startGameText.png")] private var startGameTextImage:Class;
        [Embed(source = "../assets/instructionsText.png")] private var instructionsTextImage:Class;

        private var startGame:FlxSprite;
        private var instructions:FlxSprite;

        public function MenuState()
        {
            add(new FlxSprite(0, 0, Registry.backGroundImage));
            startGame = new FlxSprite(220, 220, startGameTextImage);
            instructions = new FlxSprite(220, 280, instructionsTextImage);
            add(new FlxSprite(10, 60, titleTextImage));
            add(startGame);
            add(instructions);

            var highscore:FlxText = new FlxText(236, 400, 500, "Highscore " + Registry.highScores.data.scores);
            highscore.size = 22;
            highscore..color = 0xffF0FBFF;
            add(highscore);
        }

        override public function create():void
        {
            if (Registry.fadeInProgress) {
                FlxG.flash(0xff000000, 1, Registry.fadeDone);
            }
        }

        override public function update():void
        {
            if (!Registry.fadeInProgress) {
                if (startGame.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
                    startGame.color = 0xaaEC7600;
                    if (FlxG.mouse.justPressed()) {
                        FlxG.fade(0xff000000, 1, loadPlayState);
                    }
                } else if (instructions.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
                    instructions.color = 0xaaEC7600;
                } else {
                    startGame.color = 0xFFFFFFFF;
                    instructions.color = 0xFFFFFFFF;
                }
                super.update();
            }
        }

        private function loadPlayState():void {
            FlxG.switchState(new PlayState());
        }

    }

}