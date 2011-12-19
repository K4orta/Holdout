package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class StarFish extends Unit 
	{
		[Embed(source = "../data/starfish.png")] protected var ImgHero:Class;
		public function StarFish(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			acceleration.y = 0;
			loadGraphic(ImgHero);
			//velocity.y = 40;
		}
		
		override public function update():void {
			super.update();
			acceleration.y = 100;
			if (isTouching(FLOOR)) {
				_logic.blood(x+width*.5,y+height*.5);
				kill();
			}
		}
		
	}

}