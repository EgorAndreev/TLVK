package alternativa.tanks.vehicles.tank.skin
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   
   use namespace alternativa3d;
   
   public class TrackMaterial extends TextureMaterial
   {
       
      
      public function TrackMaterial(texture:BitmapData = null, repeat:Boolean = false, smooth:Boolean = true, mipMapping:int = 0, resolution:Number = 1)
      {
         super(texture,repeat,smooth,mipMapping,resolution);
      }
      
      override alternativa3d function get transparent() : Boolean
      {
         return true;
      }
      
      override public function clone() : Material
      {
         var res:TrackMaterial = new TrackMaterial(_texture,repeat,smooth,_mipMapping,resolution);
         res.clonePropertiesFrom(this);
         return res;
      }
   }
}
