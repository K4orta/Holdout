package org.lemonparty.items 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.lemonparty.GameObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.lemonparty.Unit;
	import org.lemonparty.projectiles.Bullet;
	import org.lemonparty.K4G;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class T99 extends GameObject 
	{
		[Embed(source = "../data/t99Cameo.png")] protected var t99Cameo:Class;
		[Embed(source = "../data/t99.png")] protected var t99Img:Class;
		public var maxBullets:int = 5;
		public var bullets:int = 5;
		public var chambered:Boolean = true;
		public var rof:FlxDelay = new FlxDelay(200);
		public function T99(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			cameo = t99Cameo;
			loadGraphic(t99Img,false,true);
			canPack = true;
			canPickup = true;
			canUse = true;
			rof.start();
			yOff = 24;
		}
		
		override public function onEquip():void {
			super.onEquip();
			facing = owner.facing;
				if (facing == LEFT) {
					x = owner.x-15;
				}else {
					x = owner.x;
				}
				y = owner.y + 32;
		}
		
		override public function onUse():void {
			if (chambered) {
				if(rof.hasExpired){
					var ori:FlxPoint = new FlxPoint();
					var norm:FlxPoint = new FlxPoint();
					var slope:FlxPoint = new FlxPoint();
					var len:Number;
					ori.make(owner.x + owner.origin.x, owner.y + owner.origin.y);
					slope.make(FlxG.mouse.x+_logic.camOffset.x - ori.x, FlxG.mouse.y+_logic.camOffset.y - ori.y);
					len = sqrt(slope.x*slope.x + slope.y*slope.y);
					norm.make(slope.x / len, slope.y / len);
					_logic.camOffset.x = Math.random() * 100 -50;
					_logic.camOffset.y = Math.random() * 100 -50;
					_logic.bullets.add(new Bullet(ori, norm));
					rof.start();
					chambered = false;
					var nb:GameObject = owner.inv.hasItem("ammo");
					if (nb) {
						if (nb.numItems > 0) {
							--nb.numItems;
							_logic.gui.redrawInvNumbers();
							chambered = true;
						}
						if (nb.numItems<1) {
							owner.inv.removeItem(nb);
						}
					}
				}
			}else {
				var nr:GameObject = owner.inv.hasItem("ammo");
					if (nr) {
						if (nr.numItems > 0) {
							--nr.numItems;
							_logic.gui.redrawInvNumbers();
							chambered = true;
						}
						if (nr.numItems<1) {
							owner.inv.removeItem(nr);
						}
					}
			}
		}
		
	}

}