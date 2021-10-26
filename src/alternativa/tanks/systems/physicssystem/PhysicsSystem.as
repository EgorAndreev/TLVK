package alternativa.tanks.systems.physicssystem
{
   import alternativa.math.Vector3;
   import alternativa.physics.BodyListItem;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.collision.types.AABB;
   import alternativa.tanks.PhysicsControllers;
   import alternativa.tanks.PhysicsInterpolators;
   import alternativa.tanks.PhysicsPerformanceMonitor;
   import alternativa.tanks.battle.triggers.Triggers;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.config.TanksMap;
   import alternativa.tanks.display.DebugPanel;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.systems.SystemPriority;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.timesystem.TimeSystem;
   import alternativa.tanks.taskmanager.GameTask;
   import flash.utils.getTimer;
   
   public class PhysicsSystem extends GameTask
   {
       
      
      private var timeSystem:TimeSystem;
      
      public var physicsScene:PhysicsScene;
      
      public var physicsStepMsec:Number = 30;
      
      public const triggers:Triggers = new Triggers();
      
      public const physicsControllers:PhysicsControllers = new PhysicsControllers();
      
      public const physicsInterpolators:PhysicsInterpolators = new PhysicsInterpolators();
      
      private var physicsPerformanceMonitor:PhysicsPerformanceMonitor;
      
      public var interpolationCoefficient:Number = 0;
      
      public function PhysicsSystem(param1:Config, param2:DebugPanel)
      {
         super(SystemPriority.PHYSICS,SystemTags.PHYSICS);
         this.physicsScene = new PhysicsScene();
         this.physicsScene.usePrediction = true;
         this.physicsScene.allowedPenetration = 5;
         this.physicsScene.maxPenResolutionSpeed = 100;
         var _loc3_:Number = Number(param1.xml.attribute("gravity").toString());
         this.physicsScene.gravity = new Vector3(0,0,_loc3_);
         var _loc4_:TanksCollisionDetector = new TanksCollisionDetector();
         this.physicsScene.collisionDetector = _loc4_;
         var _loc5_:TanksMap = param1.map;
         var _loc6_:AABB = new AABB();
         var _loc7_:Number = 20000;
         _loc6_.setSize(0 - _loc7_,0 - _loc7_,0 - _loc7_,_loc7_,_loc7_,_loc7_);
         _loc4_.buildKdTree(_loc5_.collisionPrimitives,_loc6_);
         this.physicsScene.time = getTimer();
         this.physicsPerformanceMonitor = new PhysicsPerformanceMonitor(param2);
      }
      
      public function trackTouchedPrimitives(param1:Boolean) : void
      {
         TanksCollisionDetector(this.physicsScene.collisionDetector).touchedPrimitives.trackingEnabled = param1;
      }
      
      override public function onStart() : void
      {
         this.timeSystem = TimeSystem(taskManager.getTaskByTag(SystemTags.TIME));
      }
      
      override public function run() : void
      {
         var _loc1_:uint = 0;
         TanksCollisionDetector(this.physicsScene.collisionDetector).touchedPrimitives.clear();
         while(this.physicsScene.time < this.timeSystem.time)
         {
            this.physicsControllers.run(this.physicsStepMsec / 1000);
            _loc1_ = getTimer();
            this.physicsScene.update(this.physicsStepMsec);
            this.checkTriggers();
            this.physicsPerformanceMonitor.update(_loc1_);
         }
         this.interpolationCoefficient = Number(1 - (this.physicsScene.time - this.timeSystem.time) / this.physicsStepMsec);
         this.physicsInterpolators.run(this.interpolationCoefficient);
      }
      
      public function getCollisionDetector() : TanksCollisionDetector
      {
         return TanksCollisionDetector(this.physicsScene.collisionDetector);
      }
      
      private function checkTriggers() : void
      {
         var _loc1_:BodyListItem = this.physicsScene.bodies.head;
         while(_loc1_ != null)
         {
            this.triggers.check(_loc1_.body);
            _loc1_ = _loc1_.next;
         }
      }
   }
}
