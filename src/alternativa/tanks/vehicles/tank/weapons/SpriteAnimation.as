package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.tanks.sfx.TextureAnimation;
   
   public class SpriteAnimation
   {
       
      
      public var frameSize:Number;
      
      public var textureAnimation:TextureAnimation;
      
      public function SpriteAnimation(frameSize:Number, textureAnimation:TextureAnimation)
      {
         super();
         this.frameSize = frameSize;
         this.textureAnimation = textureAnimation;
      }
   }
}
