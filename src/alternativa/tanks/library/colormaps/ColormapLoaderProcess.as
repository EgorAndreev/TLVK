package alternativa.tanks.library.colormaps
{
   import alternativa.tanks.library.Listeners;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   class ColormapLoaderProcess
   {
       
      
      private var descriptor:ColormapDescriptor;
      
      private var callback:Function;
      
      private var listeners:Listeners;
      
      private var loader:Loader;
      
      function ColormapLoaderProcess(descriptor:ColormapDescriptor, callback:Function)
      {
         this.listeners = new Listeners();
         super();
         this.descriptor = descriptor;
         this.callback = callback;
         this.start();
      }
      
      private static function onIOError(event:IOErrorEvent) : void
      {
         trace(event.text);
      }
      
      function getColormapId() : String
      {
         return this.descriptor.id;
      }
      
      function getBitmapData() : BitmapData
      {
         return Bitmap(this.loader.content).bitmapData;
      }
      
      function addListener(listener:Function) : void
      {
         this.listeners.add(listener);
      }
      
      function notifyListeners() : void
      {
         var event:ColormapReadyEvent = new ColormapReadyEvent(this.descriptor.id,Bitmap(this.loader.content).bitmapData);
         this.listeners.notify(event);
      }
      
      private function start() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         this.loader.load(new URLRequest(this.descriptor.url));
      }
      
      private function onLoadingComplete(event:Event) : void
      {
         this.callback(this);
      }
   }
}
