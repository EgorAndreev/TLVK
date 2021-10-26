package alternativa.tanks.vehicles.tank.weapons.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.sfx.GraphicEffect;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.UVFrame;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   use namespace alternativa3d;
   
   public class AnimatedSprite extends PooledObject implements GraphicEffect
   {
      
      private static const position:Vector3 = new Vector3();
       
      
      private var sprite:Sprite3D;
      
      private var animation:TextureAnimation;
      
      private var frameIndex:Number;
      
      private var positionProvider:PositionProvider;
      
      private var alive:Boolean;
      
      public function AnimatedSprite(pool:Pool)
      {
         super(pool);
         this.sprite = new Sprite3D(1,1);
      }
      
      public function init(width:Number, height:Number, animation:TextureAnimation, positionProvider:PositionProvider, colorTransform:ColorTransform = null) : void
      {
         this.sprite.width = width;
         this.sprite.height = height;
         this.sprite.material = animation.material;
         this.sprite.colorTransform = colorTransform;
         this.animation = animation;
         this.positionProvider = positionProvider;
         this.frameIndex = 0;
         this.alive = true;
      }
      
      public function setFrameIndex(frameIndex:int) : void
      {
         this.setFrame(this.animation.frames[frameIndex % this.animation.frames.length]);
      }
      
      private function setFrame(uvFrame:UVFrame) : void
      {
         this.sprite.topLeftU = uvFrame.topLeftU;
         this.sprite.topLeftV = uvFrame.topLeftV;
         this.sprite.bottomRightU = uvFrame.bottomRightU;
         this.sprite.bottomRightV = uvFrame.bottomRightV;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.sprite);
      }
      
      public function play(timeDeltaMs:int, camera:GameCamera) : Boolean
      {
         if(this.alive)
         {
            this.positionProvider.readPosition(position);
            this.sprite.x = position.x;
            this.sprite.y = position.y;
            this.sprite.z = position.z;
            this.frameIndex += timeDeltaMs / 1000 * this.animation.fps;
            this.setFrameIndex(this.frameIndex);
         }
         return this.alive;
      }
      
      public function destroy() : void
      {
         this.sprite.removeFromParent();
         this.sprite.colorTransform = null;
         this.animation = null;
         this.positionProvider = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.alive = false;
      }
   }
}
