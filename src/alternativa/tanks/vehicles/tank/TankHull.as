package alternativa.tanks.vehicles.tank
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.physics.TankPhysicsData;
   
   public class TankHull extends TankPart
   {
       
      
      public var turretSkinMountPoint:Vector3;
      
      public var physicsProfiles:Vector.<TankPhysicsData>;
      
      public var shadowPlane:Mesh;
      
      public function TankHull()
      {
         this.turretSkinMountPoint = new Vector3();
         this.physicsProfiles = new Vector.<TankPhysicsData>();
         super();
      }
   }
}
