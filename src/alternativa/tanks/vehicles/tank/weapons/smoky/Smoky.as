package alternativa.tanks.vehicles.tank.weapons.smoky
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Vector3;
   import alternativa.tanks.Game;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.sfx.AnimatedSpriteEffect;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.vehicles.tank.weapons.CommonTargetingSystem;
   import alternativa.tanks.vehicles.tank.weapons.HitInfo;
   import alternativa.tanks.vehicles.tank.weapons.SpriteAnimation;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   import alternativa.tanks.vehicles.tank.weapons.WeaponTextureAnimations;
   import alternativa.tanks.vehicles.tank.weapons.sfx.ShotFlashEffect;
   
   public class Smoky extends Weapon
   {
      
      private static const SHOT_GRAPHIC_EFFECT_LIFE_TIME:int = 100;
      
      private static const RELOAD_TIME:uint = 500;
      
      private static const UP_ANGLE:Number = 10 * Math.PI / 180;
      
      private static const DOWN_ANGLE:Number = 10 * Math.PI / 180;
      
      private static const UP_RAYS:int = 10;
      
      private static const DOWN_RAYS:int = 10;
      
      private static var muzzleFlashMateial:TextureMaterial;
       
      
      private var explosionAnimations:WeaponTextureAnimations;
      
      private var readyTime:uint;
      
      private const targetingSystem:CommonTargetingSystem = new CommonTargetingSystem();
      
      private const hitInfo:HitInfo = new HitInfo();
      
      public function Smoky()
      {
         super("Средне-дальнобойные");
         createMuzzleFlashMaterial();
         this.explosionAnimations = new WeaponTextureAnimations(Game.getInstance().config.xml.smoky.animation);
      }
      
      private static function createMuzzleFlashMaterial() : void
      {
         if(muzzleFlashMateial == null)
         {
            muzzleFlashMateial = new TextureMaterial(Game.getInstance().config.textureLibrary.getTexture("smoky_muzzle_flash"));
         }
      }
      
      override public function update(time:int, delta:int) : void
      {
         if(active && time >= this.readyTime)
         {
            this.readyTime = time + RELOAD_TIME;
            this.fire();
         }
      }
      
      override public function setNextEffects() : void
      {
         this.explosionAnimations.nextAnimation();
      }
      
      override public function setPrevEffects() : void
      {
         this.explosionAnimations.prevAnimation();
      }
      
      override public function getEffectsName() : String
      {
         return this.explosionAnimations.getCurrentAnimation().textureAnimation.animationId;
      }
      
      private function fire() : void
      {
         var game:Game = Game.getInstance();
         calculateTurretParams();
         if(this.targetingSystem.getTarget(1410065408,muzzlePosition,barrelDirection,xAxis,UP_ANGLE,UP_RAYS,DOWN_ANGLE,DOWN_RAYS,game.getCollisionDetector(),tank,this.hitInfo))
         {
            this.createExplosion(this.hitInfo.pos);
         }
         this.createMuzzleFlash();
         barrelDirection.scale(-20000000);
         tank.chassis.addWorldForce(muzzlePosition,barrelDirection);
      }
      
      private function createExplosion(position:Vector3) : void
      {
         var game:Game = Game.getInstance();
         var positionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(game.getObjectFromPool(StaticObject3DPositionProvider));
         positionProvider.init(position,50);
         var effect:AnimatedSpriteEffect = AnimatedSpriteEffect(game.getObjectFromPool(AnimatedSpriteEffect));
         var spriteAnimation:SpriteAnimation = this.explosionAnimations.getCurrentAnimation();
         effect.init(spriteAnimation.frameSize,spriteAnimation.frameSize,spriteAnimation.textureAnimation,0,positionProvider);
         game.getBattleScene3D().addGraphicEffect(effect);
      }
      
      private function createMuzzleFlash() : void
      {
         var game:Game = Game.getInstance();
         var config:Config = game.config;
         var graphicEffect:ShotFlashEffect = ShotFlashEffect(game.getObjectFromPool(ShotFlashEffect));
         graphicEffect.init(tank.turret.muzzlePoints[0],tank.skin.turretMesh,muzzleFlashMateial,SHOT_GRAPHIC_EFFECT_LIFE_TIME,60,100);
         game.getBattleScene3D().addGraphicEffect(graphicEffect);
      }
   }
}
