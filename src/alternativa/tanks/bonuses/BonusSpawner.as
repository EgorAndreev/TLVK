package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.utils.KeyboardListener;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.types.Long;
   import flash.geom.Vector3D;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import alternativa.tanks.Game;
   import alternativa.tanks.Game;
   import alternativa.tanks.config.Config;
   
   public class BonusSpawner
   {
      
      private static const BONUS_LIFE_TIME:int = 3000000;
      
      private static const BONUS_OBJECT_ID:Long = Long.get(1);
	  
      public static var skin:BonusSkin = null;
      
      private var lastBonusId:int;
      
      private var battleService:BattleService;
      
      private var battleBonusData:BattleBonusData;
      
      private var bonusEntries:Dictionary;
      
	  private var bonusAllSkins:Vector.<BonusSkin>;
	  
      public function BonusSpawner(battleService:BattleService, keyboardListener:KeyboardListener)
      {
         this.bonusEntries = new Dictionary();
         super();
         this.battleService = battleService;
         this.createBonusData();
		 var config:Config = Game.getInstance().config;
		// this.skin = new BonusSkin(config.xml.bonus.mesh, config.xml.bonus.texture, config.xml.bonus.cords, config.xml.bonus.parachuteMesh, config.xml.bonus.parachuteMeshInner, config.xml.bonus.parachuteTexture,config.xml.bonus.parachuteTextureInner);
         keyboardListener.addHandler(Keyboard.U,this.spawnBonus);
         keyboardListener.addHandler(Keyboard.I,this.pickupLastBonus);
         keyboardListener.addHandler(Keyboard.O, this.removeLastBonus);
		 keyboardListener.addHandler(Keyboard.NUMPAD_SUBTRACT,this.prevSkin);
         keyboardListener.addHandler(Keyboard.NUMPAD_ADD,this.nextSkin);
      }
      
	  public function prevSkin()
	  {
		  
	  }
	  
	  
	  public function nextSkin()
	  {
		  
	  }
	  
      private function createBonusData() : void
      {
         this.battleBonusData = new BattleBonusData();
         this.battleBonusData.boxMesh = skin.boxMesh;
         this.battleBonusData.parachuteOuterMesh = skin.parachuteMesh;
         this.battleBonusData.parachuteInnerMesh = skin.parachuteInnerMesh;
         this.battleBonusData.cordsMaterial = new TextureMaterial(skin.cordsTexture);
         this.battleBonusData.lifeTimeMs = BONUS_LIFE_TIME;
      }
      
      private function spawnBonus() : void
      {
         var battleBonus:BattleBonus = null;
         var spawnPosition:Vector3 = null;
         var battleScene3D:BattleScene3D = this.battleService.getBattleScene3D();
         var collisionDetector:CollisionDetector = this.battleService.getBattleRunner().getCollisionDetector();
         var objectPool:ObjectPool = this.battleService.getObjectPool();
         var camera:GameCamera = battleScene3D.getCamera();
         var view:View = camera.view;
         var rayOrigin:Vector3D = new Vector3D();
         var rayDirection:Vector3D = new Vector3D();
         camera.calculateRay(rayOrigin,rayDirection,view.mouseX,view.mouseY);
         var origin:Vector3 = new Vector3(rayOrigin.x,rayOrigin.y,rayOrigin.z);
         var direction:Vector3 = new Vector3(rayDirection.x,rayDirection.y,rayDirection.z);
         var rayHit:RayHit = new RayHit();
         if(collisionDetector.raycastStatic(origin,direction,CollisionGroup.STATIC,10000000000,null,rayHit))
         {
            battleBonus = BattleBonus(objectPool.getObject(BattleBonus));
            battleBonus.init(BONUS_OBJECT_ID,this.getNextBonusId(),this.battleBonusData,this.battleService);
            spawnPosition = rayHit.position.clone();
            spawnPosition.z += 5000;
            battleBonus.spawn(spawnPosition,0,150,this.onBonusTankCollision);
            this.bonusEntries[battleBonus.bonusId] = new BonusEntry(this,battleBonus,BONUS_LIFE_TIME);
         }
      }
      
      private function getNextBonusId() : Long
      {
         return Long.get(++this.lastBonusId);
      }
      
      private function onBonusTankCollision(bonus:Bonus) : void
      {
         this.pickupBonus(bonus.bonusId);
      }
      
      public function removeBonus(bonus:Bonus) : void
      {
         this.deleteBonusEntry(bonus.bonusId);
         bonus.remove();
      }
      
      private function deleteBonusEntry(bonusId:Long) : BonusEntry
      {
         var e:BonusEntry = this.bonusEntries[bonusId];
         delete this.bonusEntries[bonusId];
         if(e != null)
         {
            e.stopTimer();
         }
         return e;
      }
      
      private function pickupLastBonus() : void
      {
         this.pickupBonus(Long.get(this.lastBonusId));
      }
      
      private function pickupBonus(bonusId:Long) : void
      {
         var e:BonusEntry = this.deleteBonusEntry(bonusId);
         if(e != null)
         {
            e.bonus.pickup();
         }
      }
      
      private function removeLastBonus() : void
      {
         var bonusId:Long = Long.get(this.lastBonusId);
         var e:BonusEntry = this.deleteBonusEntry(bonusId);
         if(e != null)
         {
            e.bonus.remove();
         }
      }
   }
}

import alternativa.tanks.bonuses.Bonus;
import alternativa.tanks.bonuses.BonusSpawner;
import flash.events.TimerEvent;
import flash.utils.Timer;

class BonusEntry
{
    
   
   public var bonus:Bonus;
   
   private var bonusSpawner:BonusSpawner;
   
   private var timer:Timer;
   
   function BonusEntry(bonusSpawner:BonusSpawner, bonus:Bonus, lifeTime:int)
   {
      super();
      this.bonusSpawner = bonusSpawner;
      this.bonus = bonus;
      this.startTimer(lifeTime);
   }
   
   private function startTimer(lifeTime:int) : void
   {
      this.timer = new Timer(lifeTime,1);
      this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      this.timer.start();
   }
   
   private function onTimerComplete(event:TimerEvent) : void
   {
      this.bonusSpawner.removeBonus(this.bonus);
   }
   
   public function stopTimer() : void
   {
      if(this.timer != null && this.timer.running)
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      }
   }
}
