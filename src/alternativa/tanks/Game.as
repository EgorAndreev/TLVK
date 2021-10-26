package alternativa.tanks
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.tanks.battle.BattleRunner;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.battle.Trigger;
   import alternativa.tanks.bonuses.BonusSpawner;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.config.TanksMap;
   import alternativa.tanks.display.DebugPanel;
   import alternativa.tanks.sfx.TankExplosionFactory;
   import alternativa.tanks.systems.SystemPriority;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.gameobjectssystem.GameObjectsSystem;
   import alternativa.tanks.systems.logicunits.LogicUnitsSystem;
   import alternativa.tanks.systems.objectcontrollers.ObjectControllersSystem;
   import alternativa.tanks.systems.physicssystem.PhysicsSystem;
   import alternativa.tanks.systems.rendersystem.RenderSystem;
   import alternativa.tanks.systems.timesystem.TimeSystem;
   import alternativa.tanks.systems.touchedprimitivestracking.TouchedPrimitivesTrackingSystem;
   import alternativa.tanks.taskmanager.TaskManager;
   import alternativa.tanks.utils.GOList;
   import alternativa.tanks.utils.GOListItem;
   import alternativa.tanks.utils.KeyboardListener;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.physics.Chassis;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.geom.Vector3D;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   use namespace alternativa3d;
   
   [Event(name="initComplete",type="alternativa.tanks.GameEvent")]
   public class Game extends EventDispatcher implements BattleService, BattleRunner
   {
      
      private static var instance:Game;
       
      
      public var config:Config;
      
      public var stage:Stage;
      
      public var gameObjects:GOList;
      
      public var gameObjectById:Dictionary;
      
      private var spawnPoints:SpawnPoints;
      
      private var tankConstructor:TankConstructor;
      
      private var keyboardListener:KeyboardListener;
      
      private var doPhysics:Boolean = true;
      
      private var tanksManager:TanksManager;
      
      private var objectPool:ObjectPool;
      
      private var tankExplosionFactory:TankExplosionFactory;
      
      private var bonusSpawner:BonusSpawner;
      
      private const taskManager:TaskManager = new TaskManager();
      
      public var physicsSystem:PhysicsSystem;
      
      var debugPanel:DebugPanel;
      
      public var renderSystem:RenderSystem;
      
      public var logicUnitsSystem:LogicUnitsSystem;
      
      public function Game(config:Config, stage:Stage)
      {
         this.gameObjects = new GOList();
         this.gameObjectById = new Dictionary();
         this.objectPool = new ObjectPool();
         this.debugPanel = new DebugPanel();
         super();
         if(instance != null)
         {
            throw new Error("Game class is singleton");
         }
         instance = this;
         this.config = config;
         this.stage = stage;
         this.init();
      }
      
      public static function getInstance() : Game
      {
         return instance;
      }
      
      private static function vector3To3D(v:Vector3) : Vector3D
      {
         return new Vector3D(v.x,v.y,v.z);
      }
      
      public function addPhysicsController(controller:PhysicsController) : void
      {
         this.physicsSystem.physicsControllers.add(controller);
      }
      
      public function removePhysicsController(controller:PhysicsController) : void
      {
         this.physicsSystem.physicsControllers.remove(controller);
      }
      
      public function addPhysicsInterpolator(interpolator:PhysicsInterpolator) : void
      {
         this.physicsSystem.physicsInterpolators.add(interpolator);
      }
      
      public function removePhysicsInterpolator(interpolator:PhysicsInterpolator) : void
      {
         this.physicsSystem.physicsInterpolators.remove(interpolator);
      }
      
      public function addTrigger(trigger:Trigger) : void
      {
         this.physicsSystem.triggers.add(trigger);
      }
      
      public function removeTrigger(trigger:Trigger) : void
      {
         this.physicsSystem.triggers.remove(trigger);
      }
      
      public function getCollisionDetector() : CollisionDetector
      {
         return this.physicsSystem.physicsScene.collisionDetector;
      }
      
      public function getBattleService() : BattleService
      {
         return this;
      }
      
      public function getObjectPool() : ObjectPool
      {
         return this.objectPool;
      }
      
      public function getObjectFromPool(objectClass:Class) : Object
      {
         return this.objectPool.getObject(objectClass);
      }
      
      public function addGameObject(gameObject:GameObject) : void
      {
         if(this.gameObjectById[gameObject.id] != null)
         {
            throw new Error("Object already exists");
         }
         this.gameObjectById[gameObject.id] = new GOListItem(gameObject);
         this.gameObjects.append(gameObject);
         gameObject.addToGame(this);
      }
      
      public function removeGameObject(gameObject:GameObject) : void
      {
         if(this.gameObjects.remove(gameObject))
         {
            gameObject.removeFromGame();
            delete this.gameObjectById[gameObject.id];
         }
      }
      
      private function init() : void
      {
         this.keyboardListener = new KeyboardListener(this.stage);
         this.tanksManager = new TanksManager(this,this.debugPanel);
         this.taskManager.addTask(new TimeSystem());
         this.logicUnitsSystem = new LogicUnitsSystem(SystemPriority.LOGIC,SystemTags.LOGIC);
         this.taskManager.addTask(this.logicUnitsSystem);
         this.taskManager.addTask(new ObjectControllersSystem(SystemPriority.OBJECT_CONTROLLERS,SystemTags.OBJECT_CONTROLLERS,this.gameObjects));
         this.physicsSystem = new PhysicsSystem(this.config,this.debugPanel);
         this.taskManager.addTask(this.physicsSystem);
         this.taskManager.addTask(new GameObjectsSystem(this.gameObjects));
         this.renderSystem = new RenderSystem(this.stage,this.debugPanel,this.config,this.tanksManager);
         this.taskManager.addTask(this.renderSystem);
         this.taskManager.addTask(new TankParamsPrinter(this.tanksManager));
         this.bonusSpawner = new BonusSpawner(this,this.keyboardListener);
         this.tankExplosionFactory = new TankExplosionFactory(this.renderSystem.scene3D);
         this.initTankConstructor();
         this.initSpawnPoints();
         this.initKeyboardListeners();
         setTimeout(this.completeInit,0);
      }
      
      public function tick() : void
      {
         this.taskManager.runTasks();
      }
      
      private function initKeyboardListeners() : void
      {
         this.keyboardListener.addHandler(Keyboard.B,this.renderSystem.toggleSkyBox);
         this.keyboardListener.addHandler(KeyboardListener.BIT_CTRL | Keyboard.B,this.renderSystem.toggleGraphicsDebugMode);
         this.keyboardListener.addHandler(Keyboard.TAB,this.renderSystem.setNextMapObject);
         this.keyboardListener.addHandler(Keyboard.F2,this.renderSystem.toggleWireTree);
         this.keyboardListener.addHandler(KeyboardListener.BIT_CTRL | Keyboard.F2,this.toggleTouchedPrimitivesVisualization);
         this.keyboardListener.addHandler(Keyboard.R,this.restoreTankPosition);
         this.keyboardListener.addHandler(Keyboard.F5,this.toggleSpawnPoints);
         this.keyboardListener.addHandler(Keyboard.F6,this.toggleTankPhysicsVisualization);
         this.keyboardListener.addHandler(KeyboardListener.BIT_CTRL | Keyboard.F6,this.toggleTankSkin);
         this.keyboardListener.addHandler(Keyboard.F7,this.renderSystem.toggleAABBResolving);
         this.keyboardListener.addHandler(Keyboard.F8,this.renderSystem.toggleOOBBResolving);
         this.keyboardListener.addHandler(Keyboard.F12,this.togglePhysics);
         this.keyboardListener.addHandler(Keyboard.F,this.renderSystem.toggleCameraController);
         this.keyboardListener.addHandler(Keyboard.NUMPAD_7,this.setPrevTurret);
         this.keyboardListener.addHandler(Keyboard.NUMPAD_9,this.setNextTurret);
         this.keyboardListener.addHandler(Keyboard.NUMPAD_4,this.setPrevHull);
         this.keyboardListener.addHandler(Keyboard.NUMPAD_6,this.setNextHull);
         this.keyboardListener.addHandler(Keyboard.NUMPAD_1,this.setPrevColormap);
         this.keyboardListener.addHandler(Keyboard.NUMPAD_3,this.setNextColormap);
         this.keyboardListener.addHandler(Keyboard.LEFTBRACKET,this.setPrevWeapon);
         this.keyboardListener.addHandler(Keyboard.RIGHTBRACKET,this.setNextWeapon);
         this.keyboardListener.addHandler(Keyboard.SEMICOLON,this.setPrevWeaponEffects);
         this.keyboardListener.addHandler(Keyboard.QUOTE,this.setNextWeaponEffects);
         this.keyboardListener.addHandler(Keyboard.F3,this.toggleStaticPrimitivesTouchVisualization);
         this.keyboardListener.addHandler(Keyboard.L,this.createTankExplosion);
      }
      
      private function toggleStaticPrimitivesTouchVisualization() : void
      {
         if(this.taskManager.isTaskExist(SystemTags.TOUCHED_PRIMITIVES_TRACKING))
         {
            this.taskManager.killTaskWithTag(SystemTags.TOUCHED_PRIMITIVES_TRACKING);
         }
         else
         {
            this.taskManager.addTask(new TouchedPrimitivesTrackingSystem(SystemPriority.RENDER - 1,SystemTags.TOUCHED_PRIMITIVES_TRACKING,this.debugPanel,this.config));
         }
      }
      
      private function createTankExplosion() : void
      {
         var tank:Tank = null;
         if(this.tanksManager.numTanks() > 0)
         {
            tank = this.tanksManager.currentTank();
            this.tankExplosionFactory.createEffect(tank);
            this.tanksManager.setColorForCurrentTank("Dead");
            tank.chassis.state.velocity.z += 500;
            tank.chassis.state.angularVelocity.reset(2,2,2);
         }
      }
      
      private function setPrevTurret() : void
      {
         this.tanksManager.setTurretForCurrentTank(this.tankConstructor.prevTurret());
      }
      
      private function setNextTurret() : void
      {
         this.tanksManager.setTurretForCurrentTank(this.tankConstructor.nextTurret());
      }
      
      private function setPrevHull() : void
      {
         this.tanksManager.setHullForCurrentTank(this.tankConstructor.prevHull());
      }
      
      private function setNextHull() : void
      {
         this.tanksManager.setHullForCurrentTank(this.tankConstructor.nextHull());
      }
      
      private function setPrevColormap() : void
      {
         this.tanksManager.setColorForCurrentTank(this.tankConstructor.prevColormap());
      }
      
      private function setNextColormap() : void
      {
         this.tanksManager.setColorForCurrentTank(this.tankConstructor.nextColormap());
      }
      
      private function setNextWeapon() : void
      {
         this.tanksManager.setNextWeaponForCurrentTank();
      }
      
      private function setPrevWeapon() : void
      {
         this.tanksManager.setPrevWeaponForCurrentTank();
      }
      
      private function setPrevWeaponEffects() : void
      {
         this.tanksManager.setPrevWeaponEffects();
      }
      
      private function setNextWeaponEffects() : void
      {
         this.tanksManager.setNextWeaponEffects();
      }
      
      private function toggleSpawnPoints() : void
      {
         var map:TanksMap = this.config.map;
         map.toggleSpawnMarkers("dm");
         map.toggleSpawnMarkers("red");
         map.toggleSpawnMarkers("blue");
         map.toggleCTFFlagMarker("red");
         map.toggleCTFFlagMarker("blue");
      }
      
      private function toggleTankPhysicsVisualization() : void
      {
         var tank:Tank = null;
         if(this.tanksManager.currentTankExists())
         {
            tank = this.tanksManager.currentTank();
            tank.debug = !tank.debug;
         }
      }
      
      private function toggleTankSkin() : void
      {
         var tank:Tank = null;
         if(this.tanksManager.currentTankExists())
         {
            tank = this.tanksManager.currentTank();
            tank.skin.visible = !tank.skin.visible;
         }
      }
      
      private function initSpawnPoints() : void
      {
         this.spawnPoints = new SpawnPoints(this);
         this.spawnPoints.showActiveSpawnMarker();
         this.renderSystem.freeCameraController.lookAt(vector3To3D(this.spawnPoints.currentPoint.position));
      }
      
      private function initTankConstructor() : void
      {
         this.tankConstructor = new TankConstructor(this.config);
         this.keyboardListener.addHandler(Keyboard.INSERT,this.addTank);
         this.keyboardListener.addHandler(KeyboardListener.BIT_CTRL | Keyboard.INSERT,this.addTanks);
      }
      
      private function addTank() : void
      {
         this.tankConstructor.createTank(this.onTankReady);
      }
      
      private function addTanks() : void
      {
         var numPoints:int = this.spawnPoints.currentGroupSize;
         for(var i:int = 0; i < numPoints; i++)
         {
            this.tankConstructor.createTank(this.onTankReady2);
         }
      }
      
      private function onTankReady(tank:Tank) : void
      {
         this.renderSystem.addTankToCollisionFilter(tank);
         var position:Vector3 = this.spawnPoints.currentPoint.position.clone();
         position.z += 100;
         tank.chassis.setPosition(position);
         this.tanksManager.addTank(tank);
         this.renderSystem.scene3D.addShadow(tank.shadow);
      }
      
      private function onTankReady2(tank:Tank) : void
      {
         this.renderSystem.addTankToCollisionFilter(tank);
         var position:Vector3 = this.spawnPoints.currentPoint.position.clone();
         this.spawnPoints.selectNextPoint();
         position.z += 200;
         tank.chassis.setPosition(position);
         this.tanksManager.addTank(tank);
         this.renderSystem.scene3D.addShadow(tank.shadow);
      }
      
      private function resetTankPosition(tank:Tank) : void
      {
         var spawnPoint:SpawnPoint = this.spawnPoints.currentPoint;
         var pos:Vector3 = spawnPoint.position;
         var chassis:Chassis = tank.chassis;
         chassis.setPositionXYZ(pos.x,pos.y,pos.z + 100);
         chassis.setOrientation(Quaternion.createFromAxisAngle(Vector3.Z_AXIS,spawnPoint.direction));
      }
      
      private function toggleTouchedPrimitivesVisualization() : void
      {
      }
      
      private function completeInit() : void
      {
         dispatchEvent(new GameEvent(GameEvent.INIT_COMPLETE));
      }
      
      private function restoreTankPosition() : void
      {
      }
      
      private function togglePhysics() : void
      {
      }
      
      public function beforeTankChange(tank:Tank) : void
      {
         this.renderSystem.removeTankFromCollisionFilter(tank);
      }
      
      public function afterTankChange(tank:Tank) : void
      {
         this.renderSystem.addTankToCollisionFilter(tank);
      }
      
      public function currentTankChanged(tank:Tank) : void
      {
         this.renderSystem.followCameraController.setTarget(tank);
         this.physicsSystem.getCollisionDetector().trackedBody = tank.chassis;
      }
      
      public function getBattleScene3D() : BattleScene3D
      {
         return this.renderSystem.scene3D;
      }
      
      public function getBattleRunner() : BattleRunner
      {
         return this;
      }
      
      public function tankRemoved(tank:Tank) : void
      {
         this.renderSystem.scene3D.removeShadow(tank.shadow);
         this.removeGameObject(tank);
         this.physicsSystem.getCollisionDetector().trackedBody = null;
      }
   }
}
