package alternativa.tanks.vehicles.tank.loaders
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import flash.geom.Vector3D;
   
   public class TankTurretParser
   {
      
      private static var parsingFunctions:Object = {
         "turret":parseSkin,
         "fmnt":parseFlagMountPoint,
         "muzzle":parseMuzzle
      };
       
      
      public function TankTurretParser()
      {
         super();
      }
      
      public static function parse(objects:Vector.<Object3D>) : TankTurret
      {
         var mesh:Mesh = null;
         var objectName:String = null;
         var key:* = null;
         var func:Function = null;
         var turret:TankTurret = new TankTurret();
         var len:int = objects.length;
         for(var i:int = 0; i < len; i++)
         {
            mesh = objects[i] as Mesh;
            if(mesh != null)
            {
               objectName = mesh.name.toLowerCase();
               for(key in parsingFunctions)
               {
                  if(objectName.indexOf(key) == 0)
                  {
                     func = parsingFunctions[key];
                     func.call(null,mesh,turret);
                     break;
                  }
               }
            }
         }
         return turret;
      }
      
      private static function parseSkin(mesh:Mesh, tankTurret:TankTurret) : void
      {
         tankTurret.skin = mesh;
         TankPartLoader.prepareMesh(tankTurret.skin);
      }
      
      private static function parseFlagMountPoint(mesh:Mesh, tankTurret:TankTurret) : void
      {
         var pos:Vector3D = mesh.matrix.position;
         tankTurret.flagMountPoint.x = pos.x;
         tankTurret.flagMountPoint.y = pos.y;
         tankTurret.flagMountPoint.z = pos.z;
      }
      
      private static function parseMuzzle(mesh:Mesh, tankTurret:TankTurret) : void
      {
         var pos:Vector3D = mesh.matrix.position;
         tankTurret.muzzlePoints.push(new Vector3(pos.x,pos.y,pos.z));
      }
   }
}
