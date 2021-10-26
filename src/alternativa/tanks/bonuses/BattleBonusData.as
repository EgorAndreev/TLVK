package alternativa.tanks.bonuses
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   
   public class BattleBonusData
   {
       
      
      public var boxMesh:Mesh;
      
      public var parachuteOuterMesh:Mesh;
      
      public var parachuteInnerMesh:Mesh;
      
      public var cordsMaterial:TextureMaterial;
      
      public var lifeTimeMs:int;
      
      public function BattleBonusData()
      {
         super();
      }
   }
}
