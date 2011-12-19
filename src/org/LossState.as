package org 
{
	import org.flixel.FlxState;
	import org.lemonparty.K4Dialog;
	import org.lemonparty.K4G;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class LossState extends FlxState 
	{
		
		public function LossState() 
		{
			add(new K4Dialog("You defended your island against: " + K4G.kills +" Invaders",-1,120,200));
			add(new K4Dialog("Thanks for playing! -K4Orta",-1,220,300));
		}
		
	}

}