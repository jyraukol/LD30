package
{
    import gameObjects.World;

    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTilemap;

    public class PlayState extends FlxState
    {
        private var MARGIN_TOP:int = 80;
        private var MARGIN_LEFT:int = 60;
        private var GAME_AREA_WIDTH:int = 8;
        private var GAME_AREA_HEIGHT:int = 4;

        public function PlayState()
        {
            for (var y:int = 0; y < GAME_AREA_HEIGHT; y++ ) {
                for (var x:int = 0; x < GAME_AREA_WIDTH; x++ ) {
                    add(new World(MARGIN_LEFT +x * 64, MARGIN_TOP + y * 64));
                }
            }

        }

        override public function create():void
        {

        }

        override public function update():void
        {
            super.update();
        }
    }

}