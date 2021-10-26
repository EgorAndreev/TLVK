package alternativa.tanks.vehicles.tank.loaders
{
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.tanks.library.hulls.HullDescriptor;
   import alternativa.tanks.vehicles.tank.TankHull;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class TankHullLoader extends TankPartLoader
   {
       
      
      private var descriptor:HullDescriptor;
      
      private var loader:Loader;
      
      public function TankHullLoader(descriptor:HullDescriptor)
      {
         super(descriptor.modelUrl,descriptor.lightmapUrl,descriptor.detailsUrl);
         this.descriptor = descriptor;
      }
      
      public function getTankHull() : TankHull
      {
         return TankHull(data);
      }
      
      override protected function parseModelData(binaryData:ByteArray) : void
      {
         var parser:Parser3DS = new Parser3DS();
         parser.parse(binaryData);
         var tankHull:TankHull = TankHullParser.parse(parser.objects);
         data = tankHull;
      }
      
      override protected function complete() : void
      {
         if(this.descriptor.shadowTextureUrl)
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onShadowLoadingComplete);
            this.loader.load(new URLRequest(this.descriptor.shadowTextureUrl));
         }
         else
         {
            super.complete();
         }
      }
      
      private function onShadowLoadingComplete(event:Event) : void
      {
      }
   }
}
