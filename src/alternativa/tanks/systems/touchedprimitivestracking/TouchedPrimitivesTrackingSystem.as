package alternativa.tanks.systems.touchedprimitivestracking
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.tanks.StaticCollisionPrimitivesVisualiser;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.display.DebugPanel;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.physicssystem.PhysicsSystem;
   import alternativa.tanks.systems.rendersystem.RenderSystem;
   import alternativa.tanks.taskmanager.GameTask;
   
   public class TouchedPrimitivesTrackingSystem extends GameTask
   {
       
      
      private var physicsSystem:PhysicsSystem;
      
      private var staticCollisionVisualiser:StaticCollisionPrimitivesVisualiser;
      
      private var debugPanel:DebugPanel;
      
      private var config:Config;
      
      public function TouchedPrimitivesTrackingSystem(priority:int, tag:String, debugPanel:DebugPanel, config:Config)
      {
         super(priority,tag);
         this.debugPanel = debugPanel;
         this.config = config;
      }
      
      override public function onStart() : void
      {
         var object:Object3D = null;
         this.physicsSystem = PhysicsSystem(taskManager.getTaskByTag(SystemTags.PHYSICS));
         this.physicsSystem.trackTouchedPrimitives(true);
         var renderSystem:RenderSystem = RenderSystem(taskManager.getTaskByTag(SystemTags.RENDER));
         this.staticCollisionVisualiser = new StaticCollisionPrimitivesVisualiser(this.config.map.collisionPrimitives);
         for each(object in this.staticCollisionVisualiser.getVisuals())
         {
            renderSystem.scene3D.getFrontContainer().addChild(object);
         }
      }
      
      override public function onStop() : void
      {
         var object:Object3D = null;
         this.physicsSystem.trackTouchedPrimitives(false);
         var renderSystem:RenderSystem = RenderSystem(taskManager.getTaskByTag(SystemTags.RENDER));
         for each(object in this.staticCollisionVisualiser.getVisuals())
         {
            renderSystem.scene3D.getFrontContainer().removeChild(object);
         }
      }
      
      override public function run() : void
      {
         this.staticCollisionVisualiser.hideAll();
         var touchedPrimitives:Vector.<CollisionPrimitive> = this.physicsSystem.getCollisionDetector().touchedPrimitives.primitives;
         this.staticCollisionVisualiser.showPrimitives(touchedPrimitives);
         this.debugPanel.printValue("Touched primitives",touchedPrimitives.length);
      }
   }
}
