package

{

	import org.flixel.*;
	[SWF(width="960", height="540", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]



	public class Holdout extends FlxGame{

		public function Holdout(){

			super(960,540,PlayState,1, 60, 60);
			forceDebugger = false;
		}

	}

}

