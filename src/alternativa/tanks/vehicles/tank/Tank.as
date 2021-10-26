package alternativa.tanks.vehicles.tank
{
   import alternativa.engine3d.core.Shadow;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.Game;
   import alternativa.tanks.GameObject;
   import alternativa.tanks.display.controllers.CameraTarget;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.vehicles.tank.physics.Chassis;
   import alternativa.tanks.vehicles.tank.physics.ChassisID;
   import alternativa.tanks.vehicles.tank.physics.TankPhysicsVisualizer;
   import alternativa.tanks.vehicles.tank.skin.TankSkin;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   import flash.display.BitmapData;
   
   public class Tank extends GameObject implements CameraTarget
   {
      
      private static const _v:Vector3 = new Vector3();
      
      private static const _m:Matrix3 = new Matrix3();
      
      private static const m41:Matrix4 = new Matrix4();
      
      private static const m42:Matrix4 = new Matrix4();
       
      
      private const interpolatedPosition:Vector3 = new Vector3();
      
      private const interpolatedOrientation:Quaternion = new Quaternion();
      
      public var turretAngularSpeed:Number = 1;
      
      public var hull:TankHull;
      
      public var turret:TankTurret;
      
      public var chassis:Chassis;
      
      public var skin:TankSkin;
      
      private var _debug:Boolean;
      
      private var physicsVisualizer:TankPhysicsVisualizer;
      
      private var weapon:Weapon;
      
      public var shadow:Shadow;
      
      private var interpolatedTurretDirection:Number = 0;
      
      public function Tank(hull:TankHull, turret:TankTurret, colormap:BitmapData)
      {
         super(GameObject.getId());
         this.chassis = new Chassis(this);
         this.skin = new TankSkin();
         this.shadow = new Shadow(128,8,100,5000000,10000000,516,0.95);
         this.shadow.offset = 100;
         this.shadow.backFadeRange = 100;
         this.setHull(hull);
         this.setTurret(turret);
         this.setColormap(colormap);
         this.shadow.addCaster(this.skin.hullMesh);
         this.shadow.addCaster(this.skin.turretMesh);
      }
      
      public function getCameraParams(position:Vector3, direction:Vector3) : void
      {
         this.interpolatedOrientation.toMatrix3(_m);
         _v.copy(this.interpolatedPosition);
         var h:Number = this.skin.getHalfHeight() + TankConst.SKIN_DISPLACEMENT_Z;
         _v.x -= h * _m.c;
         _v.y -= h * _m.g;
         _v.z -= h * _m.k;
         m41.setFromMatrix3(_m,_v);
         var turretMountPoint:Vector3 = this.skin.getHull().turretSkinMountPoint;
         m42.setMatrix(turretMountPoint.x,turretMountPoint.y,turretMountPoint.z,0,0,-this.interpolatedTurretDirection);
         m42.append(m41);
         position.reset(m42.d,m42.h,m42.l);
         direction.reset(m42.b,m42.f,m42.j);
      }
      
      public function setWeapon(weapon:Weapon) : void
      {
         this.weapon = weapon;
         weapon.tank = this;
      }
      
      public function setHull(hull:TankHull) : void
      {
         if(hull == null)
         {
            throw new ArgumentError("Hull is null");
         }
         if(this.hull != hull)
         {
            if(game != null)
            {
               game.beforeTankChange(this);
            }
            this.hull = hull;
            this.chassis.setHull(hull);
            this.skin.setHull(hull);
            this.updatePhysicsVisualizer();
            this.shadow.removeAllCasters();
            this.shadow.addCaster(this.skin.hullMesh);
            this.shadow.addCaster(this.skin.turretMesh);
            if(game != null)
            {
               game.afterTankChange(this);
            }
         }
      }
      
      public function setTurret(turret:TankTurret) : void
      {
         if(turret == null)
         {
            throw new ArgumentError("Turret is null");
         }
         if(this.turret != turret)
         {
            if(game != null)
            {
               game.beforeTankChange(this);
            }
            this.turret = turret;
            this.chassis.setTurret(turret);
            this.skin.setTurret(turret);
            this.updatePhysicsVisualizer();
            this.shadow.removeAllCasters();
            this.shadow.addCaster(this.skin.hullMesh);
            this.shadow.addCaster(this.skin.turretMesh);
            if(game != null)
            {
               game.afterTankChange(this);
            }
         }
      }
      
      public function setColormap(colormap:BitmapData) : void
      {
         this.skin.setColormap(colormap);
      }
      
      public function get turretDirection() : Number
      {
         return this.chassis.turretDirection;
      }
      
      public function set turretDirection(value:Number) : void
      {
         this.chassis.turretDirection = value;
      }
      
      public function rotateTurret(angle:Number) : void
      {
         this.turretDirection += angle;
      }
      
      public function get debug() : Boolean
      {
         return this._debug;
      }
      
      public function set debug(value:Boolean) : void
      {
         if(this._debug != value)
         {
            if(this._debug && this.physicsVisualizer != null)
            {
               this.physicsVisualizer.removeFromContainer();
            }
            this._debug = value;
            if(this._debug && this.physicsVisualizer != null && game != null)
            {
               this.physicsVisualizer.addToContainer(game.renderSystem.scene3D.getFrontContainer());
            }
         }
      }
      
      override public function addToGame(game:Game) : void
      {
         this.game = game;
         game.physicsSystem.physicsScene.addBody(this.chassis);
         game.physicsSystem.physicsControllers.add(this.chassis);
         TanksCollisionDetector(game.physicsSystem.physicsScene.collisionDetector).addBodyWrapper(this.chassis.wrapper);
         this.skin.addToContainer(game.config.map.mapContainer);
         this.updatePhysicsVisualizer();
      }
      
      override public function removeFromGame() : void
      {
         if(game != null)
         {
            game.physicsSystem.physicsScene.removeBody(this.chassis);
            game.physicsSystem.physicsControllers.remove(this.chassis);
            TanksCollisionDetector(game.physicsSystem.physicsScene.collisionDetector).removeBodyWrapper(this.chassis.wrapper);
            this.skin.removeFromContainer();
            if(this._debug && this.physicsVisualizer != null)
            {
               this.physicsVisualizer.removeFromContainer();
            }
            game = null;
         }
      }
      
      override public function update(time:uint, deltaMsec:uint, deltaSec:Number, t:Number) : void
      {
         this.updateSkin(t);
         this.skin.updateTracks(deltaSec * this.chassis._leftTrack.getSpeed(),deltaSec * this.chassis._rightTrack.getSpeed());
         if(this.weapon != null)
         {
            this.weapon.update(time,deltaMsec);
         }
         if(this._debug)
         {
            this.physicsVisualizer.update();
         }
      }
      
      private function updateSkin(t:Number) : void
      {
         var pi2:Number = NaN;
         this.chassis.interpolate(t,this.interpolatedPosition,this.interpolatedOrientation);
         this.interpolatedOrientation.normalize();
         var oldAngle:Number = this.chassis._prevTurretDirection;
         var newAngle:Number = this.chassis._turretDirection;
         var pi_2:Number = 0.5 * Math.PI;
         if(oldAngle < -pi_2 && newAngle > pi_2 || oldAngle > pi_2 && newAngle < -pi_2)
         {
            pi2 = 2 * Math.PI;
            if(oldAngle < newAngle)
            {
               this.interpolatedTurretDirection = oldAngle - t * (pi2 + oldAngle - newAngle);
            }
            else
            {
               this.interpolatedTurretDirection = oldAngle + t * (pi2 - oldAngle + newAngle);
            }
         }
         else
         {
            this.interpolatedTurretDirection = oldAngle + t * (newAngle - oldAngle);
         }
         this.skin.updateTransform(this.interpolatedPosition,this.interpolatedOrientation,this.interpolatedTurretDirection);
      }
      
      private function updatePhysicsVisualizer() : void
      {
         if(this.physicsVisualizer != null)
         {
            this.physicsVisualizer.removeFromContainer();
         }
         if(this.hull != null && this.turret != null)
         {
            this.physicsVisualizer = new TankPhysicsVisualizer(this);
            if(this._debug && game != null)
            {
               this.physicsVisualizer.addToContainer(game.renderSystem.scene3D.getFrontContainer());
            }
         }
      }
      
      public function getWeapon() : Weapon
      {
         return this.weapon;
      }
      
      public function destroy() : void
      {
         ChassisID.releaseId(this.chassis.chassisId);
      }
   }
}
