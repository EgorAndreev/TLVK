package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class GroundSpawnRenderer extends PooledObject implements Renderer
   {
      
      private static const SCALE_SPEED:Number = 0.005;
       
      
      private var bonus:BattleBonus;
      
      private var battleService:BattleService;
      
      private var param:Number;
      
      public function GroundSpawnRenderer(pool:Pool)
      {
         super(pool);
      }
      
      public function start(bonus:BattleBonus, battleService:BattleService) : void
      {
         this.bonus = bonus;
         this.battleService = battleService;
         this.param = 0;
         bonus.onRemove.add(this.destroy);
         bonus.onPickup.add(this.destroy);
         bonus.onDestroy.add(this.destroy);
         battleService.getBattleScene3D().addRenderer(this,0);
      }
      
      public function render(time:int, deltaMillis:int) : void
      {
         this.param += SCALE_SPEED * deltaMillis;
         if(this.param > 1)
         {
            this.param = 1;
         }
         var bonusMesh:BonusMesh = this.bonus.getBonusMesh();
         bonusMesh.scaleX = this.param;
         bonusMesh.scaleY = this.param;
         bonusMesh.scaleZ = this.param;
         bonusMesh.setAlpha(this.param);
         if(this.param == 1)
         {
            this.startFlashAnimation();
            this.destroy();
         }
      }
      
      private function startFlashAnimation() : void
      {
         var renderer:SpawnFlashRenderer = SpawnFlashRenderer(this.battleService.getObjectPool().getObject(SpawnFlashRenderer));
         renderer.start(this.bonus,this.battleService.getBattleScene3D());
      }
      
      private function destroy() : void
      {
         this.battleService.getBattleScene3D().removeRenderer(this,0);
         this.battleService = null;
         this.bonus.onRemove.remove(this.destroy);
         this.bonus.onPickup.remove(this.destroy);
         this.bonus.onDestroy.remove(this.destroy);
         this.bonus = null;
         recycle();
      }
   }
}
