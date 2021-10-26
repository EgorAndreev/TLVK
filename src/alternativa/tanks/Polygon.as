package alternativa.tanks
{
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.objects.Mesh;
   
   public class Polygon extends Mesh
   {
       
      
      public function Polygon(vertices:Vector.<Number>, uv:Vector.<Number>, twoSided:Boolean)
      {
         var startIndex:int = 0;
         var i:int = 0;
         super();
         sorting = Sorting.DYNAMIC_BSP;
         clipping = Clipping.FACE_CLIPPING;
         var numVertices:int = vertices.length / 3;
         var numSides:int = !!twoSided ? int(2) : int(1);
         var indices:Vector.<int> = new Vector.<int>(numSides * (numVertices + 1));
         for(var side:int = 0; side < numSides; side++)
         {
            startIndex = side * (numVertices + 1);
            indices[startIndex] = numVertices;
            for(i = 0; i < numVertices; i++)
            {
               indices[i + 1] = i;
            }
         }
         addVerticesAndFaces(vertices,uv,indices,true);
         calculateFacesNormals();
         calculateBounds();
      }
   }
}
