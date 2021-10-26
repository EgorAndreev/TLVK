package alternativa.tanks.bonuses
{
   import alternativa.tanks.animations.AnimationTrack;
   import alternativa.tanks.animations.KeyFrameAnimation;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class SpawnFlashRenderer extends PooledObject implements Renderer
   {
      
      private static const times:Vector.<Number> = Vector.<Number>([0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5]);
      
      private static const values:Vector.<Number> = Vector.<Number>([0,130.05,255,201.45,140.25,104.55,66.3,40.8,25.5,10.2,0]);
      
      private static const animationTrack:AnimationTrack = new AnimationTrack(times,values);
       
      
      private var colorTransform:AnimatedColorTransform;
      
      private var animation:KeyFrameAnimation;
      
      private var bonus:BattleBonus;
      
      private var battleScene3D:BattleScene3D;
      
      public function SpawnFlashRenderer(pool:Pool)
      {
         this.colorTransform = new AnimatedColorTransform();
         this.animation = new KeyFrameAnimation(animationTrack,this.colorTransform);
         super(pool);
      }
      
      public function start(bonus:BattleBonus, battleScene3D:BattleScene3D) : void
      {
         this.bonus = bonus;
         this.battleScene3D = battleScene3D;
         bonus.onRemove.add(this.destroy);
         bonus.onPickup.add(this.destroy);
         bonus.onDestroy.add(this.destroy);
         bonus.getBonusMesh().colorTransform = this.colorTransform.colorTransform;
         battleScene3D.addRenderer(this,0);
         this.animation.start();
      }
      
      public function render(time:int, deltaMillis:int) : void
      {
         if(this.animation.isComplete())
         {
            this.bonus.activateTrigger();
            this.destroy();
         }
         else
         {
            this.animation.update(deltaMillis / 1000);
         }
      }
      
      private function destroy() : void
      {
         this.battleScene3D.removeRenderer(this,0);
         this.battleScene3D = null;
         this.bonus.onRemove.remove(this.destroy);
         this.bonus.onPickup.remove(this.destroy);
         this.bonus.onDestroy.remove(this.destroy);
         this.bonus.getBonusMesh().colorTransform = null;
         this.bonus = null;
         recycle();
      }
   }
}
