package alternativa.tanks.library.hulls
{
   import alternativa.tanks.vehicles.tank.TankHull;
   
   public class HullReadyEvent
   {
       
      
      private var _hullId:String;
      
      private var _hull:TankHull;
      
      public function HullReadyEvent(hullId:String, hull:TankHull)
      {
         super();
         this._hullId = hullId;
         this._hull = hull;
      }
      
      public function get hullId() : String
      {
         return this._hullId;
      }
      
      public function get hull() : TankHull
      {
         return this._hull;
      }
   }
}
