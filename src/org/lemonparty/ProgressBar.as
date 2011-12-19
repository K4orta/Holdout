package org.lemonparty 
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class ProgressBar extends FlxSprite implements IEventDispatcher
	{
		public var progress:Number=0;
		public var rate:Number=1;
		public var barColor:uint = 0xFF1133bb;
		public var homeGroup:FlxGroup;
		protected var progGfxBMD:BitmapData=new BitmapData(32,4,false,0xFF000000);
		protected var pRect:Rectangle = new Rectangle(1, 1, 0, 2);
		protected var stay:Number=0;
		public var stayMax:Number;
		
		protected var evd:EventDispatcher = new EventDispatcher(this as IEventDispatcher);
		
		public function ProgressBar(X:Number = 0, Y:Number = 0, R:Number=1,Group:FlxGroup=null, W:int=32, H:int=4) {
			super(X, Y);
			rate = 1 / R;
			stayMax = 1;
			homeGroup = Group;
			progGfxBMD = new BitmapData(W, H, false, 0xFF000000);
			pRect.height = H - 2;	
		}

		override public function update():void {
			super.update();
			if(progress<1){
				progress += rate * FlxG.elapsed;
				progGfxBMD.fillRect(progGfxBMD.rect, 0xFF000000);
				pRect.width = int(progress * (progGfxBMD.width-2));
				progGfxBMD.fillRect(pRect, barColor);
				
				if (progress >= 1) {
					progress = 1;
					dispatchEvent(new Event("COMPLETE"));
					//progGfxBMD.fillRect(progGfxBMD.rect, 0xFFFFFFFF);
				}
				pixels = progGfxBMD;
			}else {
				if (stay < stayMax) {
					stay += FlxG.elapsed;
				}else {
					kill();
					progGfxBMD.dispose();
					homeGroup.remove(this);
					homeGroup = null;
				}
			}
		}
		
		public function cancel():void {
			rate = 0;
			kill();
			progGfxBMD.dispose();
			homeGroup.remove(this);
			homeGroup = null;
			dispatchEvent(new Event("CANCEL"));
		}
		
		public function addEventListener(Type:String, Listener:Function, UseCapture:Boolean = false, Priority:int = 0, UseWeak:Boolean=false):void{
			evd.addEventListener(Type, Listener, UseCapture, Priority);
		}
           
		public function dispatchEvent(Evt:Event):Boolean{
			return evd.dispatchEvent(Evt);
		}
    
		public function hasEventListener(Type:String):Boolean{
			return evd.hasEventListener(Type);
		}
    
		public function removeEventListener(Type:String, Listener:Function, UseCapture:Boolean = false):void{
			evd.removeEventListener(Type, Listener, UseCapture);
		}
                   
		public function willTrigger(Type:String):Boolean {
			return evd.willTrigger(Type);
		}	
	}

}