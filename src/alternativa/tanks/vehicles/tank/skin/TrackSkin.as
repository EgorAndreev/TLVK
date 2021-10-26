package alternativa.tanks.vehicles.tank.skin
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import flash.utils.Dictionary;
   
   public class TrackSkin
   {
       
      
      private var faces:Vector.<Face>;
      
      private var vertices:Vector.<Vertex>;
      
      private var ratio:Number;
      
      public function TrackSkin()
      {
         this.faces = new Vector.<Face>();
         super();
      }
      
      private static function getRatio(face:Face) : Number
      {
         var vertices:Vector.<Vertex> = face.vertices;
         return getRatioForVertices(vertices[0],vertices[1]);
      }
      
      private static function getRatioForVertices(v1:Vertex, v2:Vertex) : Number
      {
         var dx:Number = v1.x - v2.x;
         var dy:Number = v1.y - v2.y;
         var dz:Number = v1.z - v2.z;
         var realLength:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         var du:Number = v1.u - v2.u;
         var dv:Number = v1.v - v2.v;
         var texLength:Number = Math.sqrt(du * du + dv * dv);
         return texLength / realLength;
      }
      
      public function addFace(face:Face) : void
      {
         this.faces.push(face);
      }
      
      public function init() : void
      {
         var face:Face = null;
         var key:* = undefined;
         var vertex:Vertex = null;
         trace("num faces",this.faces.length);
         var ratio:Number = 0;
         var uniqueVertices:Dictionary = new Dictionary();
         for each(face in this.faces)
         {
            for each(vertex in face.vertices)
            {
               uniqueVertices[vertex] = true;
            }
            ratio += getRatio(face);
         }
         this.ratio = ratio / this.faces.length;
         this.vertices = new Vector.<Vertex>();
         for(key in uniqueVertices)
         {
            this.vertices.push(key);
         }
      }
      
      public function move(delta:Number) : void
      {
         var vertex:Vertex = null;
         for each(vertex in this.vertices)
         {
            vertex.u += delta * this.ratio;
         }
      }
   }
}
