package alternativa.tanks.systems.logicunits
{
   import alternativa.tanks.DeferredCommand;
   import alternativa.tanks.LogicUnit;
   
   public class DeferredLogicUnitAddition implements DeferredCommand
   {
       
      
      private var logicUnit:LogicUnit;
      
      private var logicUnits:LogicUnits;
      
      public function DeferredLogicUnitAddition(logicUnit:LogicUnit, logicUnits:LogicUnits)
      {
         super();
         this.logicUnit = logicUnit;
         this.logicUnits = logicUnits;
      }
      
      public function execute() : void
      {
         this.logicUnits.add(this.logicUnit);
      }
   }
}
