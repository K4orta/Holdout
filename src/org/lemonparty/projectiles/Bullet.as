package org.lemonparty.projectiles
{
	import org.lemonparty.Projectile;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Bullet extends Projectile
	{
		[Embed(source = "../data/tracer.png")] private var ImgShot:Class;
		[Embed(source = "../data/mark.png")] public var ImgMark:Class;
		public function Bullet(Ori:FlxPoint, Normal:FlxPoint) {
			speed = 9000;
			super(Ori, Normal, speed);
			minDmg = 3;
			minRange = 90;
			maxRange = 400;
			maxDmg = 5;
		}
		
		override public function update():void {
			super.update();
			//if (curLife==2) {
				//addTracer(ImgShot);
			//}
		}
	}

}