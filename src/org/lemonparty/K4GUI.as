package org.lemonparty {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.events.Event;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.lemonparty.units.Hero;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.FlxText;
	import flash.geom.Point;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class K4GUI extends FlxGroup {
		[Embed(source = "data/invBoxes.png")] private var ImgBoxes:Class;
		[Embed(source = "data/blockSelect.png")] private var ImgBlockSelect:Class;
		
		[Embed(source = "data/hearts.png")] private var ImgHearts:Class;
		[Embed(source = "data/sgn12rnds.png")] private var ImgShells:Class;
		[Embed(source = "data/bullets20rnds.png")] private var Img308:Class;
		[Embed(source = "data/bullets30rnds.png")] private var Img556:Class;
		
		
		public var invBoxWidth:int = 26;
		public var hpBMD:BitmapData = new BitmapData(53, 5, false, 0xFF000000);
		public var invBMD:BitmapData = new BitmapData(208, 24, true, 0x00000000);
		public var ammoBMD:BitmapData = new BitmapData(60, 5, true, 0x00000000);
		protected var _ammoBox:Rectangle=new Rectangle(0, 0, 60, 8);
		public var heartsBMD:BitmapData;
		public var boxGfx:BitmapData;
		public var ammoGfx:BitmapData;
		public var ammoBar:FlxSprite;
		public var magSelect:FlxSprite;
		public var invBar:FlxSprite;
		
		protected var _heartEmpty:Rectangle=new Rectangle(18, 0, 9, 9);
		
		protected var _heartFull:Rectangle = new Rectangle(0, 0, 9, 9) ;
		protected var _heartHalf:Rectangle = new Rectangle(9, 0, 9, 9) ;
		protected var _invOff:Rectangle = new Rectangle(0, 0, 24,24 ) ;
		protected var _invOn:Rectangle = new Rectangle(24, 0, 24, 24) ;
		protected var _inv:Inventory;
		protected var _itemNumbers:Vector.<FlxText> 
		
		//public var leftCounter:FlxText = new FlxText(500,500, 100, "X: Americans left");
		//public var leftCounter:FlxText = new FlxText(500,500, 100, "X: Americans left");
		
		public var heartBar:FlxBar=new FlxBar(420, 486, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10);
		
		public function K4GUI(){
			super();
			invBar = new FlxSprite(420, 500);
			//x = 152;
			//y = 220;
			//add(hpBar);
			//add(hpHearts);
			//add(ammoBar);
			boxGfx = (new ImgBoxes).bitmapData;
			
			invBar.scrollFactor.x = invBar.scrollFactor.y = 0;
			heartBar.createImageBar(null, ImgHearts, 0x0);
			heartBar.setRange(0, 10);
			heartBar.currentValue = 10;
			add(heartBar);
			heartBar.scrollFactor.x = heartBar.scrollFactor.y=0
			//leftCounter.scrollFactor.x = leftCounter.scrollFactor.y=0
			add(invBar);
			//add(leftCounter);
			
			var tt:K4Dialog = new K4Dialog("1975.... 30 years after the end of World War II\nHaving never been informed of Japan's surrender, Hiro Kurasuda continues to defend his island post.", 15,-330,440);
			add(tt);
			
		}
		
		// Inventory
		
		/*public function updateHp(ev:Event):void {
			staBMD.fillRect(staBMD.rect, 0xFF000000);
			staBMD.fillRect(new Rectangle(1, 1, int(51*ev.currentTarget.restStamina / ev.currentTarget.maxStamina), 3), 0xFF273b6e);
			staBMD.fillRect(new Rectangle(1, 1, int(51*ev.currentTarget.stamina / ev.currentTarget.maxStamina), 3), 0xFF5C8CFF);
			staminaBar.pixels = staBMD;
		}*/
		
		public function redrawHealth(Arg:Number):void {
			heartBar.currentValue = Arg;
		}
		
		
		
		public function setupInv(He:Hero):void {
			_inv = He.inv;
			_itemNumbers = new Vector.<FlxText>();
			for (var i:int = 0;i<_inv.invSize;++i) {
				_itemNumbers[i] = new FlxText((i * invBoxWidth)+invBar.x+10, invBar.y+12, 32, "0");
				add(_itemNumbers[i]);
				_itemNumbers[i].scrollFactor.x = _itemNumbers[i].scrollFactor.y = 0;
				_itemNumbers[i].visible = false;
			}
			redrawInv();
		}
		
		public function redrawInvNumbers():void {
			for (var i:int = 0; i < _inv.invSize;++i ) {
				if (_inv.slot[i]) {
					if (_inv.slot[i].numItems>1) {
						_itemNumbers[i].visible = true;
						_itemNumbers[i].text = String(_inv.slot[i].numItems);
					}else {
						_itemNumbers[i].visible = false;
					}
				}else {
					_itemNumbers[i].visible = false;
				}
			}
		}
		
		public function redrawInv():void {
			invBMD.fillRect(invBMD.rect, 0x00000000);
			var tg:BitmapData;
			for (var i:int = 0;i<_inv.invSize;++i ) {
				if (_inv.curSel == i){
					invBMD.copyPixels(boxGfx, _invOn, new Point(i * invBoxWidth, 0));
				}else{
					invBMD.copyPixels(boxGfx, _invOff, new Point(i * invBoxWidth, 0));
				}
				if (_inv.slot[i]) {
					tg = (new _inv.slot[i].cameo).bitmapData;
					invBMD.copyPixels(tg, _invOff, new Point(i * invBoxWidth, 0), null, null, true);
					if (_inv.slot[i].numItems>1) {
						_itemNumbers[i].visible = true;
						_itemNumbers[i].text = String(_inv.slot[i].numItems);
					}else {
						_itemNumbers[i].visible = false;
					}
				}
				
			}
			invBar.pixels = invBMD;
		}
		
	}

}