package alternativa.tanks.library.turrets
{
   import alternativa.tanks.library.Listeners;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import alternativa.tanks.vehicles.tank.loaders.TankTurretLoader;
   import flash.events.Event;
   
   public class TurretLoadingProcess
   {
       
      
      private var descriptor:TurretDescriptor;
      
      private var callback:Function;
      
      private var listeners:Listeners;
      
      private var loader:TankTurretLoader;
      
      public function TurretLoadingProcess(descriptor:TurretDescriptor, callback:Function)
      {
         this.listeners = new Listeners();
         super();
         this.descriptor = descriptor;
         this.callback = callback;
         this.start();
      }
      
      public function addListener(listener:Function) : void
      {
         this.listeners.add(listener);
      }
      
      public function getTurretId() : String
      {
         return this.descriptor.id;
      }
      
      public function getTurret() : TankTurret
      {
         return this.loader.getTurret();
      }
      
      public function notifyListeners() : void
      {
         this.listeners.notify(new TurretReadyEvent(this.descriptor.id,this.loader.getTurret()));
      }
      
      private function start() : void
      {
         this.loader = new TankTurretLoader(this.descriptor);
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.load();
      }
      
      private function onLoadingComplete(event:Event) : void
      {
         this.callback(this);
      }
   }
}
