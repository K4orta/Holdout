package org.lemonparty 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.lemonparty.items.Ammo;
	import org.lemonparty.K4G;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Stash extends GameObject 
	{
		[Embed(source = "data/stash.png")] protected var stashImg:Class;
		public var rechargeDelay:FlxDelay = new FlxDelay(600);
		
		public function Stash(X:Number, Y:Number) {
			super(X, Y);
			loadGraphic(stashImg);
			health = 2000;
			immovable = true;
			rechargeDelay.start();
			acceleration.y = 0;
		}
		
		override public function update():void {
			super.update();
			if(rechargeDelay.hasExpired){
				if (abs(getDist(_logic.curSel)) < 200) {
					if (_logic.curSel.health < _logic.curSel.maxHealth) {
						++_logic.curSel.health;
						_logic.gui.redrawHealth(_logic.curSel.health);
						rechargeDelay.start();
					}
					var am:GameObject = _logic.curSel.inv.hasItem("ammo");
					var ti:GameObject;
					if (am) {
						if (am.numItems < am.maxStack) {
							if(am.numItems+25<=am.maxStack){
								am.numItems += 25;
							}else{
								am.numItems = am.maxStack;
							}
							rechargeDelay.start();
						}
					}else {
						ti = new Ammo(0,0);
						_logic.items.add(ti);
						_logic.curSel.addToInv(ti);
						rechargeDelay.start();
					}
					_logic.gui.redrawInvNumbers();
				}
			}
		}
		
		override public function hurt(Dam:Number):void {
			flicker(.5);
			super.hurt(Dam);
		}
		override public function kill():void {
			
			FlxG.fade(0xffffffff, 1, _logic.loss);
			
			//super.kill();
		}
		
		
	}

}