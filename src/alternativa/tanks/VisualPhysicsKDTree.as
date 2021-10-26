package alternativa.tanks
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.collision.CollisionKdNode;
   import alternativa.physics.collision.CollisionKdTree;
   import alternativa.physics.collision.types.AABB;
   import flash.geom.Vector3D;
   
   public class VisualPhysicsKDTree extends Object3DContainer
   {
       
      
      public function VisualPhysicsKDTree(tree:CollisionKdTree)
      {
         super();
         this.createVisualiser(tree.rootNode,tree.rootNode.getDepth());
      }
      
      private function createVisualiser(node:CollisionKdNode, totalDepth:int) : void
      {
         if(node.axis == -1)
         {
            return;
         }
         var alpha:Number = (1 + node.getDepth()) / (1 + totalDepth);
         addChild(this.createMesh(node,Math.max(alpha,0.3)));
         this.createVisualiser(node.negativeNode,totalDepth);
         this.createVisualiser(node.positiveNode,totalDepth);
      }
      
      private function createMesh(node:CollisionKdNode, alpha:Number) : Mesh
      {
         var bb:AABB = node.boundBox;
         switch(node.axis)
         {
            case 0:
               return new Quad(new Vector3D(node.coord,bb.minY,bb.minZ),new Vector3D(node.coord,bb.maxY,bb.minZ),new Vector3D(node.coord,bb.maxY,bb.maxZ),new Vector3D(node.coord,bb.minY,bb.maxZ),16711680,alpha);
            case 1:
               return new Quad(new Vector3D(bb.minX,node.coord,bb.minZ),new Vector3D(bb.maxX,node.coord,bb.minZ),new Vector3D(bb.maxX,node.coord,bb.maxZ),new Vector3D(bb.minX,node.coord,bb.maxZ),65280,alpha);
            case 2:
               return new Quad(new Vector3D(bb.minX,bb.minY,node.coord),new Vector3D(bb.maxX,bb.minY,node.coord),new Vector3D(bb.maxX,bb.maxY,node.coord),new Vector3D(bb.minX,bb.maxY,node.coord),255,alpha);
            default:
               throw new Error();
         }
      }
   }
}
