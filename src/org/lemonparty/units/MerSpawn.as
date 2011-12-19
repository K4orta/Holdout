package org.lemonparty.units 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class MerSpawn extends FlxSprite
	{
		[Embed(source = "../data/spawnZone.png")] protected var spawnZone:Class;
		public function MerSpawn(X:Number,Y:Number) {
			super(X, Y);
			//loadGraphic(spawnZone);
			visible = false;
		}
		
	}

}