package{
	import flash.events.TimerEvent;
	import org.flixel.*;
	import org.lemonparty.*;
	import org.lemonparty.items.*;
	import org.lemonparty.projectiles.EnProj;
	import org.lemonparty.units.*;
	import org.flixel.plugin.photonstorm.*;
	import org.LossState;
	
	public class PlayState extends FlxState
	{
		[Embed(source = "org/lemonparty/data/maps/Island.txt", mimeType = "application/octet-stream")] public var mapTiles:Class;
		[Embed(source = "org/lemonparty/data/maps/Island_background2.txt", mimeType = "application/octet-stream")] public var mapBackground:Class;
		[Embed(source = "org/lemonparty/data/maps/Island_Sprites.txt", mimeType = "application/octet-stream")] public var mapSprites:Class;
		[Embed(source = "org/lemonparty/data/mark.png")] public var ImgMark:Class;
		//[Embed(source = "org/lemonparty/data/crosshair.png")] public var ImgCrosshair:Class;
		
		[Embed(source = "org/lemonparty/data/tiles1.png")] public var Img_Main:Class;
		[Embed(source = "org/lemonparty/data/backset1.jpg")] public var Img_BG:Class;
		[Embed(source = "org/lemonparty/data/gooParts.png")] private var ImgBlood:Class;
		[Embed(source = "org/lemonparty/data/bambooParts.png")] private var ImgBBPart:Class;
		[Embed(source = "org/lemonparty/data/crosshair.png")] private var ImgCrosshair:Class;
		public var map:K4Map;
		public var gameMap:ColorTilemap;
		public var player:FlxGroup = new FlxGroup();
		public var enemies:FlxGroup = new FlxGroup();
		public var metaGroup:FlxGroup = new FlxGroup();
		public var items:FlxGroup = new FlxGroup();
		public var checkUse:FlxGroup = new FlxGroup();
		public var cover:FlxGroup = new FlxGroup();
		public var bullets:FlxGroup = new FlxGroup();
		public var miscObjects:FlxGroup = new FlxGroup();
		public var emotes:FlxGroup = new FlxGroup();
		public var marks:FlxGroup = new FlxGroup();
		public var flags:FlxGroup = new FlxGroup();
		public var spawns:FlxGroup = new FlxGroup();
		public var particles:FlxGroup = new FlxGroup();
		public var pickups:FlxGroup = new FlxGroup();
		public var traps:FlxGroup = new FlxGroup();
		public var enemyBullet:FlxGroup = new FlxGroup();
		public var enemyBulletsHit:FlxGroup = new FlxGroup();
		
		public var bulletsHit:FlxGroup = new FlxGroup();
		
		public var gui:K4GUI;
		public var curSel:Unit;
		
		public var lights:FlxGroup = new FlxGroup();
		public var calendar:TimeKeeper = new TimeKeeper();
		
		public var camFollow:FlxObject=new FlxObject();

		public var _pf:FlxPathfinding;
		
		// Game Flow stuff;
		public var spawnTimer:FlxDelay;
		public var spawnFlag:Flag;
		
		public var wave1:Object = { "merMan":16, "merMan":16, "merMan":16 };
		public var camOffset:FlxPoint = new FlxPoint(0, -400);
		public var sparks:FlxEmitter = new FlxEmitter(0,0,100);
		public var bloodPart:FlxEmitter = new FlxEmitter(0, 0, 100);
		public var bambooPart:FlxEmitter = new FlxEmitter(0, 0, 100);
		public var pool:int = 40;
		public var rate:int = 5000;
		public var minRate:int = 1000;
		public var kills:int = 0;
		public var messages:Array = [];
		public var messageDelay:FlxDelay = new FlxDelay(70);
		public var lossDelay:FlxDelay  = new FlxDelay(200);
		
		override public function create():void{
			K4G.logic = this;
			K4G.lights = lights;
			K4G.calendar = calendar;
			map = new K4Map();
			K4G.map = map;
			gui = new K4GUI();
			gameMap = map.layerMain;
			FlxG.bgColor = 0xff000000;
			
			map.loadMap(new mapTiles(), new mapBackground(), Img_Main, Img_BG, 32, 32, FlxTilemap.OFF, 0, 1, 9);
			map.loadSprites(new mapSprites());
			//FlxG.mouse.load(ImgCrosshair, 3, 3);
			// add groups
			_pf = new FlxPathfinding(map.layerMain);
			
			add(map.backLayer);
			
			
			FlxG.flash(0xff000000, 2);
			
			add(miscObjects);
			add(player);
			add(items);
			add(pickups);
			add(map.layerMain);
			metaGroup.add(particles);
			metaGroup.add(traps);
			metaGroup.add(pickups);
			metaGroup.add(player);
			metaGroup.add(miscObjects);
			
			metaGroup.add(enemies);
			
			add(enemies);
			add(traps);
			add(bullets);
			add(emotes);
			add(marks);
			add(spawns);
			add(enemyBullet);
			add(particles);
			enemyBulletsHit.add(map.layerMain);
			enemyBulletsHit.add(player);
			
			bulletsHit.add(enemies);
			bulletsHit.add(cover);
			
			gui.setupInv(curSel as Hero);
			add(gui);
			
			player.add(curSel);
			var ti:GameObject = new T99(0, 0);
			items.add(ti);
			//curSel.inv.add();
			curSel.addToInv(ti);
			ti = new Materials(0, 0);
			items.add(ti);
			curSel.addToInv(ti);
			
			ti = new Ammo(0, 0);
			items.add(ti);
			curSel.addToInv(ti);
			
			//curSel.inv.unpack(0);
			FlxG.camera.setBounds(0,0,map.layerMain.width,map.layerMain.height,true);
			FlxG.camera.follow(camFollow);
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			FlxG.mouse.show();
			FlxG.mouse.load(ImgCrosshair,1,-11,-11);
			
			for each(var a:GameObject in miscObjects.members) {
				if(a is Flag){
					
					flags.add(a);
					
				}
			}
			spawnFlag = getRightFlag();
			spawnTimer = new FlxDelay(12000);
			spawnTimer.start();
			
			bloodPart.setXSpeed(-200,200);
			bloodPart.setYSpeed( -200, 200);
			bloodPart.bounce = .1;
			bloodPart.gravity = 300;
			bloodPart.makeParticles(ImgBlood, 100, 16, true);
			
			bambooPart.setXSpeed(-100,100);
			bambooPart.setYSpeed( -100, 100);
			bambooPart.bounce = .1;
			bambooPart.gravity = 300;
			bambooPart.makeParticles(ImgBBPart, 100, 16, true);
			
			particles.add(bloodPart);
			particles.add(bambooPart);
			add(new K4Dialog("WASD to move, Space to jump, Use items/shoot with the mouse, cycle items with the mouse wheel.\n Defend your ammo cache from invading American forces.\n You can get more health/ammo by stading near your cache.",20,-650,25));
			
		}
		
		public function loss():void{
			FlxG.switchState(new LossState());
		}
		
		override public function update():void{
			super.update();
			//calendar.update();
			map.update();
			FlxG.collide(map.layerMain,metaGroup);
			FlxG.overlap(bullets, bulletsHit, registerHit);
			
			FlxG.collide(enemyBulletsHit, enemyBullet, enemyBulletHit);
			FlxG.collide(player,enemies,enemyTouchedPlayer);
			
			camFollow.x = curSel.x;
			camFollow.x = curSel.x+(FlxG.mouse.screenX-480)+8+camOffset.x;
			camFollow.y = curSel.y + (FlxG.mouse.screenY - 240) + 16 + camOffset.y;
			
			
			camOffset.x *= .92;
			camOffset.y *= .92;
			
			//FlxG.collide(enemies, miscObjects, enemyHitBarricade);
			FlxG.overlap(enemies,miscObjects,null,enemyHitBarricade);
			FlxG.overlap(enemies,traps,null,enemyHitTrap);
			
			collideBullets();
			var fdb:FlxBasic = bullets.getFirstDead();
			if(fdb)
				bullets.remove(fdb, true);
				
			if (FlxG.mouse.wheel != 0) {
				if(FlxG.mouse.wheel<0) {
					curSel.inv.nextSlot();
				}else {
					curSel.inv.prevSlot();
				}
			}
				
			if (spawnTimer.hasExpired) {
				
				for (var i:int = 0;i<3;++i ){
					var tar:Flag = getLeftFlag();
					var sz:MerSpawn = spawns.getRandom() as MerSpawn;
					var nfm:FatMerMan = new FatMerMan(sz.x, sz.y - 32);
					nfm.velocity.y = -300;
					enemies.add(nfm);
					nfm.moveOrder(dropToGround(new FlxPoint(tar.x-64,tar.y)), nfm.dumbPath);
					
				}
				
				for (i = 0; i < 3;++i ) {
					var sf:StarFish = new StarFish(curSel.x+ (Math.random()*960)-480, 700);
					enemies.add(sf);
				}
					if(rate>minRate){
						rate -= int(Math.random() * 500);
					}
					
					spawnTimer.reset(rate);
			}
			
			
		}
		
		public function spawnStarFish():void {
			
		}
		
		public function enemyTouchedPlayer(Ob1:FlxObject, Ob2:FlxObject):void {
			if(Ob1.isTouching(FlxObject.LEFT)||Ob1.isTouching(FlxObject.RIGHT)){
				Ob1.hurt(1);
			}else {
					Ob1.velocity.y = 0;
			}
			
		}
		
		public function enemyBulletHit(Ob1:FlxObject, Ob2:FlxObject):void {
			if (Ob1 is FlxTilemap) {
				(Ob2 as EnProj).hitMap(); 
			}else if (Ob1 is Unit) {
				(Ob2 as EnProj).hitPlayer(Ob1 as Unit); 
			}
		}
		
		public function enemyHitBarricade(Ob1:FlxObject, Ob2:FlxObject):void {

				var cv:Unit = Ob1 as Unit;
				cv.attack(Ob2 as GameObject);
			if (Ob2 is Barricade) {
				FlxObject.separate(Ob1,Ob2);
			}
		}
		
		public function bamboo(X:Number, Y:Number):void {
			bambooPart.x = X;
			bambooPart.y = Y;
			bambooPart.start(true, .7, 0.1,6);
		}
		
		public function blood(X:Number, Y:Number):void {
			bloodPart.x = X;
			bloodPart.y = Y;
			bloodPart.start(true, .7, 0.1, 16);
		}
		
		public function enemyHitTrap(Ob1:FlxObject, Ob2:FlxObject):void {
			//trace(Ob1);
			
			var cv:Trap = Ob2 as Trap;
			cv.springOn(Ob1 as Unit);
			
		}
		
		public function getLeftFlag():Flag {
			var ret:Flag = flags.getFirstAlive() as Flag;
			
			for each(var a:Flag in flags.members) {
				if (a.x< ret.x) {
					ret = a;
				}
			}
			
			return ret;
		}
		
		public function getRightFlag():Flag {
			var ret:Flag = flags.getFirstAlive() as Flag;
			
			for each(var a:Flag in flags.members) {
				if (a.x> ret.x) {
					ret = a;
				}
			}
			
			return ret;
		}
		
		public function dropToGround(Arg:FlxPoint):FlxPoint {
			var sy:int = Arg.y;
			var sx:int = Arg.x;
			if (gameMap.blocked(Arg)) {
				return Arg;
			}else {
				var i:int = 0;
				while (!gameMap.blocked(new FlxPoint(sx,sy+(i*32)))&&i<100) {
					++i;
				}
				
				return new FlxPoint(Arg.x,Arg.y+((i-2)*32));
			}
			return Arg;
		}
		
		public function collideBullets():void {
			var hitPos:FlxPoint = new FlxPoint(); 
			var i:uint = 0;
			var dx:Number;
			var dy:Number;
			var dst:Number; 
			var curLow:Number;
			var lowI:int = -1;
			for each(var a:Projectile in bullets.members) {
				if (a&&a.alive) {
					if (!gameMap.ray(a.tail, a.head, hitPos)) {
						a.hitLocs.push(new FlxPoint(hitPos.x, hitPos.y));
						a.hits.push(gameMap);
					}
					//object checks here
					if(a.hitLocs.length>0){
						i = 0;
						curLow = Infinity;
						lowI = -1;
						while (i < a.hitLocs.length) {
							dx = a.hitLocs[i].x - a.ori.x;
							dy = a.hitLocs[i].y - a.ori.y;
							dst = sqrt(dx * dx + dy * dy);
							if(dst<curLow){
								lowI = i;
								curLow = dst;
							}
							++i;
						}
						if (lowI < 0) continue;
						if (a.hits[lowI] is GameObject) {
							a.hits[lowI].hurt(33);
							blood(a.hitLocs[lowI].x,a.hitLocs[lowI].y);
							a.kill();
							//mark(a.hitLocs[lowI].x,a.hitLocs[lowI].y);
						}else if(a.hits[lowI] is FlxTilemap){
							a.kill();
							//mark(a.hitLocs[lowI].x, a.hitLocs[lowI].y);
							//map.hurtTile(int((a.hitLocs[lowI].x+a.normal.x)/32), int((a.hitLocs[lowI].y+a.normal.y)/32), 1);
						}
					}
				}
			}
		}
		
		public function registerHit(Ob1:FlxObject,Ob2:FlxObject):void {
			var proj:Projectile = Ob1 as Projectile;
			var tar:BasicObject = Ob2 as BasicObject;
			var ret:FlxPoint = tar.ray(proj.tail, proj.head, proj.normal);
			if (ret) {
				proj.hits.push(Ob2);
				proj.hitLocs.push(new FlxPoint(ret.x, ret.y));
			}
		}
		
		public function sqrt(val:Number):Number{
			if (isNaN(val)){
				return NaN;
			}
			
			var thresh:Number = 0.002;
			var b:Number = val * 0.25;
			var a:Number;
			var c:Number;
			
			if (val == 0){
				return 0;
			}
			
			do {
				c = val / b;
				b = (b + c) * 0.5;
				a = b - c;
				if (a < 0) a = -a;
			}
			while (a > thresh);
			
			return b;
		}
		
		public function killBullet(Ob1:FlxBasic,Ob2:FlxBasic):void {
			//Ob2.kill();
			trace("hat map");
		}
		
		public function mark(X:Number,Y:Number):void {
			marks.add(new FlxSprite(X, Y, ImgMark));
		}
		
		public function emote(Emot:String, Time:Number=1, Follow:FlxSprite=null):Emote {
			var emt:Emote = emotes.recycle(Emote) as Emote;
			emt.revive();
			emt.emote(Emot, Time, Follow);
			return emt;
		}
		
		public function addLight(X:Number = 0, Y:Number=0, R:Number=0, G:Number=0, B:Number=0, Rad:Number=64):Light {
			lights.add(new Light(X, Y, R, G, B, Rad))
			return lights.members[lights.members.length - 1];
		}
	}
}

