package alternativa.tanks
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.primitives.Box;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.collision.primitives.CollisionRect;
   import alternativa.physics.collision.primitives.CollisionTriangle;
   import flash.utils.Dictionary;
   
   public class PhysicsVisualisationBuilder
   {
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const handlers:Dictionary = new Dictionary();
      
      {
         handlers[CollisionBox] = createBox;
         handlers[CollisionRect] = createRect;
         handlers[CollisionTriangle] = createTriangle;
      }
      
      public function PhysicsVisualisationBuilder()
      {
         super();
      }
      
      public static function build(collisionPrimitives:Vector.<CollisionPrimitive>) : Dictionary
      {
         var collisionPrimitive:CollisionPrimitive = null;
         var result:Dictionary = new Dictionary();
         for each(collisionPrimitive in collisionPrimitives)
         {
            result[collisionPrimitive] = handlers[Object(collisionPrimitive).constructor](collisionPrimitive);
            Object3D(result[collisionPrimitive]).visible = false;
         }
         return result;
      }
      
      private static function createBox(collisionBox:CollisionBox) : Object3D
      {
         var face:Face = null;
         var hs:Vector3 = collisionBox.hs;
         var box:Box = new Box(2 * hs.x,2 * hs.y,2 * hs.z);
         setObjectTransform(collisionBox,box);
         for each(face in box.faces)
         {
            face.material = getMaterial();
         }
         return box;
      }
      
      private static function createRect(collisionRect:CollisionRect) : Object3D
      {
         var hs:Vector3 = collisionRect.hs;
         var plane:Plane = new Plane(2 * hs.x,2 * hs.y,1,1,false);
         setObjectTransform(collisionRect,plane);
         plane.setMaterialToAllFaces(getMaterial());
         return plane;
      }
      
      private static function getMaterial() : Material
      {
         var fillMaterial:FillMaterial = new FillMaterial(Math.random() * 16777215,0.5);
         fillMaterial.name = "decal";
         return fillMaterial;
      }
      
      private static function createTriangle(ct:CollisionTriangle) : Object3D
      {
         var mesh:Mesh = new Mesh();
         var vertices:Vector.<Number> = Vector.<Number>([ct.v0.x,ct.v0.y,ct.v0.z,ct.v1.x,ct.v1.y,ct.v1.z,ct.v2.x,ct.v2.y,ct.v2.z]);
         var uvs:Vector.<Number> = Vector.<Number>([0,0,0,1,1,0]);
         var indices:Vector.<int> = Vector.<int>([0,1,2]);
         mesh.addVerticesAndFaces(vertices,uvs,indices,false,getMaterial());
         mesh.calculateFacesNormals();
         mesh.calculateBounds();
         setObjectTransform(ct,mesh);
         return mesh;
      }
      
      private static function setObjectTransform(collisionPrimitive:CollisionPrimitive, object:Object3D) : void
      {
         var m:Matrix4 = collisionPrimitive.transform;
         m.getEulerAngles(eulerAngles);
         object.rotationX = eulerAngles.x;
         object.rotationY = eulerAngles.y;
         object.rotationZ = eulerAngles.z;
         object.x = m.d;
         object.y = m.h;
         object.z = m.l;
      }
   }
}
