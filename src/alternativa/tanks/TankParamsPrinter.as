package alternativa.tanks
{
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.systems.SystemPriority;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.taskmanager.GameTask;
   
   public class TankParamsPrinter extends GameTask
   {
      
      private static const MAX_ACCUM_COUNTER:int = 10;
       
      
      private var tankManager:TanksManager;
      
      private var velAccum:Number = 0;
      
      private var rotAccum:Number = 0;
      
      private var accumCounter:int = 0;
      
      public function TankParamsPrinter(tankManager:TanksManager)
      {
         super(SystemPriority.TANK_PARAMS_PRINTER,SystemTags.TANK_PARAMS_PRINTER);
         this.tankManager = tankManager;
      }
      
      override public function onStart() : void
      {
      }
      
      override public function run() : void
      {
         var _loc1_:Vector3 = null;
         var _loc2_:Quaternion = null;
      }
   }
}
