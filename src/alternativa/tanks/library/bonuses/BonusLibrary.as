package alternativa.tanks.library.bonuses
{
   import alternativa.tanks.bonuses.Bonus;
   import alternativa.tanks.bonuses.BonusSkin;
   import alternativa.tanks.library.LibraryIterator;
   import alternativa.tanks.library.MissedDescriptorError;
   import alternativa.tanks.library.PartsLibrary;
   import alternativa.tanks.library.PartsLibraryIdentifiers;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class BonusLibrary implements PartsLibrary
   {
       
      
      private var descriptors:Dictionary;
      
      private var ids:Vector.<String>;
      
      private var bonuses:Object;
      
      private var loader:BonusLoader;
      
      public function BonusLibrary(descriptors:Vector.<BonusDescriptor>)
      {
         var descriptor:BonusDescriptor = null;
         this.descriptors = new Dictionary();
         this.bonuses = {};
         super();
         this.ids = new Vector.<String>();
         for each(descriptor in descriptors)
         {
            this.ids.push(descriptor.id);
            this.descriptors[descriptor.id] = descriptor;
         }
        // this.loader = new BonusLoader(this.onBonusReady);
      }
      
      public function getBonus(id:String, callback:Function) : void
      {
         this.checkAvailability(id);
         if(this.bonusIsReady(id))
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
      
      private function bonusIsReady(id:String) : Boolean
      {
         return this.bonuses[id] != null;
      }
      
      private function callLater(callback:Function, id:String) : void
      {
         setTimeout(function():void
         {
            callback(new BonusReadyEvent(id,bonuses[id]));
         },0);
      }
      
      private function load(id:String, callback:Function) : void
      {
        // this.loader.load(this.descriptors[id],callback);
      }
      
      private function onBonusReady(bonusId:String, bonus:BonusSkin) : void
      {
         this.bonuses[bonusId] = bonus;
      }
   }
}
