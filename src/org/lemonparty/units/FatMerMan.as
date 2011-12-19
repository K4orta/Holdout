package org.lemonparty.units 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.lemonparty.K4G;
	import org.lemonparty.projectiles.Spear;
	import org.lemonparty.Unit;
	import org.lemonparty.btree.*;
	import org.lemonparty.*;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class FatMerMan extends Unit 
	{
		[Embed(source = "../data/fatmer.png")] protected var ImgMer:Class;
		public var brain:Node;
		public var attacking:Boolean = false;
		public var rangeDelay:FlxDelay = new FlxDelay(2500);
		
		
		public function FatMerMan(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			loadGraphic(ImgMer, true, true,74,65);
			health = 60;
			hostileGroup = _logic.player;
			_maxRunSpeed = 140+ int(Math.random()*100);
			drag.x = _maxRunSpeed * 10;
			meleeReady = new FlxDelay(1000);
			meleeReady.start();
			meleeRange = 80;
			
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1], 15, true);
			addAnimation("attack", [2,2,3,4], 15, true);
			
			rangeDelay.reset(1);
			sightRange = 1000;
			
			if (Math.random() < .5) {
				facing = LEFT;
			}else {
				facing = RIGHT;
			}
			acceleration.y = K4G.gravity;
			width = 32;
			height = 62;
			offset.x = 20;
			offset.y = 2;
		}
		
		override public function update():void {
			super.update();
			
			if (attTar) {
				
				if (meleeReady.hasExpired && getDist(attTar)< meleeRange) {
					attacking = true;
					play("attack",true);
					meleeReady.start();
					_logic.bamboo(attTar.x+attTar.origin.x+(Math.random()*50)-25,attTar.y+attTar.origin.y+(Math.random()*50)-25);
					attTar.hurt(50);
					velocity.x = 0;
				}
				if (!attTar.alive) {
					attTar = null;
				}
			}
			
			susOb = combatSight(_logic.curSel);
			
			if (susOb &&! attTar) {
				if(rangeDelay.hasExpired){
					var ss:Spear = new Spear(x + origin.x, y + 8);
					var a:Number = FlxVelocity.angleBetween(ss, _logic.curSel);
					ss.velocity.x = Math.cos(a) * 400;
					ss.velocity.y = Math.sin(a) * 400;
					ss.angle = a*180/ Math.PI;
					_logic.enemyBullet.add(ss);
					rangeDelay.reset(2000+Math.random()*1000);
				}
			}
			
			
			
			if (abs(velocity.x) > 0) {
				if (velocity.x < 0 ) {
					facing = LEFT;
				}else if (velocity.x>0 ) {
					facing = RIGHT;
				}
				if(!attTar){
					play("walk");
				}
			}
			
		}
		
		override public function kill():void {
			++K4G.kills;
			super.kill();
			
		}
		
		override public function hurt(Damage:Number):void {
			super.hurt(Damage);
			flicker(.6);
			//moveOrder(new FlxPoint(_logic.curSel.x,_logic.curSel.y));
		}
		
	}

}