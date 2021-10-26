package alternativa.tanks.library.hulls
{
   import alternativa.tanks.library.LibraryIterator;
   import alternativa.tanks.library.MissedDescriptorError;
   import alternativa.tanks.library.PartsLibrary;
   import alternativa.tanks.library.PartsLibraryIdentifiers;
   import alternativa.tanks.vehicles.tank.TankHull;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class HullsLibrary implements PartsLibrary
   {
       
      
      private var descriptors:Dictionary;
      
      private var ids:Vector.<String>;
      
      private var hulls:Object;
      
      private var loader:HullsLoader;
      
      public function HullsLibrary(descriptors:Vector.<HullDescriptor>)
      {
         var descriptor:HullDescriptor = null;
         this.descriptors = new Dictionary();
         this.hulls = {};
         super();
         this.ids = new Vector.<String>();
         for each(descriptor in descriptors)
         {
            this.ids.push(descriptor.id);
            this.descriptors[descriptor.id] = descriptor;
         }
         this.loader = new HullsLoader(this.onHullReady);
      }
      
      public function getHull(id:String, callback:Function) : void
      {
         this.checkAvailability(id);
         if(this.hullIsReady(id))
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
      
      private function hullIsReady(id:String) : Boolean
      {
         return this.hulls[id] != null;
      }
      
      private function callLater(callback:Function, id:String) : void
      {
         setTimeout(function():void
         {
            callback(new HullReadyEvent(id,hulls[id]));
         },0);
      }
      
      private function load(id:String, callback:Function) : void
      {
         this.loader.load(this.descriptors[id],callback);
      }
      
      private function onHullReady(hullId:String, hull:TankHull) : void
      {
         this.hulls[hullId] = hull;
      }
   }
}
