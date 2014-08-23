package
{
    import flash.utils.getTimer;
    import org.flixel.FlxPoint;

    import gameObjects.Person;
    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTilemap;

    public class PlayState extends FlxState
    {
        private var player:FlxSprite;
        private var cableGroup:FlxGroup;
        private var lastCableDropped:FlxPoint;
        private var moveSpeed:int = 200;

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

            cableGroup = new FlxGroup();
            cableGroup.add(new FlxSprite( -500, -500));
            add(cableGroup);
            add(player);
            lastCableDropped = new FlxPoint(player.x, player.y);
        }

        override public function update():void
        {

            player.acceleration.x = 0;
            player.acceleration.y = 0;

            if (FlxG.keys.LEFT) {
                player.velocity.x = -moveSpeed;
            }
            if (FlxG.keys.RIGHT) {
                player.velocity.x = moveSpeed;
            }

            if (FlxG.keys.UP) {
                player.velocity.y = -moveSpeed;
            }
            if (FlxG.keys.DOWN) {
                player.velocity.y = moveSpeed;
            }

            if (!player.overlaps(cableGroup)) {
                var cable:FlxSprite = new FlxSprite(player.x + player.width / 2, player.y + player.height / 2).makeGraphic(6, 6, 0xff808000);

                    cableGroup.add(cable);
                    lastCableDropped.x = player.x;
                    lastCableDropped.y = player.y;
                }


            super.update();
        }
    }

}