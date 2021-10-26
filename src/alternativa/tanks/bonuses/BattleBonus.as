package alternativa.tanks.bonuses
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.types.Long;
   import org1.osflash.signals.ISignal;
   import org1.osflash.signals.Signal;
   
   use namespace alternativa3d;
   
   public class BattleBonus extends PooledObject implements PhysicsController, PhysicsInterpolator, Renderer, Bonus
   {
      
      private static const BIG_VALUE:Number = 10000000000;
      
      private static const N:Vector3 = new Vector3();
      
      private static const P:Vector3 = new Vector3();
      
      private static const P1:Vector3 = new Vector3();
      
      private static const X:Vector3 = new Vector3();
      
      private static const Y:Vector3 = new Vector3();
      
      private static const Y1:Vector3 = new Vector3();
      
      private static const origin:Vector3 = new Vector3();
      
      private static const _rayHit:RayHit = new RayHit();
       
      
      private var bonusMesh:BonusMesh;
      
      private var parachute:Parachute;
      
      private var cords:Cords;
      
      private var battleService:BattleService;
      
      private var fallSpeed:Number = 0;
      
      private var bonusObjectId:Long;
      
      private var data:BattleBonusData;
      
      private var _bonusId:Long;
      
      private var controllersActive:Boolean;
      
      private var trigger:BonusTrigger;
      
      private var controllers:Vector.<BonusController>;
      
      private var currentController:BonusController;
      
      private var fallController:FallController;
      
      private var landingController:LandingController;
      
      public const onPickup:ISignal = new Signal();
      
      public const onRemove:ISignal = new Signal();
      
      public const onDestroy:ISignal = new Signal();
      
      private const onTankCollision:ISignal = new Signal();
      
      public function BattleBonus(pool:Pool)
      {
         this.controllers = new Vector.<BonusController>();
         super(pool);
         this.trigger = new BonusTrigger(this);
         this.fallController = new FallController(this);
         this.landingController = new LandingController(this);
      }
      
      private static function isFlatSurface(groundNormal:Vector3) : Boolean
      {
         return groundNormal.z > BonusConst.COS_ONE_DEGREE;
      }
      
      public function init(bonusObjectId:Long, bonusId:Long, data:BattleBonusData, battleService:BattleService) : void
      {
         this.bonusObjectId = bonusObjectId;
         this._bonusId = bonusId;
         this.data = data;
         this.battleService = battleService;
         this.controllers.length = 0;
      }
      
      public function spawn(spawnPosition:Vector3, timeSinceSpawnMs:int, fallSpeed:Number, tankCollisionCallback:Function) : void
      {
         this.fallSpeed = fallSpeed;
         this.onTankCollision.add(tankCollisionCallback);
         this.initBonusMesh();
         this.initRemovalAnimation(this.data.lifeTimeMs - timeSinceSpawnMs);
         this.controllersActive = false;
         this.controllers.length = 0;
         this.getGroundPointAndNormal(spawnPosition,P,N);
         if(this.isUnderCeil(spawnPosition))
         {
            this.initOnGround(P,N);
         }
         else
         {
            this.initAirborne(spawnPosition,P,N,timeSinceSpawnMs);
            this.trigger.activate(this.battleService.getBattleRunner());
         }
         if(this.runNextController())
         {
            this.activateRendererAndPhysicsController();
         }
      }
      
      private function initOnGround(groundPoint:Vector3, groundNormal:Vector3) : void
      {
         var axis:Vector3 = null;
         var angle:Number = NaN;
         var m:Matrix3 = null;
         var m1:Matrix3 = null;
         var eulerAngles:Vector3 = new Vector3();
         var offsetVector:Vector3 = new Vector3(0,0,BonusConst.BONUS_HALF_SIZE);
         if(isFlatSurface(groundNormal))
         {
            eulerAngles.z = this.getStartingAngleZ();
         }
         else
         {
            axis = new Vector3();
            axis.cross2(Vector3.Z_AXIS,groundNormal);
            axis.normalize();
            angle = Math.acos(groundNormal.z);
            m = new Matrix3();
            m.fromAxisAngle(axis,angle);
            m1 = new Matrix3();
            m1.setRotationMatrix(0,0,this.getStartingAngleZ());
            m1.append(m);
            m1.getEulerAngles(eulerAngles);
            offsetVector.transform3(m);
         }
         this.bonusMesh.rotationX = eulerAngles.x;
         this.bonusMesh.rotationY = eulerAngles.y;
         this.bonusMesh.rotationZ = eulerAngles.z;
         this.bonusMesh.x = groundPoint.x + offsetVector.x;
         this.bonusMesh.y = groundPoint.y + offsetVector.y;
         this.bonusMesh.z = groundPoint.z + offsetVector.z;
         this.updateTriggerFromMesh();
         this.battleService.getBattleScene3D().addObject(this.bonusMesh);
         this.startGroundSpawnAnimation();
      }
      
      private function startGroundSpawnAnimation() : void
      {
         var renderer:GroundSpawnRenderer = GroundSpawnRenderer(this.battleService.getObjectPool().getObject(GroundSpawnRenderer));
         renderer.start(this,this.battleService);
      }
      
      private function updateTriggerFromMesh() : void
      {
         this.trigger.update(this.bonusMesh.x,this.bonusMesh.y,this.bonusMesh.z,this.bonusMesh.rotationX,this.bonusMesh.rotationY,this.bonusMesh.rotationZ);
      }
      
      private function getStartingAngleZ() : Number
      {
         return Math.PI * 10 * this._bonusId.low / 180;
      }
      
      private function initAirborne(spawnPosition:Vector3, groundPoint:Vector3, groundNormal:Vector3, timeSinceSpawnMs:int) : void
      {
         var fallTime:Number = NaN;
         if(isFlatSurface(groundNormal))
         {
            fallTime = this.calculateFallTime(spawnPosition,groundPoint);
            P1.copy(groundPoint);
         }
         else
         {
            X.cross2(groundNormal,Vector3.Z_AXIS);
            X.normalize();
            Y.cross2(groundNormal,X);
            Y1.cross2(Vector3.Z_AXIS,X);
            origin.copy(spawnPosition);
            origin.addScaled(-BonusConst.BONUS_HALF_SIZE,Y1);
            P1.copy(groundPoint);
            P1.addScaled(-BonusConst.BONUS_HALF_SIZE / groundNormal.z,Y);
            if(this.battleService.getBattleRunner().getCollisionDetector().raycastStatic(origin,Vector3.DOWN,CollisionGroup.STATIC,BIG_VALUE,null,_rayHit))
            {
               if(groundPoint.z < _rayHit.position.z && _rayHit.position.z < P1.z)
               {
                  P1.addScaled(BonusConst.BONUS_HALF_SIZE / groundNormal.z * (P1.z - _rayHit.position.z) / (P1.z - groundPoint.z),Y);
               }
            }
            fallTime = this.calculateFallTime(spawnPosition,P1);
            this.landingController.init(P1,groundNormal);
            this.controllers.push(this.landingController);
         }
         var minPivotZ:Number = P1.z + BonusConst.BONUS_HALF_SIZE + BonusConst.BONUS_OFFSET_Z;
         var startingAngleZ:Number = this.getStartingAngleZ();
         if(fallTime * 1000 <= timeSinceSpawnMs)
         {
            this.bonusMesh.x = spawnPosition.x;
            this.bonusMesh.y = spawnPosition.y;
            this.bonusMesh.z = groundPoint.z + BonusConst.BONUS_HALF_SIZE;
            this.bonusMesh.rotationZ = startingAngleZ + fallTime * BonusConst.ANGULAR_SPEED_Z;
            this.updateTriggerFromMesh();
            this.battleService.getBattleScene3D().addObject(this.bonusMesh);
         }
         else
         {
            this.initParachute();
            this.addAllToScene();
            this.startSpawnAnimation(this.battleService);
            this.fallController.init(spawnPosition,this.fallSpeed,minPivotZ,-fallTime,timeSinceSpawnMs / 1000,startingAngleZ);
            this.controllers.push(this.fallController);
         }
      }
      
      private function isUnderCeil(spawnPosition:Vector3) : Boolean
      {
         var collisionDetector:CollisionDetector = this.battleService.getBattleRunner().getCollisionDetector();
         return collisionDetector.hasStaticHit(spawnPosition,Vector3.Z_AXIS,CollisionGroup.STATIC,BIG_VALUE);
      }
      
      private function getGroundPointAndNormal(spawnPosition:Vector3, point:Vector3, normal:Vector3) : void
      {
         var collisionDetector:CollisionDetector = this.battleService.getBattleRunner().getCollisionDetector();
         if(collisionDetector.raycastStatic(spawnPosition,Vector3.DOWN,CollisionGroup.STATIC,BIG_VALUE,null,_rayHit))
         {
            normal.copy(_rayHit.normal);
            point.copy(_rayHit.position);
         }
         else
         {
            normal.copy(Vector3.Z_AXIS);
            point.copy(spawnPosition);
            point.z -= 1000;
         }
      }
      
      public function get bonusId() : Long
      {
         return this._bonusId;
      }
      
      public function pickup() : void
      {
         this.onPickup.dispatch();
         this.detachParachute();
         this.startPickupAnimation();
         this.destroy();
      }
      
      private function startPickupAnimation() : void
      {
         var bonusPickupAnimation:BonusPickupAnimation = BonusPickupAnimation(this.battleService.getObjectPool().getObject(BonusPickupAnimation));
         bonusPickupAnimation.start(this.bonusMesh,this.battleService.getBattleScene3D());
         this.bonusMesh = null;
      }
      
      public function remove() : void
      {
         this.onRemove.dispatch();
         this.bonusMesh = null;
         this.destroy();
      }
      
      private function destroy() : void
      {
         this.onDestroy.dispatch();
         this.onPickup.removeAll();
         this.onRemove.removeAll();
         this.onDestroy.removeAll();
         this.destroyBonusMesh();
         this.destroyParachute();
         this.deactivateRendererAndPhysicsController();
         this.trigger.deactivate();
         this.onTankCollision.removeAll();
         this.battleService = null;
         this.data = null;
         recycle();
      }
      
      private function destroyBonusMesh() : void
      {
         if(this.bonusMesh != null)
         {
            this.battleService.getBattleScene3D().removeObject(this.bonusMesh);
            this.bonusMesh.recycle();
            this.bonusMesh = null;
         }
      }
      
      private function destroyParachute() : void
      {
         if(this.parachute != null)
         {
            this.battleService.getBattleScene3D().removeObject(this.parachute);
            this.parachute.recycle();
            this.parachute = null;
            this.battleService.getBattleScene3D().removeObject(this.cords);
            this.cords.recycle();
            this.cords = null;
         }
      }
      
      public function readBonusPosition(result:Vector3) : void
      {
         result.reset(this.bonusMesh.x,this.bonusMesh.y,this.bonusMesh.z);
      }
      
      private function calculateFallTime(spawnPosition:Vector3, groundTouchPoint:Vector3) : Number
      {
         return (spawnPosition.z - groundTouchPoint.z - BonusConst.BONUS_HALF_SIZE) / this.fallSpeed;
      }
      
      private function initRemovalAnimation(timeLeft:int) : void
      {
         var removalAnimation:RemovalAnimation = RemovalAnimation(this.battleService.getObjectPool().getObject(RemovalAnimation));
         removalAnimation.init(this.battleService.getBattleScene3D(),this,timeLeft);
      }
      
      private function startSpawnAnimation(battleService:BattleService) : void
      {
         var animation:SpawnAnimation = SpawnAnimation(battleService.getObjectPool().getObject(SpawnAnimation));
         animation.start(this,battleService.getBattleScene3D());
      }
      
      private function activateRendererAndPhysicsController() : void
      {
         if(!this.controllersActive)
         {
            this.controllersActive = true;
            this.battleService.getBattleRunner().addPhysicsController(this);
            this.battleService.getBattleRunner().addPhysicsInterpolator(this);
            this.battleService.getBattleScene3D().addRenderer(this,0);
         }
      }
      
      private function initParachute() : void
      {
         if(BonusCache.isParachuteCacheEmpty())
         {
            this.parachute = new Parachute(this.data.parachuteOuterMesh,this.data.parachuteInnerMesh);
         }
         else
         {
            this.parachute = BonusCache.getParachute();
         }
         if(BonusCache.isCordsCacheEmpty())
         {
            this.cords = new Cords(Parachute.RADIUS,BonusConst.BONUS_HALF_SIZE,Parachute.NUM_STRAPS,this.data.cordsMaterial);
         }
         else
         {
            this.cords = BonusCache.getCords();
         }
         this.cords.init(this.bonusMesh,this.parachute);
      }
      
      private function initBonusMesh() : void
      {
         if(BonusCache.isBonusMeshCacheEmpty(this.bonusObjectId))
         {
            this.bonusMesh = new BonusMesh(this.bonusObjectId,this.data.boxMesh);
         }
         else
         {
            this.bonusMesh = BonusCache.getBonusMesh(this.bonusObjectId);
         }
         this.bonusMesh.init();
      }
      
      private function addAllToScene() : void
      {
         this.battleService.getBattleScene3D().addObject(this.parachute);
         this.battleService.getBattleScene3D().addObject(this.bonusMesh);
         this.battleService.getBattleScene3D().addObject(this.cords);
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.currentController.runBeforePhysicsUpdate(dt);
      }
      
      private function deactivateRendererAndPhysicsController() : void
      {
         if(this.controllersActive)
         {
            this.controllersActive = false;
            this.battleService.getBattleRunner().removePhysicsController(this);
            this.battleService.getBattleRunner().removePhysicsInterpolator(this);
            this.battleService.getBattleScene3D().removeRenderer(this,0);
         }
      }
      
      private function detachParachute() : void
      {
         var animation:ParachuteDetachAnimation = null;
         if(this.parachute != null)
         {
            animation = ParachuteDetachAnimation(this.battleService.getObjectPool().getObject(ParachuteDetachAnimation));
            animation.start(this.battleService.getBattleScene3D(),this.parachute,this.cords,this.fallSpeed / 2);
            this.parachute = null;
            this.cords = null;
         }
      }
      
      public function interpolatePhysicsState(interpolationCoeff:Number) : void
      {
         this.currentController.interpolatePhysicsState(interpolationCoeff);
      }
      
      public function render(time:int, deltaMillis:int) : void
      {
         this.currentController.render();
      }
      
      public function setAlpha(alpha:Number) : void
      {
         this.bonusMesh.setAlpha(alpha);
         if(this.parachute != null)
         {
            this.parachute.setAlpha(alpha);
            this.cords.setAlpha(alpha);
         }
      }
      
      public function onTriggerActivated() : void
      {
         this.trigger.deactivate();
         this.onTankCollision.dispatch(this);
      }
      
      public function onTouchGround() : void
      {
         this.detachParachute();
         if(!this.runNextController())
         {
            this.stopMovement();
         }
      }
      
      public function onLandingComplete() : void
      {
         this.stopMovement();
      }
      
      private function stopMovement() : void
      {
         this.deactivateRendererAndPhysicsController();
      }
      
      public function getBonusMesh() : BonusMesh
      {
         return this.bonusMesh;
      }
      
      private function runNextController() : Boolean
      {
         this.currentController = this.controllers.pop();
         if(this.currentController == null)
         {
            return false;
         }
         this.currentController.start();
         return true;
      }
      
      public function getParachute() : Object3D
      {
         return this.parachute;
      }
      
      public function getCords() : Cords
      {
         return this.cords;
      }
      
      public function getTrigger() : BonusTrigger
      {
         return this.trigger;
      }
      
      public function activateTrigger() : void
      {
         this.trigger.activate(this.battleService.getBattleRunner());
      }
   }
}
