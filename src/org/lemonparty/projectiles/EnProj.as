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
	public class EnProj extends FlxSprite
	{
		public var life:int = 0;
		//[Embed(source = "../data/trident.png")] protected var tracerImg:Class;
		public function EnProj(X:Number,Y:Number) {
			super(X,Y);
			//loadGraphic(tracerImg);
	
		}
		
		override public function update():void { 
			super.update();
			++life;
			if (life > 300) {
				kill();
			}
		}
		
		
		public function hitMap():void {
			kill();
		}
		
		public function hitPlayer(Arg:Unit):void{
			kill();
			//Arg.hurt(1);
		}

		
	}

}