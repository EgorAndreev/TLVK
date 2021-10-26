package alternativa.tanks
{
   import alternativa.math.Vector3;
   
   public class SpawnPoint
   {
       
      
      public var type:String;
      
      public var position:Vector3;
      
      public var direction:Number;
      
      public function SpawnPoint(xml:XML)
      {
         super();
         this.type = xml.@type;
         var pos:XML = xml.position[0];
         this.position = new Vector3(Number(pos.x),Number(pos.y),Number(pos.z));
         this.direction = Number(xml.rotation.z);
      }
   }
}
