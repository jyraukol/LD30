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
        public var worldType:int;
        private const VANISH_TIME:Number = 0.5;
        private var resetWorld:Boolean = false;
        private var growing:Boolean = false;
        public var animationRunning:Boolean = false;

        public function World(x:int, y:int)
        {
            worldType = FlxG.random() * 4;
            var image:Class = Class(images[worldType]);
            super(x, y, image);
        }

        private function createNewWorld():void
        {
            worldType = FlxG.random() * 4;
            var image:Class = Class(images[worldType]);
            loadGraphic(image);
        }

        override public function update():void
        {
            if (resetWorld) {
                animationRunning = true;
                if (!growing) {
                    scale.x -= FlxG.elapsed / VANISH_TIME;
                    scale.y -= FlxG.elapsed / VANISH_TIME;
                    if (scale.x < 0) {
                        createNewWorld();
                        growing = true;
                    }
                } else {
                    scale.x += FlxG.elapsed / VANISH_TIME;
                    scale.y += FlxG.elapsed / VANISH_TIME;
                    if (scale.x > 1) {
                        scale.make(1, 1);
                        growing = false;
                        resetWorld = false;
                        animationRunning = false;
                    }
                }

            }
        }


        public function checkClick():Boolean
        {
            if (overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
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

        public function dieAndBornAnew():void {
            resetWorld = true;
        }

    }

}