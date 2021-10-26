package alternativa.tanks.config
{
   import alternativa.tanks.sfx.TextureAnimation;
   
   public class TextureAnimations
   {
       
      
      private var animations:Object;
      
      public function TextureAnimations(animations:Object)
      {
         this.animations = {};
         super();
         this.animations = animations;
      }
      
      public function getAnimation(animationId:String) : TextureAnimation
      {
         if(this.animations[animationId] == null)
         {
            throw new Error("Texure animation not found: " + animationId);
         }
         return this.animations[animationId];
      }
   }
}
