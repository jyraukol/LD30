package
{
    import org.flixel.FlxG;

    public class MusicManager
    {
        [Embed(source = "../assets/sfx/explosion1.mp3")] private static var explosion1Sound:Class;
        [Embed(source = "../assets/sfx/match.mp3")] private static var matchSound:Class;
        [Embed(source = "../assets/sfx/combo.mp3")] private static var comboSound:Class;
        [Embed(source = "../assets/sfx/gameOver.mp3")] private static var gameOverSound:Class;

        public static const EXPLOSION:int = 1;
        public static const MATCH:int = 2;
        public static const COMBO:int = 3;
        public static const GAME_OVER:int = 4;

        public function MusicManager()
        {

        }

        public static function playSound(sound:int):void
        {
            switch (sound) {
                case 1:
                    FlxG.play(explosion1Sound, 0.6);
                    break;
                case 2:
                    FlxG.play(matchSound, 0.5);
                    break;
                case 3:
                    FlxG.play(comboSound, 0.6);
                    break;
                case 4:
                    FlxG.play(gameOverSound, 0.6);
                    break;
            }

        }
    }

}