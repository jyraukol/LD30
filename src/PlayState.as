package
{
    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTilemap;

    public class PlayState extends FlxState
    {
        private var TILE_WIDTH:uint = 40;
        private var TILE_HEIGHT:uint = 40;
        [Embed(source = "../assets/rectangle.png")] protected var ImgGrid:Class;

        public function PlayState()
        {

        }

        override public function create():void
        {
            FlxG.bgColor = 0xff9C7D43;
            trace("Playstate is running");
            var boardWidth:uint = FlxG.width / TILE_WIDTH;
            var boardHeight:uint = FlxG.height / TILE_HEIGHT;
            trace(boardWidth);
            trace(boardHeight);
            var gridGroup:FlxGroup = new FlxGroup(boardWidth * boardHeight);

            for (var y:uint = 0; y < boardHeight; y++ ) {
                for (var x:uint = 0; x < boardWidth; x++ ) {
                    var grid:FlxSprite = new FlxSprite(x * TILE_WIDTH, y * TILE_HEIGHT, ImgGrid);
                    //grid.makeGraphic(40, 40, 0xffFF0000);
                    gridGroup.add(grid);
                }
            }
            add(gridGroup);
        }
    }

}