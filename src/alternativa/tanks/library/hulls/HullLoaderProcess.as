package alternativa.tanks.library.hulls
{
   import alternativa.tanks.library.Listeners;
   import alternativa.tanks.vehicles.tank.TankHull;
   import alternativa.tanks.vehicles.tank.loaders.TankHullLoader;
   import flash.events.Event;
   
   class HullLoaderProcess
   {
       
      
      private var descriptor:HullDescriptor;
      
      private var callback:Function;
      
      private var listeners:Listeners;
      
      private var loader:TankHullLoader;
      
      function HullLoaderProcess(descriptor:HullDescriptor, callback:Function)
      {
         this.listeners = new Listeners();
         super();
         this.descriptor = descriptor;
         this.callback = callback;
         this.start();
      }
      
      function getHullId() : String
      {
         return this.descriptor.id;
      }
      
      function getHull() : TankHull
      {
         return this.loader.getTankHull();
      }
      
      function addListener(listener:Function) : void
      {
         this.listeners.add(listener);
      }
      
      function notifyListeners() : void
      {
         this.listeners.notify(new HullReadyEvent(this.descriptor.id,this.loader.getTankHull()));
      }
      
      private function start() : void
      {
         this.loader = new TankHullLoader(this.descriptor);
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.load();
      }
      
      private function onLoadingComplete(event:Event) : void
      {
         this.callback(this);
      }
   }
}
