package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.battle.hidablegraphicobjects.HidableGraphicObject;
   import alternativa.types.Long;
   
   public class BonusMesh extends Mesh implements HidableGraphicObject
   {
       
      
      private var objectId:Long;
      
      private var ownAlpha:Number = 1;
      
      private var alphaMultiplier:Number = 1;
      
      public function BonusMesh(objectId:Long, sourceMesh:Mesh)
      {
         super();
         this.objectId = objectId;
         clonePropertiesFrom(sourceMesh);
         var face:Face = sourceMesh.faces[0];
         setMaterialToAllFaces(face.material);
         shadowMapAlphaThreshold = 0.1;
         sorting = Sorting.DYNAMIC_BSP;
         name = "bonus";
      }
      
      public function init() : void
      {
         rotationX = 0;
         rotationY = 0;
         rotationZ = 0;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         this.ownAlpha = 1;
         this.alphaMultiplier = 1;
         this.updateAlpha();
      }
      
      public function getObjectId() : Long
      {
         return this.objectId;
      }
      
      public function getAlpha() : Number
      {
         return this.ownAlpha;
      }
      
      public function setAlpha(value:Number) : void
      {
         this.ownAlpha = value;
         this.updateAlpha();
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = x;
         result.y = y;
         result.z = z;
      }
      
      public function setAlphaMultiplier(value:Number) : void
      {
         this.alphaMultiplier = value;
         this.updateAlpha();
      }
      
      private function updateAlpha() : void
      {
         alpha = this.alphaMultiplier * this.ownAlpha;
      }
      
      public function recycle() : void
      {
         this.ownAlpha = 1;
         this.alphaMultiplier = 1;
         BonusCache.putBonusMesh(this);
      }
   }
}
