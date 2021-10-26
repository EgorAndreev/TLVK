package alternativa.tanks
{
   import alternativa.tanks.display.DebugPanel;
   import flash.utils.getTimer;
   
   public class PhysicsPerformanceMonitor
   {
       
      
      private const PHYSICS_FRAME_SAMPLES:int = 30;
      
      private var physicsFrameCounter:int;
      
      private var physicsFrameAccumulatedTime:Number = 0;
      
      private var debugPanel:DebugPanel;
      
      public function PhysicsPerformanceMonitor(debugPanel:DebugPanel)
      {
         super();
         this.debugPanel = debugPanel;
      }
      
      public function update(startTime:int) : void
      {
         var pt:Number = NaN;
         this.physicsFrameAccumulatedTime += getTimer() - startTime;
         ++this.physicsFrameCounter;
         if(this.physicsFrameCounter >= this.PHYSICS_FRAME_SAMPLES)
         {
            pt = this.physicsFrameAccumulatedTime / this.physicsFrameCounter;
            this.physicsFrameCounter = 0;
            this.physicsFrameAccumulatedTime = 0;
         }
      }
   }
}
