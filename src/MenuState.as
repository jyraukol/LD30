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
            startGame = new FlxSprite(220, 220, startGameTextImage);
            instructions = new FlxSprite(220, 280, instructionsTextImage);
            add(new FlxSprite(10, 60, titleTextImage));
            add(startGame);
            add(instructions);
        }

        override public function update():void
        {
            if (startGame.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
                startGame.color = 0xaaEC7600;
                if (FlxG.mouse.justPressed()) {
                    FlxG.switchState(new PlayState());
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

}