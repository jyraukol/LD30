package gameObjects
{
    import org.flixel.FlxSprite;

    public class Selector extends FlxSprite
    {
        private const SIZE:int = 64;
        [Embed(source = "../../assets/selector.png")] private var image:Class;

        public function Selector()
        {
            super( -100, -100, image);
        }

        override public function update():void
        {

        }

        public function hide():void
        {
            x = -100;
            y = -100;
        }
    }

}