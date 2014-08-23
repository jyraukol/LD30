package gameObjects
{
    import org.flixel.FlxG;
    import org.flixel.FlxPoint;
    import org.flixel.FlxSprite;
    import org.flixel.FlxU;

    public class World extends FlxSprite
    {
        [Embed(source = "../../assets/gem1.png")] private var image1:Class;
        [Embed(source = "../../assets/gem2.png")] private var image2:Class;
        [Embed(source = "../../assets/gem3.png")] private var image3:Class;
        [Embed(source = "../../assets/gem4.png")] private var image4:Class;
        private var images:Array = new Array(image1, image2, image3, image4);

        public function World(x:int, y:int)
        {
            var image:Class = Class(FlxU.getRandom(images, 0, 3));
            super(x, y, image);
        }

        public function checkClick():Boolean
        {
            if (overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
                trace("World clicked at " + FlxG.mouse.x + " " + FlxG.mouse.y);
                return true;
            }
            return false;
        }

        public function highlight():void
        {
            alpha = 0.5;
        }

        public function removeHighlight():void
        {
            alpha = 1;
        }

        public function checkSwap(otherWorld:World):Boolean
        {
            return true;
        }

    }

}