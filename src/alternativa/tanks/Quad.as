package alternativa.tanks
{
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.geom.Vector3D;
   
   public class Quad extends Mesh
   {
       
      
      public function Quad(v0:Vector3D, v1:Vector3D, v2:Vector3D, v3:Vector3D, color:uint, alpha:Number)
      {
         super();
         this.alpha = alpha;
         var vertexCoordinates:Vector.<Number> = Vector.<Number>([v0.x,v0.y,v0.z,v1.x,v1.y,v1.z,v2.x,v2.y,v2.z,v3.x,v3.y,v3.z]);
         var uvs:Vector.<Number> = Vector.<Number>([0,0,0,1,1,1,1,0]);
         var indices:Vector.<int> = Vector.<int>([4,0,1,2,3,4,0,3,2,1]);
         addVerticesAndFaces(vertexCoordinates,uvs,indices,true);
         setMaterialToAllFaces(new FillMaterial(color,0,0,color));
         calculateBounds();
         calculateFacesNormals();
         sorting = Sorting.AVERAGE_Z;
         clipping = Clipping.BOUND_CULLING;
      }
   }
}
