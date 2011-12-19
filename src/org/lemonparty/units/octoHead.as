package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class octoHead extends Unit 
	{
		[Embed(source = "../data/octoHead.png")] protected var ImgHero:Class;
		public function octoHead(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			loadGraphic(ImgHero);
			health = 5000;
			width = 100;
			offset.x = 100;
			solid = false;
			acceleration.y = 0;
		}
		
	}

}