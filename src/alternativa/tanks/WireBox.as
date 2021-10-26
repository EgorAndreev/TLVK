package alternativa.tanks
{
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.primitives.Box;
   import flash.utils.Dictionary;
   
   public class WireBox extends Box
   {
      
      private static const materials:Dictionary = new Dictionary();
       
      
      public function WireBox(width:Number, length:Number, height:Number, color:uint)
      {
         super(width,length,height);
         var material:Material = getMaterial(color);
         setMaterialToAllFaces(material);
      }
      
      private static function getMaterial(color:uint) : Material
      {
         var material:Material = materials[color];
         if(material == null)
         {
            material = new FillMaterial(0,0,0,color);
            materials[color] = material;
         }
         return material;
      }
   }
}
