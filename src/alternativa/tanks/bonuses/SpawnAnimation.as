package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class SpawnAnimation extends PooledObject implements Renderer
   {
      
      private static const ALPHA_SPEED:Number = 0.001;
       
      
      private var bonus:BattleBonus;
      
      private var battleScene3D:BattleScene3D;
      
      private var alpha:Number = 0;
      
      public function SpawnAnimation(pool:Pool)
      {
         super(pool);
      }
      
      public function start(bonus:BattleBonus, battleScene3D:BattleScene3D) : void
      {
         this.bonus = bonus;
         this.battleScene3D = battleScene3D;
         this.alpha = 0;
         bonus.onDestroy.add(this.destroy);
         battleScene3D.addRenderer(this,0);
      }
      
      public function render(time:int, deltaMillis:int) : void
      {
         this.alpha += ALPHA_SPEED * deltaMillis;
         if(this.alpha > 1)
         {
            this.alpha = 1;
         }
         this.bonus.setAlpha(this.alpha);
         if(this.alpha >= 1)
         {
            this.destroy();
         }
      }
      
      private function destroy() : void
      {
         this.battleScene3D.removeRenderer(this,0);
         this.battleScene3D = null;
         this.bonus.onDestroy.remove(this.destroy);
         this.bonus = null;
         recycle();
      }
   }
}
