package alternativa.tanks.systems.timesystem
{
   import alternativa.tanks.systems.SystemPriority;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.taskmanager.GameTask;
   import flash.utils.getTimer;
   
   public class TimeSystem extends GameTask
   {
       
      
      public var time:int;
      
      public var deltaTime:Number;
      
      public var deltaTimeMs:int;
      
      public function TimeSystem()
      {
         super(SystemPriority.TIME,SystemTags.TIME);
      }
      
      override public function onStart() : void
      {
         this.time = getTimer();
      }
      
      override public function run() : void
      {
         var t:int = getTimer();
         this.deltaTimeMs = t - this.time;
         this.deltaTime = this.deltaTimeMs / 1000;
         this.time = t;
      }
   }
}
