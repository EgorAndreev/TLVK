package alternativa.tanks.systems.rendersystem
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.tanks.Scene3D;
   import alternativa.tanks.TanksManager;
   import alternativa.tanks.VisualPhysicsKDTree;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.display.DebugPanel;
   import alternativa.tanks.display.ICameraController;
   import alternativa.tanks.display.Viewport;
   import alternativa.tanks.display.controllers.FollowCameraController;
   import alternativa.tanks.display.controllers.FreeCameraController;
   import alternativa.tanks.systems.SystemPriority;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.physicssystem.PhysicsSystem;
   import alternativa.tanks.systems.timesystem.TimeSystem;
   import alternativa.tanks.taskmanager.GameTask;
   import alternativa.tanks.utils.KeyboardListener;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class RenderSystem extends GameTask
   {
       
      
      public var keyboardListener:KeyboardListener;
      
      public var viewport:Viewport;
      
      public var scene3D:Scene3D;
      
      public var skybox:SkyBox;
      
      private var currCameraController:ICameraController;
      
      public var freeCameraController:FreeCameraController;
      
      public var followCameraController:FollowCameraController;
      
      private var stage:Stage;
      
      private var collisionFilter:Dictionary;
      
      private var visualPhysicsTree:Object3D;
      
      private var timeSystem:TimeSystem;
      
      private var physicsSystem:PhysicsSystem;
      
      private var config:Config;
      
      private var mapObjects:Vector.<Object3DContainer>;
      
      private var currMapObjectIndex:int;
      
      private var debugPanel:DebugPanel;
      
      private var tanksManager:TanksManager;
      
      public function RenderSystem(param1:Stage, param2:DebugPanel, param3:Config, param4:TanksManager)
      {
         this.collisionFilter = new Dictionary();
         super(SystemPriority.RENDER,SystemTags.RENDER);
         this.stage = param1;
         this.debugPanel = param2;
         this.config = param3;
         this.tanksManager = param4;
         this.scene3D = new Scene3D();
         this.viewport = new Viewport(this.scene3D.getCamera(),param2);
         param1.addChild(this.viewport);
         param1.addEventListener(Event.RESIZE,this.onResize);
         this.freeCameraController = new FreeCameraController(param1,this.scene3D.getCamera(),1000);
         this.freeCameraController.setObjectPosXYZ(3767.506103515625,-2806.43115234375,1313.4146728515625);
         this.freeCameraController.lookAtXYZ(0,0,0);
         this.setCameraController(this.freeCameraController);
         param1.addChild(this.scene3D.getCamera().diagram);
         this.onResize(null);
         this.keyboardListener = new KeyboardListener(param1);
         this.keyboardListener.addHandler(Keyboard.N,this.toggleOOBBResolving);
      }
      
      override public function onStart() : void
      {
         this.timeSystem = TimeSystem(taskManager.getTaskByTag(SystemTags.TIME));
         this.physicsSystem = PhysicsSystem(taskManager.getTaskByTag(SystemTags.PHYSICS));
         this.followCameraController = new FollowCameraController(this.stage,this.physicsSystem.getCollisionDetector(),this.scene3D.getCamera(),1 << 4,this.scene3D.getMap(),this.collisionFilter);
         this.visualPhysicsTree = new VisualPhysicsKDTree(this.physicsSystem.getCollisionDetector().tree);
         this.visualPhysicsTree.visible = false;
         this.scene3D.getFrontContainer().addChild(this.visualPhysicsTree);
         this.initMap();
      }
      
      override public function run() : void
      {
         this.scene3D.update(this.timeSystem.time,this.timeSystem.deltaTimeMs);
         this.viewport.update();
      }
      
      private function onResize(param1:Event) : void
      {
         this.viewport.resize(this.stage.stageWidth,this.stage.stageHeight);
      }
      
      private function setCameraController(param1:ICameraController) : void
      {
         this.currCameraController = param1;
         this.scene3D.setCameraController(param1);
      }
      
      private function initMap() : void
      {
         this.skybox = this.createSkyBox();
         this.scene3D.setSkyBox(this.skybox);
         this.mapObjects = Vector.<Object3DContainer>([this.config.map.mapContainer,this.config.map.collisionTree]);
         this.followCameraController.collisionObject = this.config.map.mapContainer;
         this.setMapObject(0);
         this.toggleAABBResolving();
         this.toggleOOBBResolving();
      }
      
      private function createSkyBox() : SkyBox
      {
         var _loc1_:TextureMaterial = new TextureMaterial(this.config.textureLibrary.getTexture("skybox_1"));
         var _loc2_:TextureMaterial = new TextureMaterial(this.config.textureLibrary.getTexture("skybox_2"));
         var _loc3_:TextureMaterial = new TextureMaterial(this.config.textureLibrary.getTexture("skybox_3"));
         var _loc4_:TextureMaterial = new TextureMaterial(this.config.textureLibrary.getTexture("skybox_4"));
         var _loc5_:TextureMaterial = new TextureMaterial(this.config.textureLibrary.getTexture("skybox_5"));
         var _loc6_:TextureMaterial = new TextureMaterial(this.config.textureLibrary.getTexture("skybox_6"));
         var _loc7_:* = 200000;
         return new SkyBox(_loc7_,_loc3_,_loc1_,_loc2_,_loc4_,_loc6_,_loc5_);
      }
      
      public function toggleSkyBox() : void
      {
         this.skybox.visible = !this.skybox.visible;
      }
      
      public function toggleGraphicsDebugMode() : void
      {
         this.scene3D.toggleDebugMode();
      }
      
      public function setNextMapObject() : void
      {
         this.setMapObject((this.currMapObjectIndex + 1) % this.mapObjects.length);
      }
      
      private function setMapObject(param1:int) : void
      {
         this.currMapObjectIndex = int(param1);
         this.scene3D.setMapObject(this.mapObjects[this.currMapObjectIndex]);
      }
      
      public function toggleWireTree() : void
      {
         this.visualPhysicsTree.visible = !this.visualPhysicsTree.visible;
      }
      
      public function toggleAABBResolving() : void
      {
         this.debugPanel.printText("TanksTestingTool [ruslan_g02 mod]");
      }
      
      public function toggleOOBBResolving() : void
      {
         this.tanksManager.setColorForCurrentTank("Dead");
      }
      
      public function addTankToCollisionFilter(param1:Tank) : void
      {
         this.collisionFilter[param1.skin.hullMesh] = true;
         this.collisionFilter[param1.skin.turretMesh] = true;
      }
      
      public function removeTankFromCollisionFilter(param1:Tank) : void
      {
         delete this.collisionFilter[param1.skin.hullMesh];
         true;
         true;
         true;
         true;
         true;
         delete this.collisionFilter[param1.skin.turretMesh];
         true;
         true;
         true;
         true;
         true;
      }
      
      public function toggleCameraController() : void
      {
         if(this.currCameraController is FreeCameraController)
         {
            if(this.tanksManager.numTanks() > 0)
            {
               this.followCameraController.setTarget(this.tanksManager.currentTank());
               this.followCameraController.initCameraComponents();
               this.followCameraController.activate();
               this.setCameraController(this.followCameraController);
               this.viewport.debugPanel.printValue("Режим камеры","следующий");
            }
         }
         else
         {
            this.followCameraController.deactivate();
            this.followCameraController.setTarget(null);
            this.freeCameraController.updateObjectTransform();
            this.setCameraController(this.freeCameraController);
            this.viewport.debugPanel.printValue("Режим камеры","свободный");
         }
      }
   }
}
