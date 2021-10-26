package alternativa.tanks.library.turrets
{
   import alternativa.tanks.library.LibraryIterator;
   import alternativa.tanks.library.MissedDescriptorError;
   import alternativa.tanks.library.PartsLibrary;
   import alternativa.tanks.library.PartsLibraryIdentifiers;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class TurretsLibrary implements PartsLibrary
   {
       
      
      private var descriptors:Dictionary;
      
      private var ids:Vector.<String>;
      
      private var turrets:Object;
      
      private var loader:TurretsLoader;
      
      public function TurretsLibrary(descriptors:Vector.<TurretDescriptor>)
      {
         var descriptor:TurretDescriptor = null;
         this.descriptors = new Dictionary();
         this.turrets = {};
         super();
         this.ids = new Vector.<String>();
         for each(descriptor in descriptors)
         {
            this.ids.push(descriptor.id);
            this.descriptors[descriptor.id] = descriptor;
         }
         this.loader = new TurretsLoader(this.onTurretReady);
      }
      
      public function getTurret(id:String, callback:Function) : void
      {
         this.checkAvailability(id);
         if(this.turretIsReady(id))
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
      
      private function turretIsReady(id:String) : Boolean
      {
         return this.turrets[id] != null;
      }
      
      private function callLater(callback:Function, id:String) : void
      {
         setTimeout(function():void
         {
            callback(new TurretReadyEvent(id,turrets[id]));
         },0);
      }
      
      private function load(id:String, callback:Function) : void
      {
         this.loader.load(this.descriptors[id],callback);
      }
      
      private function onTurretReady(id:String, turret:TankTurret) : void
      {
         this.turrets[id] = turret;
      }
   }
}
