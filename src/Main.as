package
{
	import org.flixel.FlxGame;
    import org.flixel.FlxSound;
    import org.flixel.FlxG;

	[SWF(width = "640", height = "480", backgroundColor = "#000000")]

	public class Main extends FlxGame
	{
        [Embed(source = "../assets/sfx/music.mp3")] private var musicFile:Class;
        private var music:FlxSound;

        public function Main() {
            super(640, 480, MenuState, 1);
            forceDebugger = true;
            FlxG.mouse.show();
            music = new FlxSound();
            music.volume = 1;
            music.loadEmbedded(musicFile, true);
            music.play();
        }

    }
}