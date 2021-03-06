package
{
    import org.flixel.FlxG;
    import org.flixel.FlxSave;
    import org.flixel.FlxState;

    public class Registry
    {
        [Embed(source = "../assets/background.png")] public static var backGroundImage:Class;
        public static var score:int = 0;
        public static var longestCombo:int = 0;
        public static var playTime:int = 0;
        public static var fadeInProgress:Boolean = false;

        public static var highScores:FlxSave;

        public function Registry()
        {
        }

        public static function loadScores():void
        {
            highScores = new FlxSave();
            highScores.bind("scores");
            if (highScores.data.scores == null) {
                highScores.data.scores = 0;
            }
        }

        public static function fadeDone():void
        {
            Registry.fadeInProgress = false;
        }

        public static function loadEndState():void
        {
            FlxG.switchState(new GameoverState());
        }

        public static function loadMenuState():void
        {
            FlxG.switchState(new MenuState());
        }

    }

}