package org.lemonparty.items 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.Barricade;
	import org.lemonparty.GameObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Materials extends GameObject 
	{
		[Embed(source = "../data/bamboCameo.png")] protected var bambooCameo:Class;
		public function Materials(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			canPack = true;
			canPickup = true;
			canUse = true;
			maxStack = 8;
			numItems = 6;
			loadGraphic(bambooCameo);
			cameo = bambooCameo;
		}
		
		override public function onUse():void {
			var pt:FlxPoint = _logic.dropToGround(new FlxPoint(FlxG.mouse.x, int(FlxG.mouse.y/32)*32));
			_logic.miscObjects.add(new Barricade(pt.x, pt.y-32));
			numItems -= 1;
			_logic.gui.redrawInvNumbers();
			if (numItems < 1) {
				owner.inv.removeItem(this);
			}
			
		}
		
	}

}