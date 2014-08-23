package
{
    import gameObjects.Person;
    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTilemap;

    public class PlayState extends FlxState
    {
        private var player:FlxSprite;

        public function PlayState()
        {

        }

        override public function create():void
        {
            FlxG.bgColor = 0xff9C7D43;
            player = new FlxSprite(50, 50);
            player.makeGraphic(12, 12, 0xffC0C0C0);
            player.maxVelocity.make(80, 80);
            player.drag.make(250, 250);
            add(player);
        }

        override public function update():void
        {
            player.acceleration.x = 0;
            player.acceleration.y = 0;

            if (FlxG.keys.LEFT) {
                player.acceleration.x = -200;
            }
            if (FlxG.keys.RIGHT) {
                player.acceleration.x = 200;
            }

            if (FlxG.keys.UP) {
                player.acceleration.y = -200;
            }
            if (FlxG.keys.DOWN) {
                player.acceleration.y = 200;
            }

            super.update();
        }
    }

}