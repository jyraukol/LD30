package
{

    public class Registry
    {
        [Embed(source = "../assets/background.png")] public static var backGroundImage:Class;
        public static var score:int = 0;
        public static var longestCombo:int = 0;
        public static var playTime:int = 0;

        public function Registry()
        {

        }

    }

}