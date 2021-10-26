package alternativa.tanks.library.colormaps
{
   import alternativa.tanks.library.LibraryIterator;
   import alternativa.tanks.library.MissedDescriptorError;
   import alternativa.tanks.library.PartsLibrary;
   import alternativa.tanks.library.PartsLibraryIdentifiers;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class ColormapsLibrary implements PartsLibrary
   {
       
      
      private var descriptors:Dictionary;
      
      private var ids:Vector.<String>;
      
      private var readyColormaps:Dictionary;
      
      private var loader:ColormapsLoader;
      
      public function ColormapsLibrary(descriptors:Vector.<ColormapDescriptor>)
      {
         var descriptor:ColormapDescriptor = null;
         this.descriptors = new Dictionary();
         this.readyColormaps = new Dictionary();
         super();
         this.ids = new Vector.<String>();
         for each(descriptor in descriptors)
         {
            this.ids.push(descriptor.id);
            this.descriptors[descriptor.id] = descriptor;
         }
         this.loader = new ColormapsLoader(this.onColormapReady);
      }
      
      public function getColormap(id:String, callback:Function) : void
      {
         this.checkAvailability(id);
         if(this.colormapIsReady(id))
         {
            this.callLater(callback,id);
         }
         else
         {
            this.load(id,callback);
         }
      }
      
      public function getIterator() : LibraryIterator
      {
         return new PartsLibraryIdentifiers(this.ids);
      }
      
      private function checkAvailability(id:String) : void
      {
         if(this.descriptors[id] == null)
         {
            throw new MissedDescriptorError(id);
         }
      }
      
      private function colormapIsReady(id:String) : Boolean
      {
         return this.readyColormaps[id] != null;
      }
      
      private function callLater(callback:Function, id:String) : void
      {
         setTimeout(function():void
         {
            callback(new ColormapReadyEvent(id,readyColormaps[id]));
         },0);
      }
      
      private function load(id:String, callback:Function) : void
      {
         this.loader.load(this.descriptors[id],callback);
      }
      
      private function onColormapReady(id:String, bitmapData:BitmapData) : void
      {
         this.readyColormaps[id] = bitmapData;
      }
   }
}
