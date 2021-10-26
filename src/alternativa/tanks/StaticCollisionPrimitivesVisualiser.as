package alternativa.tanks
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.physics.collision.CollisionPrimitive;
   import flash.utils.Dictionary;
   
   public class StaticCollisionPrimitivesVisualiser
   {
       
      
      private var visuals:Dictionary;
      
      private const visiblePrimitives:Dictionary = new Dictionary();
      
      public function StaticCollisionPrimitivesVisualiser(collisionPrimitives:Vector.<CollisionPrimitive>)
      {
         super();
         this.visuals = PhysicsVisualisationBuilder.build(collisionPrimitives);
      }
      
      public function showPrimitives(primitives:Vector.<CollisionPrimitive>) : void
      {
         var cp:CollisionPrimitive = null;
         for each(cp in primitives)
         {
            Object3D(this.visuals[cp]).visible = true;
            this.visiblePrimitives[cp] = true;
         }
      }
      
      public function hideAll() : void
      {
         var key:* = undefined;
         for(key in this.visiblePrimitives)
         {
            Object3D(this.visuals[key]).visible = false;
            delete this.visiblePrimitives[key];
         }
      }
      
      public function getVisuals() : Vector.<Object3D>
      {
         var object3D:Object3D = null;
         var result:Vector.<Object3D> = new Vector.<Object3D>();
         for each(object3D in this.visuals)
         {
            result.push(object3D);
         }
         return result;
      }
   }
}
