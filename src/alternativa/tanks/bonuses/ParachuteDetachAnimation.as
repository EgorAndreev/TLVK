package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class ParachuteDetachAnimation extends PooledObject implements Renderer
   {
      
      private static const ALPHA_SPEED:Number = 0.001;
      
      private static const XY_SCALE_SPEED:Number = 1 / 4000;
      
      private static const Z_SCALE_SPEED:Number = 1 / 3000;
       
      
      private var battleScene3D:BattleScene3D;
      
      private var parachute:Parachute;
      
      private var cords:Cords;
      
      private var fallSpeed:Number;
      
      public function ParachuteDetachAnimation(pool:Pool)
      {
         super(pool);
      }
      
      public function start(battleScene3D:BattleScene3D, parachute:Parachute, cords:Cords, fallSpeed:Number) : void
      {
         this.battleScene3D = battleScene3D;
         this.parachute = parachute;
         this.cords = cords;
         this.fallSpeed = fallSpeed / 1000;
         battleScene3D.addRenderer(this,0);
      }
      
      public function render(time:int, deltaMillis:int) : void
      {
         var deltaScaleXY:Number = NaN;
         this.parachute.setAlpha(this.parachute.getAlpha() - ALPHA_SPEED * deltaMillis);
         if(this.parachute.getAlpha() <= 0)
         {
            this.destroy();
         }
         else
         {
            this.cords.setAlpha(this.parachute.getAlpha());
            this.parachute.z -= this.fallSpeed * deltaMillis;
            deltaScaleXY = deltaMillis * XY_SCALE_SPEED;
            this.parachute.scaleX += deltaScaleXY;
            this.parachute.scaleY += deltaScaleXY;
            this.parachute.scaleZ -= deltaMillis * Z_SCALE_SPEED;
            this.cords.updateVertices();
         }
      }
      
      private function destroy() : void
      {
         this.battleScene3D.removeRenderer(this,0);
         this.battleScene3D.removeObject(this.parachute);
         this.battleScene3D.removeObject(this.cords);
         this.parachute.recycle();
         this.parachute = null;
         this.cords.recycle();
         this.cords = null;
         this.battleScene3D = null;
         recycle();
      }
   }
}
