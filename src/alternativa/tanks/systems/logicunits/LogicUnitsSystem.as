package alternativa.tanks.systems.logicunits
{
   import alternativa.tanks.DeferredCommand;
   import alternativa.tanks.LogicUnit;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.timesystem.TimeSystem;
   import alternativa.tanks.taskmanager.GameTask;
   
   public class LogicUnitsSystem extends GameTask implements LogicUnits
   {
       
      
      private const deferredCommands:Vector.<DeferredCommand> = new Vector.<DeferredCommand>();
      
      private const logicUnits:Vector.<LogicUnit> = new Vector.<LogicUnit>();
      
      private var running:Boolean;
      
      private var timeSystem:TimeSystem;
      
      public function LogicUnitsSystem(priority:int, tag:String)
      {
         super(priority,tag);
      }
      
      override public function onStart() : void
      {
         this.timeSystem = TimeSystem(taskManager.getTaskByTag(SystemTags.TIME));
      }
      
      override public function run() : void
      {
         this.runUnits(this.timeSystem.time,this.timeSystem.deltaTimeMs);
      }
      
      public function add(logicUnit:LogicUnit) : void
      {
         if(this.running)
         {
            this.deferredCommands.push(new DeferredLogicUnitAddition(logicUnit,this));
         }
         else if(this.logicUnits.indexOf(logicUnit) < 0)
         {
            this.logicUnits.push(logicUnit);
         }
      }
      
      public function remove(logicUnit:LogicUnit) : void
      {
         var index:int = 0;
         var numUnits:uint = 0;
         if(this.running)
         {
            this.deferredCommands.push(new DeferredLogicUnitDeletion(logicUnit,this));
         }
         else
         {
            index = this.logicUnits.indexOf(logicUnit);
            numUnits = this.logicUnits.length - 1;
            this.logicUnits[index] = this.logicUnits[numUnits];
            this.logicUnits.length = numUnits;
         }
      }
      
      private function runUnits(time:uint, deltaMs:uint) : void
      {
         var logicUnit:LogicUnit = null;
         this.running = true;
         for each(logicUnit in this.logicUnits)
         {
            logicUnit.tick(time,deltaMs);
         }
         this.running = false;
         this.runDeferredCommands();
      }
      
      private function runDeferredCommands() : void
      {
         var command:DeferredCommand = null;
         if(this.deferredCommands.length > 0)
         {
            for each(command in this.deferredCommands)
            {
               command.execute();
            }
            this.deferredCommands.length = 0;
         }
      }
   }
}
