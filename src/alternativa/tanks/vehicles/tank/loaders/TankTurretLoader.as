package alternativa.tanks.vehicles.tank.loaders
{
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.tanks.library.turrets.TurretDescriptor;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import flash.utils.ByteArray;
   
   public class TankTurretLoader extends TankPartLoader
   {
       
      
      public function TankTurretLoader(descriptor:TurretDescriptor)
      {
         super(descriptor.modelUrl,descriptor.lightmapUrl,descriptor.detailsUrl);
      }
      
      public function getTurret() : TankTurret
      {
         return TankTurret(data);
      }
      
      override protected function parseModelData(binaryData:ByteArray) : void
      {
         var parser:Parser3DS = new Parser3DS();
         parser.parse(binaryData);
         data = TankTurretParser.parse(parser.objects);
      }
   }
}
