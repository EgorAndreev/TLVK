package alternativa.tanks.bonuses
{
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   public class Assets
   {
      
      private static const parachuteTextureClass:Class = Assets_parachuteTextureClass;
      
      private static const parachuteTexture:BitmapData = new parachuteTextureClass().bitmapData;
      
      private static const parachuteClass3DS:Class = Assets_parachuteClass3DS;
      
      public static const parachuteMesh:Mesh = createMesh(new parachuteClass3DS(),parachuteTexture);
      
      private static const parachuteInnerTextureClass:Class = Assets_parachuteInnerTextureClass;
      
      private static const parachuteInnerTexture:BitmapData = new parachuteInnerTextureClass().bitmapData;
      
      private static const parachuteInnerClass3DS:Class = Assets_parachuteInnerClass3DS;
      
      public static const parachuteInnerMesh:Mesh = createMesh(new parachuteInnerClass3DS(),parachuteInnerTexture);
      
      private static const boxTextureClass:Class = Assets_boxTextureClass;
      
      public static const boxTexture:BitmapData = new boxTextureClass().bitmapData;
      
      private static const boxClass3DS:Class = Assets_boxClass3DS;
      
      public static const box:Mesh = createMesh(new boxClass3DS(),boxTexture);
      
      private static const cordsTextureClass:Class = Assets_cordsTextureClass;
      
      public static const cordsTexture:BitmapData = new cordsTextureClass().bitmapData;
       
      
      public function Assets()
      {
         super();
      }
      
      private static function createMesh(data:ByteArray, texture:BitmapData) : Mesh
      {
         var parser:Parser3DS = new Parser3DS();
         parser.parse(data);
         var mesh:Mesh = Mesh(parser.objects[0]);
         mesh.setMaterialToAllFaces(new TextureMaterial(texture));
         return mesh;
      }
   }
}
