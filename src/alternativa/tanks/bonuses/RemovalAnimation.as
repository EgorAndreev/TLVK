package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.sfx.Blinker;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.utils.getTimer;
   
   public class RemovalAnimation extends PooledObject implements Renderer
   {
      
      private static const MAX_BLINK_INTERVAL:int = 500;
      
      private static const MIN_BLINK_INTERVAL:int = 22;
      
      private static const BLINK_INTERVAL_DECREMENT:int = 12;
      
      private static const ALPHA_SPEED_COEFF:Number = 10;
      
      private static const DELTA_ALPHA:Number = 0.5;
      
      private static const MIN_ALPHA:Number = 1 - DELTA_ALPHA;
      
      private static const REMOVAL_ALPHA_SPEED:Number = 0.001;
      
      private static const REMOVAL_WARNING_THRESHOLD:int = 10400;
       
      
      private const blinker:Blinker = new Blinker(MAX_BLINK_INTERVAL,MIN_BLINK_INTERVAL,BLINK_INTERVAL_DECREMENT,MIN_ALPHA,1,ALPHA_SPEED_COEFF);
      
      private var battleScene3D:BattleScene3D;
      
      private var bonusMesh:BonusMesh;
      
      private var startTime:int;
      
      private var canRemove:Boolean;
      
      private var blinking:Boolean;
      
      private var started:Boolean;
      
      public function RemovalAnimation(pool:Pool)
      {
         super(pool);
      }
      
      public function init(battleScene3D:BattleScene3D, bonus:BattleBonus, timeLeft:int) : void
      {
         var currentTimeMs:int = getTimer();
         this.battleScene3D = battleScene3D;
         this.bonusMesh = bonus.getBonusMesh();
         this.startTime = currentTimeMs + timeLeft - REMOVAL_WARNING_THRESHOLD;
         this.started = false;
         this.blinking = true;
         this.canRemove = false;
         if(timeLeft < REMOVAL_WARNING_THRESHOLD)
         {
            this.blinker.setInitialInterval(MIN_BLINK_INTERVAL + (MAX_BLINK_INTERVAL - MIN_BLINK_INTERVAL) * timeLeft / REMOVAL_WARNING_THRESHOLD);
         }
         else
         {
            this.blinker.setInitialInterval(MAX_BLINK_INTERVAL);
         }
         battleScene3D.addRenderer(this,0);
         bonus.onPickup.addOnce(this.onBonusPickup);
         bonus.onRemove.addOnce(this.onBonusRemove);
      }
      
      private function onBonusPickup() : void
      {
         this.bonusMesh = null;
         this.destroy();
      }
      
      private function onBonusRemove() : void
      {
         this.canRemove = true;
         var t:int = getTimer() - REMOVAL_WARNING_THRESHOLD;
         if(this.startTime > t)
         {
            this.startTime = t;
         }
      }
      
      public function render(currentTimeMs:int, deltaTimeMs:int) : void
      {
         if(currentTimeMs >= this.startTime)
         {
            if(this.blinking)
            {
               if(!this.started)
               {
                  this.started = true;
                  this.blinker.init(currentTimeMs);
               }
               this.blink(currentTimeMs,deltaTimeMs);
            }
            else
            {
               this.fadeOut(deltaTimeMs);
            }
         }
      }
      
      private function blink(currentTimeMs:int, deltaTimeMs:int) : void
      {
         var alpha:Number = this.blinker.updateValue(currentTimeMs,deltaTimeMs);
         this.bonusMesh.setAlpha(alpha);
         if(this.canRemove && currentTimeMs >= this.startTime + REMOVAL_WARNING_THRESHOLD && alpha == MIN_ALPHA)
         {
            this.blinking = false;
         }
      }
      
      private function fadeOut(deltaTimeMs:int) : void
      {
         var newScale:Number = NaN;
         var alpha:Number = this.bonusMesh.getAlpha();
         alpha -= REMOVAL_ALPHA_SPEED * deltaTimeMs;
         if(alpha > 0)
         {
            this.bonusMesh.setAlpha(alpha);
            if(this.bonusMesh.scaleX > 0)
            {
               newScale = this.bonusMesh.scaleX - 0.002 * deltaTimeMs;
               if(newScale < 0)
               {
                  newScale = 0;
               }
               this.bonusMesh.scaleX = newScale;
               this.bonusMesh.scaleY = newScale;
               this.bonusMesh.scaleZ = newScale;
            }
         }
         else
         {
            this.destroy();
         }
      }
      
      private function destroy() : void
      {
         this.battleScene3D.removeRenderer(this,0);
         if(this.bonusMesh != null)
         {
            this.battleScene3D.removeObject(this.bonusMesh);
            this.bonusMesh.recycle();
            this.bonusMesh = null;
         }
         this.battleScene3D = null;
         recycle();
      }
   }
}
