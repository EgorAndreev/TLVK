package alternativa.tanks.bonuses
{
   import alternativa.types.Long;
   import flash.utils.Dictionary;
   
   public class BonusCache
   {
      
      private static const parachuteCache:ObjectCache = new ObjectCache();
      
      private static const cordsCache:ObjectCache = new ObjectCache();
      
      private static const boxCaches:Dictionary = new Dictionary();
       
      
      public function BonusCache()
      {
         super();
      }
      
      public static function isParachuteCacheEmpty() : Boolean
      {
         return parachuteCache.isEmpty();
      }
      
      public static function getParachute() : Parachute
      {
         return Parachute(parachuteCache.get());
      }
      
      public static function putParachute(parachute:Parachute) : void
      {
         parachuteCache.put(parachute);
      }
      
      public static function isCordsCacheEmpty() : Boolean
      {
         return cordsCache.isEmpty();
      }
      
      public static function getCords() : Cords
      {
         return Cords(cordsCache.get());
      }
      
      public static function putCords(cords:Cords) : void
      {
         cordsCache.put(cords);
      }
      
      public static function isBonusMeshCacheEmpty(objectId:Long) : Boolean
      {
         return getBonusMeshCache(objectId).isEmpty();
      }
      
      public static function getBonusMesh(objectId:Long) : BonusMesh
      {
         return BonusMesh(getBonusMeshCache(objectId).get());
      }
      
      public static function putBonusMesh(bonusMesh:BonusMesh) : void
      {
         getBonusMeshCache(bonusMesh.getObjectId()).put(bonusMesh);
      }
      
      private static function getBonusMeshCache(objectId:Long) : ObjectCache
      {
         var cache:ObjectCache = boxCaches[objectId];
         if(cache == null)
         {
            cache = new ObjectCache();
            boxCaches[objectId] = cache;
         }
         return cache;
      }
   }
}
