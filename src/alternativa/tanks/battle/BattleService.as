package alternativa.tanks.battle
{
   import alternativa.tanks.utils.objectpool.ObjectPool;
   
   public interface BattleService
   {
       
      
      function getObjectPool() : ObjectPool;
      
      function getBattleScene3D() : BattleScene3D;
      
      function getBattleRunner() : BattleRunner;
   }
}
