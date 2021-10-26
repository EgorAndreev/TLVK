package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SFXUtils
   {
      
      private static const axis1:Vector3 = new Vector3();
      
      private static const axis2:Vector3 = new Vector3();
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const targetAxisZ:Vector3 = new Vector3();
      
      private static const objectAxis:Vector3 = new Vector3();
      
      private static const matrix1:Matrix3 = new Matrix3();
      
      private static const matrix2:Matrix3 = new Matrix3();
       
      
      public function SFXUtils()
      {
         super();
      }
      
      public static function alignObjectPlaneToView(object:Object3D, objectPosition:Vector3, objectDirection:Vector3, cameraPosition:Vector3) : void
      {
         var angle:Number = NaN;
         var dot:Number = NaN;
         if(objectDirection.y < -0.99999 || objectDirection.y > 0.99999)
         {
            axis1.x = 0;
            axis1.y = 0;
            axis1.z = 1;
            angle = objectDirection.y < 0 ? Number(Math.PI) : Number(0);
         }
         else
         {
            axis1.x = objectDirection.z;
            axis1.y = 0;
            axis1.z = -objectDirection.x;
            axis1.normalize();
            angle = Math.acos(objectDirection.y);
         }
         matrix1.fromAxisAngle(axis1,angle);
         targetAxisZ.x = cameraPosition.x - objectPosition.x;
         targetAxisZ.y = cameraPosition.y - objectPosition.y;
         targetAxisZ.z = cameraPosition.z - objectPosition.z;
         dot = targetAxisZ.x * objectDirection.x + targetAxisZ.y * objectDirection.y + targetAxisZ.z * objectDirection.z;
         targetAxisZ.x -= dot * objectDirection.x;
         targetAxisZ.y -= dot * objectDirection.y;
         targetAxisZ.z -= dot * objectDirection.z;
         targetAxisZ.normalize();
         matrix1.transformVector(Vector3.Z_AXIS,objectAxis);
         dot = objectAxis.x * targetAxisZ.x + objectAxis.y * targetAxisZ.y + objectAxis.z * targetAxisZ.z;
         axis2.x = objectAxis.y * targetAxisZ.z - objectAxis.z * targetAxisZ.y;
         axis2.y = objectAxis.z * targetAxisZ.x - objectAxis.x * targetAxisZ.z;
         axis2.z = objectAxis.x * targetAxisZ.y - objectAxis.y * targetAxisZ.x;
         axis2.normalize();
         angle = Math.acos(dot);
         matrix2.fromAxisAngle(axis2,angle);
         matrix1.append(matrix2);
         matrix1.getEulerAngles(eulerAngles);
         object.rotationX = eulerAngles.x;
         object.rotationY = eulerAngles.y;
         object.rotationZ = eulerAngles.z;
         object.x = objectPosition.x;
         object.y = objectPosition.y;
         object.z = objectPosition.z;
      }
      
      public static function parseAnimationStrip(texture:BitmapData, frameWidth:int, mipMapResolution:Number) : Vector.<Material>
      {
         var bitmapData:BitmapData = null;
         var materials:Vector.<Material> = new Vector.<Material>();
         var frameCount:int = texture.width / frameWidth;
         var rect:Rectangle = new Rectangle(0,0,frameWidth,texture.height);
         var pt:Point = new Point();
         for(var i:int = 0; i < frameCount; i++)
         {
            bitmapData = new BitmapData(frameWidth,texture.height,true,0);
            bitmapData.copyPixels(texture,rect,pt);
            materials[i] = new TextureMaterial(bitmapData,false,true,MipMapping.PER_PIXEL,mipMapResolution);
            rect.x += frameWidth;
         }
         return materials;
      }
      
      public static function copyColorTransform(src:ColorTransform, dest:ColorTransform) : void
      {
         dest.redMultiplier = src.redMultiplier;
         dest.greenMultiplier = src.greenMultiplier;
         dest.blueMultiplier = src.blueMultiplier;
         dest.alphaMultiplier = src.alphaMultiplier;
         dest.redOffset = src.redOffset;
         dest.greenOffset = src.greenOffset;
         dest.blueOffset = src.blueOffset;
         dest.alphaOffset = src.alphaOffset;
      }
   }
}
