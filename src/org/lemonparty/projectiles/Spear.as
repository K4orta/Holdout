package org.lemonparty.projectiles 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.Projectile;
	import org.flixel.FlxSprite;
	import org.lemonparty.K4G;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Spear extends EnProj
	{
		[Embed(source = "../data/trident.png")] protected var tracerImg:Class;
		public function Spear(X:Number,Y:Number) {
			super(X,Y);
			loadGraphic(tracerImg);
		}
		
		override public function hitMap():void {
			super.hitMap();
		}
		
		override public function hitPlayer(Arg:Unit):void{
			super.hitPlayer(Arg);
			Arg.hurt(1);
		}

		
	}

}