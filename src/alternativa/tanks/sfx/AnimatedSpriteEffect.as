package alternativa.tanks.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   use namespace alternativa3d;
   
   public class AnimatedSpriteEffect extends PooledObject implements GraphicEffect
   {
       
      
      private var sprite:AnimatedSprite3D;
      
      private var currentFrame:Number;
      
      private var framesPerMs:Number;
      
      private var loop:Boolean;
      
      private var positionProvider:Object3DPositionProvider;
      
      public function AnimatedSpriteEffect(objectPool:Pool)
      {
         super(objectPool);
         this.sprite = new AnimatedSprite3D(1,1);
      }
      
      public function init(width:Number, height:Number, textureAnimation:TextureAnimation, rotation:Number, positionProvider:Object3DPositionProvider, originX:Number = 0.5, originY:Number = 0.5, colorTransform:ColorTransform = null) : void
      {
         this.initSprite(width,height,rotation,originX,originY,colorTransform,textureAnimation);
         positionProvider.initPosition(this.sprite);
         this.framesPerMs = 0.001 * textureAnimation.fps;
         this.positionProvider = positionProvider;
         this.currentFrame = 0;
         this.loop = false;
      }
      
      public function initLooped(width:Number, height:Number, textureAnimation:TextureAnimation, rotation:Number, positionProvider:Object3DPositionProvider, originX:Number = 0.5, originY:Number = 0.5, colorTransform:ColorTransform = null) : void
      {
         this.init(width,height,textureAnimation,rotation,positionProvider,originX,originY,colorTransform);
         this.loop = true;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.sprite);
      }
      
      public function play(timeDeltaMs:int, camera:GameCamera) : Boolean
      {
         if(this.loop || this.currentFrame < this.sprite.getNumFrames())
         {
            this.sprite.setFrameIndex(this.currentFrame);
            this.currentFrame += timeDeltaMs * this.framesPerMs;
            this.positionProvider.updateObjectPosition(this.sprite,camera,timeDeltaMs);
            return true;
         }
         return false;
      }
      
      public function destroy() : void
      {
         this.sprite.removeFromParent();
         this.sprite.clear();
         this.positionProvider.destroy();
         this.positionProvider = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.loop = false;
         this.currentFrame = this.sprite.getNumFrames();
      }
      
      private function initSprite(width:Number, height:Number, rotation:Number, originX:Number, originY:Number, colorTransform:ColorTransform, textureAnimation:TextureAnimation) : void
      {
         this.sprite.width = width;
         this.sprite.height = height;
         this.sprite.rotation = rotation;
         this.sprite.originX = originX;
         this.sprite.originY = originY;
         this.sprite.colorTransform = colorTransform;
         this.sprite.setAnimationData(textureAnimation);
      }
   }
}
