package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class MovingObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
       
      
      private var initialPosition:Vector3;
      
      private var velocity:Vector3;
      
      private var acceleration:Number;
      
      public function MovingObject3DPositionProvider(pool:Pool)
      {
         this.initialPosition = new Vector3();
         this.velocity = new Vector3();
         super(pool);
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = this.initialPosition.x;
         object.y = this.initialPosition.y;
         object.z = this.initialPosition.z;
      }
      
      public function init(initialPosition:Vector3, velocity:Vector3, acceleration:Number) : void
      {
         this.initialPosition.copy(initialPosition);
         this.velocity.copy(velocity);
         this.acceleration = acceleration;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, timeDeltaMs:int) : void
      {
         var dt:Number = 0.001 * timeDeltaMs;
         object.x += this.velocity.x * dt;
         object.y += this.velocity.y * dt;
         object.z += this.velocity.z * dt;
         var speed:Number = this.velocity.length();
         speed += this.acceleration * dt;
         if(speed <= 0)
         {
            this.velocity.reset();
         }
         else
         {
            this.velocity.normalize();
            this.velocity.scale(speed);
         }
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}
