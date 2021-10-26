package alternativa.tanks.sfx
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class AnimatedSprite3D extends Sprite3D
   {
       
      
      private var uvFrames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      public function AnimatedSprite3D(width:Number, height:Number, material:Material = null)
      {
         super(width,height,material);
      }
      
      public function setAnimationData(textureAnimation:TextureAnimation) : void
      {
         material = textureAnimation.material;
         this.uvFrames = textureAnimation.frames;
         this.numFrames = this.uvFrames.length;
      }
      
      public function getNumFrames() : int
      {
         return this.numFrames;
      }
      
      public function clear() : void
      {
         this.uvFrames = null;
         material = null;
         this.numFrames = 0;
      }
      
      public function setFrameIndex(frameIndex:int) : void
      {
         this.setFrame(this.uvFrames[frameIndex % this.numFrames]);
      }
      
      private function setFrame(uvFrame:UVFrame) : void
      {
         topLeftU = uvFrame.topLeftU;
         topLeftV = uvFrame.topLeftV;
         bottomRightU = uvFrame.bottomRightU;
         bottomRightV = uvFrame.bottomRightV;
      }
   }
}
