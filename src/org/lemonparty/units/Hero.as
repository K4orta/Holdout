package org.lemonparty.units 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.lemonparty.Unit;
	import org.flixel.*;
	import org.lemonparty.*;
	import org.lemonparty.projectiles.Bullet;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Hero extends Unit {
		[Embed(source = "../data/noda.png")] protected var ImgHero:Class;
		
		
		protected var _jumpPower:Number;
		public var jumping:Boolean = false;
		public var canWallJump:Boolean = false;
		protected var _inv:Inventory;
		public var newPickup:Boolean = false;
		public var moving:Boolean=false;
		public var covered:Boolean = false;
		public var invuln:Boolean = false;
		public var hurtTime:FlxDelay = new FlxDelay(1000);
		
		public function Hero(X:Number = 0, Y:Number = 0){
			super(X, Y);
			loadGraphic(ImgHero, true, true,30,55);
			_inv = new Inventory(this);
			
			maxHealth = 10;
			_jumpPower = 460;
			_maxRunSpeed = 280;
			offset.x = 5;
			
			width = 22;
			height = 53;
			health = 10;
			
			addAnimation("idle", [0], 0,false);
			addAnimation("run", [1, 2, 3, 4], 8, true);
			addAnimation("jump", [1], 0);
		}
		
		
		override public function update():void {
			drawFrame(true);
			acceleration.x = 0;
			if (hurtTime.hasExpired) {
				invuln = false;
			}
			if (climbingLadder) 
				acceleration.y = 0;
			
			if (FlxG.mouse.justPressed()) {
				if (inv.canUseCur()) {
					inv.useCur();
				}
			}
			
			handleKeys();
			checkCover();
			
			if (fallingCloud) {
				if (y > fallPlatform) {
					allowCollisions = ANY;
					fallPlatform = 0;
					fallingCloud = false;
				}
			}
			
			if (isTouching(FLOOR)&&velocity.x&&velocity.y>=0) {
				play("run");
			}else if (abs(velocity.y)>0) { 
				play("jump");
			}else if(isTouching(FLOOR)){
				play("idle");
			}
			
			super.update();
		}
		
		override public function hurt(Dam:Number):void {
			if(!invuln){
				super.hurt(Dam);
				flicker(1);
				K4G.logic.gui.redrawHealth(health);
				invuln = true;
				hurtTime.start();
			}
		}
		
		public function checkCover():Boolean {
			if ((velocity.x > 1 || velocity.y > 1)&&!moving){
				moving = true;
				startMove();
			}else if ((velocity.x < 1 && velocity.y < 1)&&moving) {
				moving = false;
				endMove();
			}
			return false;
		}
		
		public function startMove():void {
			covered = false;
			//play("idle");
			//alpha = 1;
		}
		
		override public function kill():void {
			
			FlxG.fade(0xffffffff, 1, _logic.loss);
			
			//super.kill();
		}
		
		public function endMove():void {
			for each(var a:Cover in _logic.cover.members) {
				if (getDist(a) < 32) {
					covered = true;
					//play("crouch");
				}
			}
		}

		override public function postUpdate():void {
			
			super.postUpdate();
			if (carrying) {
				
				carrying.facing = facing;
				if (facing == LEFT) {
					carrying.x = x-15;
				}else {
					carrying.x = x;
				}
				carrying.y = y +carrying.yOff;
				
			}
			//x = Math.round(x);
			
		}
		
		public function handleKeys():void {
			if (FlxG.keys.justPressed("SHIFT")) {
				//FlxG.mouse.show();
			}else if (FlxG.keys.justReleased("SHIFT")) {
				//FlxG.mouse.hide();
			}
			
			if (FlxG.keys.justPressed("S")) {
				FlxG.overlap(this, _logic.checkUse, grabItem);
			}
			
			if (FlxG.keys.A) {
				facing = LEFT;
				offset.x = 0;
				
				if(velocity.x>-_maxRunSpeed)
					acceleration.x -= drag.x;
				if (climbingLadder) {
					stopClimb();
				}
			}else if (FlxG.keys.D) {
				facing = RIGHT;
				offset.x = 2;
				
				if(velocity.x<_maxRunSpeed)
					acceleration.x += drag.x;
				if (climbingLadder) {
					stopClimb();
				}
			}else if (FlxG.keys.W) {
				checkClimb();
				if (climbingLadder) {
					acceleration.y -= 250;
				}
			}else if (FlxG.keys.S) {
				checkClimb();
				if (climbingLadder) {
					acceleration.y += 250;
				}
			}
			
			if(FlxG.keys.justPressed("SPACE") && (!velocity.y||climbingLadder)){
				//drop through cloud
				if (FlxG.keys.S&&_map.getTile(int((x+7)/16),int((y+height+8)/16))==17) {
					allowCollisions = NONE;
					fallingCloud = true;
					fallPlatform = y+16;
				}else {
					//regular jump
					if (climbingLadder) {
						stopClimb();
					}
					velocity.y = -_jumpPower;
					jumping = true;
					play("jump",true);
				}
			}
			
			if (justTouched(DOWN)) {
				canWallJump = false;
			}
			
			if(FlxG.keys.justReleased("SPACE") && velocity.y){
				canWallJump = true;
			}
			
			if(isTouching(LEFT)&&FlxG.keys.justPressed("SPACE") && canWallJump){
				velocity.y = -_jumpPower*.9;
				velocity.x += 200;
			}else if(isTouching(RIGHT)&&FlxG.keys.justPressed("SPACE") && canWallJump){
				velocity.y = -_jumpPower*.9;
				velocity.x += -200;
			}
		}
		
		override public function addToInv(Item:GameObject, CurSlot:Boolean=false):Boolean {
			if(_inv.add(Item)>-1)
				return true;
			else
				return false;
		}
		
		override public function grabItem(Ob1:FlxObject, Ob2:FlxObject):GameObject {
			newPickup = true;
			var ti:GameObject = super.grabItem(Ob1, Ob2);
			
			if (ti.canPack) {
				if(carrying&&carrying.canPack){
					_inv.add(ti);
					if (carrying != ti) {
						ti.onPickup();
					}
				}
			}
			return ti;
		}
		
		override public function get inv():Inventory {
			return _inv;
		}
	}

}