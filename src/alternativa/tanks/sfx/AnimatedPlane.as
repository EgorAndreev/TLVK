package alternativa.tanks.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace alternativa3d;
   
   public class AnimatedPlane extends Mesh
   {
       
      
      private var a:Vertex;
      
      private var b:Vertex;
      
      private var c:Vertex;
      
      private var d:Vertex;
      
      private var uvFrames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var framesPerTimeUnit:Number = 0;
      
      public function AnimatedPlane(size:Number)
      {
         super();
         this.createFaces(size);
         sorting = Sorting.DYNAMIC_BSP;
         calculateBounds();
         calculateFacesNormals();
         this.writeVertices();
      }
      
      private function createFaces(size:Number) : void
      {
         var halfSize:Number = size / 2;
         var vertexCoordinates:Vector.<Number> = Vector.<Number>([-halfSize,halfSize,0,-halfSize,-halfSize,0,halfSize,-halfSize,0,halfSize,halfSize,0]);
         var uvs:Vector.<Number> = Vector.<Number>([0,0,0,1,1,1,1,0]);
         var indices:Vector.<int> = Vector.<int>([4,0,1,2,3,4,0,3,2,1]);
         addVerticesAndFaces(vertexCoordinates,uvs,indices,true);
      }
      
      private function writeVertices() : void
      {
         var vertices:Vector.<Vertex> = this.vertices;
         this.a = vertices[0];
         this.b = vertices[1];
         this.c = vertices[2];
         this.d = vertices[3];
      }
      
      public function init(textureAnimation:TextureAnimation, framesPerTimeUnit:Number) : void
      {
         setMaterialToAllFaces(textureAnimation.material);
         this.uvFrames = textureAnimation.frames;
         this.numFrames = this.uvFrames.length;
         this.framesPerTimeUnit = framesPerTimeUnit;
      }
      
      public function setTime(time:Number) : void
      {
         var frameIndex:int = time * this.framesPerTimeUnit;
         if(frameIndex >= this.numFrames)
         {
            frameIndex = this.numFrames - 1;
         }
         this.setFrame(this.uvFrames[frameIndex]);
      }
      
      public function clear() : void
      {
         setMaterialToAllFaces(null);
         this.uvFrames = null;
         this.numFrames = 0;
      }
      
      public function getOneLoopTime() : Number
      {
         return this.numFrames / this.framesPerTimeUnit;
      }
      
      private function setFrame(frame:UVFrame) : void
      {
         this.a.u = frame.topLeftU;
         this.a.v = frame.topLeftV;
         this.b.u = frame.topLeftU;
         this.b.v = frame.bottomRightV;
         this.c.u = frame.bottomRightU;
         this.c.v = frame.bottomRightV;
         this.d.u = frame.bottomRightU;
         this.d.v = frame.topLeftV;
      }
   }
}
