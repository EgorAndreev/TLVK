package alternativa.tanks.vehicles.tank.loaders
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.tanks.vehicles.tank.TankHull;
   import alternativa.tanks.vehicles.tank.physics.TankPhysicsData;
   import flash.geom.Vector3D;
   
   public class TankHullParser
   {
      
      private static const parsingFunctions:Object = {
         "hull":parseSkin,
         "mount":parseMountPoint,
         "shadow":parseShadow
      };
       
      
      public function TankHullParser()
      {
         super();
      }
      
      public static function parse(objects:Vector.<Object3D>) : TankHull
      {
         var hull:TankHull = new TankHull();
         var numObjects:int = objects.length;
         for(var i:int = 0; i < numObjects; i++)
         {
            parseMesh(objects[i] as Mesh,hull);
         }
         hull.physicsProfiles.push(new TankPhysicsData());
         return hull;
      }
      
      private static function parseMesh(mesh:Mesh, hull:TankHull) : void
      {
         var objectName:String = null;
         var key:* = null;
         var parser:Function = null;
         if(mesh != null)
         {
            objectName = mesh.name.toLowerCase();
            for(key in parsingFunctions)
            {
               if(objectName.indexOf(key) == 0)
               {
                  parser = parsingFunctions[key];
                  parser(mesh,hull);
                  break;
               }
            }
         }
      }
      
      private static function parseSkin(mesh:Mesh, tankHull:TankHull) : void
      {
         tankHull.skin = mesh;
         TankPartLoader.prepareMesh(tankHull.skin);
      }
      
      private static function parseMountPoint(mesh:Mesh, tankHull:TankHull) : void
      {
         var pos:Vector3D = mesh.matrix.position;
         tankHull.turretSkinMountPoint.reset(pos.x,pos.y,pos.z);
      }
      
      private static function parseShadow(mesh:Mesh, tankHull:TankHull) : void
      {
      }
   }
}
