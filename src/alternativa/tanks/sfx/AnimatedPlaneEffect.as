package alternativa.tanks.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.math.Vector3;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   use namespace alternativa3d;
   
   public class AnimatedPlaneEffect extends PooledObject implements GraphicEffect
   {
      
      private static const BASE_SIZE:Number = 100;
       
      
      private var scaleSpeed:Number;
      
      private var scale:Number;
      
      private var baseScale:Number;
      
      private var plane:AnimatedPlane;
      
      private var currentTime:int;
      
      private var maxTime:int;
      
      public function AnimatedPlaneEffect(objectPool:Pool)
      {
         super(objectPool);
         this.plane = new AnimatedPlane(BASE_SIZE);
      }
      
      public function init(size:Number, position:Vector3, rotation:Vector3, fps:Number, animationData:TextureAnimation, scaleSpeed:Number) : void
      {
         this.plane.init(animationData,0.001 * fps);
         this.maxTime = this.plane.getOneLoopTime();
         this.currentTime = 0;
         this.scaleSpeed = 0.001 * scaleSpeed;
         this.baseScale = size / BASE_SIZE;
         this.scale = this.baseScale;
         this.plane.x = position.x;
         this.plane.y = position.y;
         this.plane.z = position.z;
         this.plane.rotationX = rotation.x;
         this.plane.rotationY = rotation.y;
         this.plane.rotationZ = rotation.z;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.plane);
      }
      
      public function play(timeDeltaMs:int, camera:GameCamera) : Boolean
      {
         if(this.currentTime >= this.maxTime)
         {
            return false;
         }
         this.plane.setTime(this.currentTime);
         this.currentTime += timeDeltaMs;
         this.plane.scaleX = this.scale;
         this.plane.scaleY = this.scale;
         this.scale += this.baseScale * this.scaleSpeed * timeDeltaMs;
         return true;
      }
      
      public function destroy() : void
      {
         this.plane.removeFromParent();
         this.plane.clear();
         recycle();
      }
      
      public function kill() : void
      {
         this.currentTime = this.maxTime;
      }
   }
}
