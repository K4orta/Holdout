package org.lemonparty.units 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.lemonparty.GameObject;
	import org.lemonparty.Unit;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Trap extends GameObject 
	{
		[Embed(source = "../data/trap.png")] protected var trapImg:Class;
		public var ready:Boolean = true;
		public var autoRid:FlxDelay = new FlxDelay(2000);
		public function Trap(X:Number=0, Y:Number=0, SimpleGraphic:Class=null){
			super(X, Y, SimpleGraphic);
			loadGraphic(trapImg, true, false, 32, 32);
			addAnimation("idle", [0], 0, false);
			addAnimation("sprung", [0, 0, 0, 1, 2, 3], 60, false);
			play("idle");
		}
		
		public function springOn(Arg:Unit):void {
			if(ready){
				ready = false;
				play("sprung", true);
				Arg.hurt(120);
				//flicker(2);
				autoRid.start();
			}
		}
		
		override public function update():void {
			if (autoRid.hasExpired) {
				kill();
			}
		}
		
	}

}