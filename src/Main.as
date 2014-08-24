package
{
	import org.flixel.FlxGame;
    import org.flixel.FlxSound;
    import org.flixel.FlxG;

	[SWF(width = "640", height = "520", backgroundColor = "#000000")]

	public class Main extends FlxGame
	{
        [Embed(source = "../assets/sfx/music.mp3")] private var musicFile:Class;
        private var music:FlxSound;

        public function Main() {
            Registry.loadScores();
            super(640, 520, MenuState, 1);
            forceDebugger = true;
            FlxG.mouse.show();
            music = new FlxSound();
            music.volume = 1;
            music.loadEmbedded(musicFile, true);
            music.play();
        }

    }
}