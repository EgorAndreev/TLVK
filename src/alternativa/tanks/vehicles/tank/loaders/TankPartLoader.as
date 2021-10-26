package alternativa.tanks.vehicles.tank.loaders
{
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.TankPart;
   import alternativa.tanks.vehicles.tank.physics.BoxData;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   [Event(name="complete",type="flash.events.Event")]
   public class TankPartLoader extends EventDispatcher
   {
       
      
      protected var data:TankPart;
      
      private var modelUrl:String;
      
      private var lightmapUrl:String;
      
      private var detailmapUrl:String;
      
      private var modelLoader:URLLoader;
      
      private var imageLoader:Loader;
      
      public function TankPartLoader(modelUrl:String, lightmapUrl:String, detailsUrl:String)
      {
         super();
         if(modelUrl == null)
         {
            throw new ArgumentError("Parameter modelUrl cannot be null");
         }
         if(lightmapUrl == null)
         {
            throw new ArgumentError("Parameter lightmapUrl cannot be null");
         }
         if(detailsUrl == null)
         {
            throw new ArgumentError("Parameter detailsUrl cannot be null");
         }
         this.modelUrl = modelUrl;
         this.lightmapUrl = lightmapUrl;
         this.detailmapUrl = detailsUrl;
      }
      
      public static function prepareMesh(mesh:Mesh) : void
      {
         mesh.clipping = Clipping.FACE_CLIPPING;
         mesh.sorting = Sorting.DYNAMIC_BSP;
         mesh.calculateFacesNormals();
         mesh.optimizeForDynamicBSP();
      }
      
      public static function parseCollisionBoxData(mesh:Mesh) : BoxData
      {
         mesh.calculateBounds();
         var hs:Vector3 = new Vector3(0.5 * (mesh.boundMaxX - mesh.boundMinX),0.5 * (mesh.boundMaxY - mesh.boundMinY),0.5 * (mesh.boundMaxZ - mesh.boundMinZ));
         var midPoint:Vector3D = new Vector3D(0.5 * (mesh.boundMinX + mesh.boundMaxX),0.5 * (mesh.boundMinY + mesh.boundMaxY),0.5 * (mesh.boundMinZ + mesh.boundMaxZ));
         midPoint = mesh.matrix.transformVector(midPoint);
         var rawData:Vector.<Number> = mesh.matrix.rawData;
         var matrix:Matrix4 = new Matrix4();
         matrix.a = rawData[0];
         matrix.b = rawData[4];
         matrix.c = rawData[8];
         matrix.d = midPoint.x;
         matrix.e = rawData[1];
         matrix.f = rawData[5];
         matrix.g = rawData[9];
         matrix.h = midPoint.y;
         matrix.i = rawData[2];
         matrix.j = rawData[6];
         matrix.k = rawData[10];
         matrix.l = midPoint.z;
         return new BoxData(hs,matrix);
      }
      
      public function load() : void
      {
         this.modelLoader = new URLLoader();
         this.modelLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.modelLoader.addEventListener(Event.COMPLETE,this.onModelLoadingComplete);
         this.modelLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.modelLoader.load(new URLRequest(this.modelUrl));
      }
      
      private function onIOError(event:IOErrorEvent) : void
      {
         trace(event.text);
      }
      
      protected function parseModelData(binaryData:ByteArray) : void
      {
      }
      
      private function onModelLoadingComplete(e:Event) : void
      {
         this.modelLoader.removeEventListener(Event.COMPLETE,this.onModelLoadingComplete);
         this.parseModelData(this.modelLoader.data);
         this.modelLoader = null;
         this.loadImage(this.lightmapUrl,this.onLightmapLoadingComplete);
      }
      
      private function loadImage(imageUrl:String, callback:Function) : void
      {
         if(this.imageLoader == null)
         {
            this.imageLoader = new Loader();
         }
         this.imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,callback);
         this.imageLoader.load(new URLRequest(imageUrl));
      }
      
      private function onLightmapLoadingComplete(e:Event) : void
      {
         this.data.lightmap = (this.imageLoader.content as Bitmap).bitmapData;
         this.imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLightmapLoadingComplete);
         this.loadImage(this.detailmapUrl,this.onDetailsLoadingComplete);
      }
      
      private function onDetailsLoadingComplete(e:Event) : void
      {
         this.data.details = (this.imageLoader.content as Bitmap).bitmapData;
         this.imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onDetailsLoadingComplete);
         this.imageLoader = null;
         this.complete();
      }
      
      protected function complete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
