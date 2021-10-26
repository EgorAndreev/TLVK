package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.Game;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class StaticObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private static const toCamera:Vector3 = new Vector3();
       
      
      private var position:Vector3;
      
      private var offsetToCamera:Number;
      
      public function StaticObject3DPositionProvider(pool:Pool)
      {
         this.position = new Vector3();
         super(pool);
      }
      
      public static function create(position:Vector3, offsetToCamera:Number = 0) : StaticObject3DPositionProvider
      {
         var result:StaticObject3DPositionProvider = StaticObject3DPositionProvider(Game.getInstance().getObjectFromPool(StaticObject3DPositionProvider));
         result.init(position,offsetToCamera);
         return result;
      }
      
      public function init(position:Vector3, offsetToCamera:Number) : void
      {
         this.position.copy(position);
         this.offsetToCamera = offsetToCamera;
      }
      
      public function setPosition(position:Vector3) : void
      {
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = this.position.x;
         object.y = this.position.y;
         object.z = this.position.z;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, timeDeltaMs:int) : void
      {
         toCamera.x = camera.x - this.position.x;
         toCamera.y = camera.y - this.position.y;
         toCamera.z = camera.z - this.position.z;
         toCamera.normalize();
         object.x = this.position.x + this.offsetToCamera * toCamera.x;
         object.y = this.position.y + this.offsetToCamera * toCamera.y;
         object.z = this.position.z + this.offsetToCamera * toCamera.z;
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}
