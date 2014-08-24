package
{
    import org.flixel.FlxState;
    import org.flixel.FlxText;

    public class GameoverState extends FlxState
    {

        public function GameoverState()
        {
            add(new FlxText(50, 50, 100, "GAME OVER!"));
        }

    }

}