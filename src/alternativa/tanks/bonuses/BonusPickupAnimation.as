package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   public class BonusPickupAnimation extends PooledObject implements Renderer
   {
      
      private static const PICKUP_ANIMATION_TIME:int = 2000;
      
      private static const FLASH_DURATION:int = 300;
      
      private static const ALPHA_DURATION:int = PICKUP_ANIMATION_TIME - FLASH_DURATION;
      
      private static const MAX_ADDITIVE_VALUE:int = 204;
      
      private static const ADDITIVE_SPEED_UP:Number = Number(MAX_ADDITIVE_VALUE) / FLASH_DURATION;
      
      private static const ADDITIVE_SPEED_DOWN:Number = Number(MAX_ADDITIVE_VALUE) / (PICKUP_ANIMATION_TIME - FLASH_DURATION);
      
      private static const UP_SPEED:Number = 300;
      
      private static const ANGLE_SPEED:Number = 2;
       
      
      private var bonusMesh:BonusMesh;
      
      private var battleScene3D:BattleScene3D;
      
      private var colorTransform:ColorTransform;
      
      private var animationTime:int;
      
      private var additiveValue:int;
      
      public function BonusPickupAnimation(pool:Pool)
      {
         this.colorTransform = new ColorTransform();
         super(pool);
      }
      
      public function start(bonus:BonusMesh, battleScene3D:BattleScene3D) : void
      {
         this.bonusMesh = bonus;
         this.battleScene3D = battleScene3D;
         this.bonusMesh.colorTransform = this.colorTransform;
         this.animationTime = PICKUP_ANIMATION_TIME;
         this.additiveValue = 0;
         battleScene3D.addRenderer(this,0);
      }
      
      public function render(time:int, deltaMillis:int) : void
      {
         if(this.animationTime > 0)
         {
            this.playAnimation(deltaMillis);
         }
         else
         {
            this.destroy();
         }
      }
      
      private function playAnimation(millis:int) : void
      {
         var dt:Number = millis / 1000;
         this.bonusMesh.z += (UP_SPEED * this.animationTime / PICKUP_ANIMATION_TIME + UP_SPEED * 0.1) * dt;
         this.bonusMesh.rotationZ += (ANGLE_SPEED * this.animationTime / PICKUP_ANIMATION_TIME + ANGLE_SPEED * 0.1) * dt;
         if(this.animationTime > PICKUP_ANIMATION_TIME - FLASH_DURATION)
         {
            this.additiveValue += ADDITIVE_SPEED_UP * millis;
            if(this.additiveValue > MAX_ADDITIVE_VALUE)
            {
               this.additiveValue = MAX_ADDITIVE_VALUE;
            }
         }
         else
         {
            this.additiveValue -= ADDITIVE_SPEED_DOWN * millis;
            if(this.additiveValue < 0)
            {
               this.additiveValue = 0;
            }
         }
         this.colorTransform.redOffset = this.additiveValue;
         this.colorTransform.blueOffset = this.additiveValue;
         this.colorTransform.greenOffset = this.additiveValue;
         if(this.animationTime < ALPHA_DURATION)
         {
            this.bonusMesh.setAlpha(this.animationTime / ALPHA_DURATION);
         }
         this.animationTime -= millis;
      }
      
      private function destroy() : void
      {
         this.bonusMesh.colorTransform = null;
         this.battleScene3D.removeObject(this.bonusMesh);
         this.bonusMesh.recycle();
         this.bonusMesh = null;
         this.battleScene3D.removeRenderer(this,0);
         this.battleScene3D = null;
         recycle();
      }
   }
}
