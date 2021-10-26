package alternativa.tanks.library.turrets
{
   import alternativa.tanks.vehicles.tank.TankTurret;
   
   public class TurretReadyEvent
   {
       
      
      private var _turretId:String;
      
      private var _turret:TankTurret;
      
      public function TurretReadyEvent(id:String, turret:TankTurret)
      {
         super();
         this._turretId = id;
         this._turret = turret;
      }
      
      public function get turretId() : String
      {
         return this._turretId;
      }
      
      public function get turret() : TankTurret
      {
         return this._turret;
      }
   }
}
