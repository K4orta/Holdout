package org.lemonparty 
{
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Flag extends GameObject 
	{
		[Embed(source = "data/japFlag.png")] protected var ImgFlag:Class;
		public var cappable:Boolean = true;
		public var flagOwner:uint = 0; // 0 none, 1 player, 2 mermen 
		
		public function Flag(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			loadGraphic(ImgFlag);
			
			
		}
		
	}

}