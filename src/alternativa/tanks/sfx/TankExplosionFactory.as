package alternativa.tanks.sfx
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.Game;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class TankExplosionFactory
   {
      
      private static const EXPLOSION_SIZE:Number = 800;
      
      private static const SMOKE_SIZE:Number = 400;
      
      private static const SHOCKWAVE_SIZE:Number = 1000;
      
      private static const BASE_DIAGONAL:Number = 600;
      
      private static const MIN_SMOKE_SPEED:Number = 800;
      
      private static const SMOKE_SPEED_DELTA:Number = 200;
      
      private static const SMOKE_ACCELERATION:Number = -2000;
      
      private static const EXPLOSION_FIRE_OFFSET_TO_CAMERA:int = 200;
       
      
      private const rayHit:RayHit = new RayHit();
      
      private const position:Vector3 = new Vector3();
      
      private const eulerAngles:Vector3 = new Vector3();
      
      private const velocity:Vector3 = new Vector3();
      
      private const matrix:Matrix3 = new Matrix3();
      
      private const shockWaveScaleSpeed:Number = 1;
      
      private var battleScene3D:BattleScene3D;
      
      public function TankExplosionFactory(battleScene3D:BattleScene3D)
      {
         super();
         this.battleScene3D = battleScene3D;
      }
      
      private static function getEffectScale(tank:Tank) : Number
      {
         var hullMesh:Mesh = tank.skin.hullMesh;
         var dx:Number = hullMesh.boundMaxX - hullMesh.boundMinX;
         var dy:Number = hullMesh.boundMaxY - hullMesh.boundMinY;
         var dz:Number = hullMesh.boundMaxZ - hullMesh.boundMinZ;
         var diagonal:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         return diagonal / BASE_DIAGONAL;
      }
      
      public function createEffect(tank:Tank) : void
      {
         var effectScale:Number = getEffectScale(tank);
         this.createExplosionShockWave(tank,effectScale);
         this.createExplosionFire(effectScale);
         this.createExplosionSmoke(effectScale);
      }
      
      private function createExplosionShockWave(tank:Tank, effectScale:Number) : void
      {
         var size:Number = NaN;
         var minTime:Number = NaN;
         var normal:Vector3 = null;
         var angle:Number = NaN;
         var axis:Vector3 = null;
         var animatedPlaneEffect:AnimatedPlaneEffect = null;
         var animation:TextureAnimation = null;
         var dir:Vector3 = new Vector3(0,0,-1);
         var maxTime:Number = 500;
         this.position.copy(tank.chassis.state.position);
         if(Game.getInstance().getCollisionDetector().raycastStatic(this.position,dir,255,maxTime,null,this.rayHit))
         {
            this.rayHit.position.z += 10;
            size = SHOCKWAVE_SIZE;
            minTime = 200;
            if(this.rayHit.t > minTime)
            {
               size *= (maxTime - this.rayHit.t) / (maxTime - minTime);
            }
            normal = this.rayHit.normal;
            angle = Math.acos(normal.z);
            axis = new Vector3(-normal.y,normal.x,0);
            axis.normalize();
            this.matrix.fromAxisAngle(axis,angle);
            this.matrix.getEulerAngles(this.eulerAngles);
            animatedPlaneEffect = AnimatedPlaneEffect(Game.getInstance().getObjectFromPool(AnimatedPlaneEffect));
            animation = Game.getInstance().config.textureAnimations.getAnimation("tank_explosion/shockwave");
            animatedPlaneEffect.init(effectScale * size,this.rayHit.position,this.eulerAngles,animation.fps,animation,this.shockWaveScaleSpeed);
            this.battleScene3D.addGraphicEffect(animatedPlaneEffect);
         }
      }
      
      private function createExplosionFire(effectScale:Number) : void
      {
         this.position.z += 50;
         var positionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(Game.getInstance().getObjectFromPool(StaticObject3DPositionProvider));
         positionProvider.init(this.position,EXPLOSION_FIRE_OFFSET_TO_CAMERA);
         var explosion:AnimatedSpriteEffect = AnimatedSpriteEffect(Game.getInstance().getObjectFromPool(AnimatedSpriteEffect));
         var explosionSize:Number = EXPLOSION_SIZE * effectScale;
         var animation:TextureAnimation = Game.getInstance().config.textureAnimations.getAnimation("tank_explosion/explosion");
         explosion.init(explosionSize,explosionSize,animation,Math.random() * 2 * Math.PI,positionProvider);
         this.battleScene3D.addGraphicEffect(explosion);
      }
      
      private function createExplosionSmoke(effectScale:Number) : void
      {
         var speed:Number = NaN;
         var positionProvider:MovingObject3DPositionProvider = null;
         var smokeEffect:AnimatedSpriteEffect = null;
         var smokeSize:Number = NaN;
         var animation:TextureAnimation = null;
         for(var i:int = 0; i < 3; i++)
         {
            speed = MIN_SMOKE_SPEED + Math.random() * SMOKE_SPEED_DELTA;
            this.velocity.x = speed * (1 - 2 * Math.random());
            this.velocity.y = speed * (1 - 2 * Math.random());
            this.velocity.z = speed * 0.5 * (1 + Math.random());
            positionProvider = MovingObject3DPositionProvider(Game.getInstance().getObjectFromPool(MovingObject3DPositionProvider));
            positionProvider.init(this.position,this.velocity,SMOKE_ACCELERATION);
            smokeEffect = AnimatedSpriteEffect(Game.getInstance().getObjectFromPool(AnimatedSpriteEffect));
            smokeSize = SMOKE_SIZE * effectScale;
            animation = Game.getInstance().config.textureAnimations.getAnimation("tank_explosion/smoke");
            smokeEffect.init(smokeSize,smokeSize,animation,Math.random() * 2 * Math.PI,positionProvider);
            this.battleScene3D.addGraphicEffect(smokeEffect);
         }
      }
   }
}
