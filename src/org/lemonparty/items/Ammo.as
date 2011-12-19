package org.lemonparty.items 
{
	import org.lemonparty.GameObject;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Ammo extends GameObject 
	{
		[Embed(source = "../data/bullet.png")] private var ImgShot:Class;
		public function Ammo(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			canUse = false;
			canPack = true;
			subClass = "ammo";
			cameo = ImgShot;
			loadGraphic(ImgShot);
			canPickup = true;
			maxStack = 100;
			numItems = 100;
		}
		
	}

}