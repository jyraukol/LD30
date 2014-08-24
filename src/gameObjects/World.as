package gameObjects
{
    import org.flixel.FlxG;
    import org.flixel.FlxPoint;
    import org.flixel.FlxSprite;
    import org.flixel.FlxU;

    public class World extends FlxSprite
    {
        [Embed(source = "../../assets/p1.png")] private var image1:Class;
        [Embed(source = "../../assets/p2.png")] private var image2:Class;
        [Embed(source = "../../assets/p3.png")] private var image3:Class;
        [Embed(source = "../../assets/p4.png")] private var image4:Class;
        [Embed(source = "../../assets/p5.png")] private var image5:Class;
        [Embed(source = "../../assets/p6.png")] private var image6:Class;
        private var images:Array = new Array(image1, image2, image3, image4, image5, image6);
        public var worldType:int;
        private const VANISH_TIME:Number = 0.2;
        private var resetWorld:Boolean = false;
        private var growing:Boolean = false;
        public var animationRunning:Boolean = false;
        public var moveTarget:FlxPoint;
        private var movingTo:int;
        private const MOVE_SPEED:int = 300;
        public static const UP:int = 0;
        public static const RIGHT:int = 1;
        public static const DOWN:int = 2;
        public static const LEFT:int = 3;

        public function World(x:int, y:int)
        {
            worldType = FlxG.random() * 6;
            var image:Class = Class(images[worldType]);
            super(x, y, image);
        }

        private function createNewWorld():void
        {
            worldType = FlxG.random() * 6;
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

            } else if (moveTarget != null) {
                if (movingTo == UP && y > moveTarget.y) {
                    y -= MOVE_SPEED * FlxG.elapsed;
                    if (y < moveTarget.y) {
                        y = moveTarget.y;
                        acceleration.make(0, 0);
                        animationRunning = false;
                        moveTarget = null;
                    }
                } else if (movingTo == DOWN && y < moveTarget.y) {
                    y += MOVE_SPEED * FlxG.elapsed;
                    if (y > moveTarget.y) {
                        y = moveTarget.y;
                        velocity.make(0, 0);
                        animationRunning = false;
                        moveTarget = null;
                    }
                } else if (movingTo == RIGHT && x < moveTarget.x) {
                    x += MOVE_SPEED * FlxG.elapsed;
                    if (x > moveTarget.x) {
                        x = moveTarget.x;
                        velocity.make(0, 0);
                        animationRunning = false;
                        moveTarget = null;
                    }
                } else if (movingTo == LEFT && x > moveTarget.x) {
                    x -= MOVE_SPEED * FlxG.elapsed;
                    if (x < moveTarget.x) {
                        x = moveTarget.x;
                        velocity.make(0, 0);
                        animationRunning = false;
                        moveTarget = null;
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

        public function moveTo(target:FlxPoint):void {
            moveTarget = new FlxPoint(Math.floor(target.x), Math.floor(target.y));
            if (target.y < y) {
                movingTo = UP;
            } else if (target.y > y) {
                movingTo = DOWN;
            } else if (target.x < x) {
                movingTo = LEFT;
            } else if (target.x > x) {
                movingTo = RIGHT;
            }
            animationRunning = true;
        }

    }

}