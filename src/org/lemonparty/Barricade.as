package org.lemonparty 
{
	import org.flixel.plugin.photonstorm.FlxBar;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Barricade extends GameObject 
	{
		
		[Embed(source = "data/barricade.png")] protected var ImgBlock:Class;
		public var hpBar:FlxBar;
		public function Barricade(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			maxHealth = health = 1000;
			acceleration.y = 0;
			loadGraphic(ImgBlock);
			immovable = true;
			hpBar = new FlxBar(X, Y - 10, FlxBar.FILL_LEFT_TO_RIGHT, 64, 5, this, "health", 0, 1000, true);
			
			_logic.marks.add(hpBar);
		}
		
		override public function hurt(Dam:Number):void {
			super.hurt(Dam);
			/*var per:Number = health / maxHealth;
			per = 1 - per;
			offset.y =- 90 * per;*/
		}
		
		override public function kill():void {
			hpBar.kill();
			super.kill();
			
		}
		
	}

}