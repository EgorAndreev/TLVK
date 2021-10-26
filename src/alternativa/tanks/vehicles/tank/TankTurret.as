package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Vector3;
   
   public class TankTurret extends TankPart
   {
       
      
      public var muzzlePoints:Vector.<Vector3>;
      
      public var flagMountPoint:Vector3;
      
      public function TankTurret()
      {
         this.muzzlePoints = new Vector.<Vector3>();
         this.flagMountPoint = new Vector3();
         super();
      }
   }
}
