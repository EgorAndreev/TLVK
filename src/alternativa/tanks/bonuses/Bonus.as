package alternativa.tanks.bonuses
{
   import alternativa.math.Vector3;
   import alternativa.types.Long;
   
   public interface Bonus
   {
       
      
      function get bonusId() : Long;
      
      function spawn(param1:Vector3, param2:int, param3:Number, param4:Function) : void;
      
      function pickup() : void;
      
      function remove() : void;
      
      function readBonusPosition(param1:Vector3) : void;
   }
}
