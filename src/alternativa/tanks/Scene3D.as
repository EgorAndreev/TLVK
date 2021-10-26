package alternativa.tanks
{
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.primitives.Box;
   import alternativa.math.Vector3;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.display.GameCamera;
   import alternativa.tanks.display.ICameraController;
   import alternativa.tanks.sfx.GraphicEffect;
   
   public class Scene3D implements BattleScene3D
   {
       
      
      private const rootContainer:Object3DContainer = new Object3DContainer();
      
      private var skyBoxContainer:Object3DContainer;
      
      private var mapContainer:Object3DContainer;
      
      private var frontContainer:Object3DContainer;
      
      private var camera:GameCamera;
      
      private var skyBox:Object3D;
      
      private var map:Object3DContainer;
      
      public const renderers:Renderers = new Renderers();
      
      private var graphicEffects:Vector.<GraphicEffect>;
      
      private var cameraController:ICameraController;
      
      public function Scene3D()
      {
         this.graphicEffects = new Vector.<GraphicEffect>();
         super();
         this.skyBoxContainer = new Object3DContainer();
         this.rootContainer.addChild(this.skyBoxContainer);
         this.mapContainer = new Object3DContainer();
         this.rootContainer.addChild(this.mapContainer);
         this.frontContainer = new Object3DContainer();
         this.rootContainer.addChild(this.frontContainer);
         this.camera = new GameCamera();
         this.camera.nearClipping = 40;
         this.camera.farClipping = 200000;
         this.camera.addToDebug(Debug.BOUNDS,Object3D);
         this.camera.addToDebug(Debug.EDGES,Object3D);
         this.rootContainer.addChild(this.camera);
      }
      
      public function setCameraController(controller:ICameraController) : void
      {
         this.cameraController = controller;
      }
      
      public function addRenderer(renderer:Renderer, groupIndex:int) : void
      {
         this.renderers.add(renderer);
      }
      
      public function removeRenderer(renderer:Renderer, groupIndex:int) : void
      {
         this.renderers.remove(renderer);
      }
      
      public function addObject(object:Object3D) : void
      {
         this.map.addChild(object);
      }
      
      public function removeObject(object:Object3D) : void
      {
         this.map.removeChild(object);
      }
      
      public function getCamera() : GameCamera
      {
         return this.camera;
      }
      
      public function addShadow(shadow:Shadow) : void
      {
         this.camera.addShadow(shadow);
      }
      
      public function removeShadow(shadow:Shadow) : void
      {
         this.camera.removeShadow(shadow);
      }
      
      public function setSkyBox(skyBox:Object3D) : void
      {
         this.removeSkyBox();
         this.skyBox = skyBox;
         this.skyBoxContainer.addChild(skyBox);
      }
      
      private function removeSkyBox() : void
      {
         if(this.skyBox != null)
         {
            this.skyBoxContainer.removeChild(this.skyBox);
         }
      }
      
      public function toggleDebugMode() : void
      {
         this.camera.debug = !this.camera.debug;
      }
      
      public function setMapObject(map:Object3DContainer) : void
      {
         this.removeMap();
         this.map = map;
         this.mapContainer.addChild(map);
      }
      
      public function getMap() : Object3DContainer
      {
         return this.map;
      }
      
      public function getFrontContainer() : Object3DContainer
      {
         return this.frontContainer;
      }
      
      private function removeMap() : void
      {
         if(this.map != null)
         {
            this.mapContainer.removeChild(this.map);
         }
      }
      
      public function update(time:int, deltaTimeMs:int) : void
      {
         this.renderers.run(time,deltaTimeMs);
         this.updateCamera(time,deltaTimeMs);
         this.playEffects(deltaTimeMs);
      }
      
      private function updateCamera(time:int, deltaTimeMs:uint) : void
      {
         this.cameraController.updateCamera(time,deltaTimeMs,deltaTimeMs / 1000);
         this.camera.recalculate();
      }
      
      private function playEffects(deltaMs:uint) : void
      {
         var effect:GraphicEffect = null;
         var numEffects:int = this.graphicEffects.length;
         for(var i:int = 0; i < numEffects; i++)
         {
            effect = this.graphicEffects[i];
            if(!effect.play(deltaMs,this.camera))
            {
               effect.destroy();
               numEffects--;
               this.graphicEffects[i] = this.graphicEffects[numEffects];
               this.graphicEffects.length = numEffects;
               i--;
            }
         }
      }
      
      public function addGraphicEffect(effect:GraphicEffect) : void
      {
         if(this.graphicEffects.indexOf(effect) < 0)
         {
            this.graphicEffects.push(effect);
            effect.addedToScene(this.map);
         }
      }
      
      public function createBox(size:Number, color:uint, position:Vector3) : void
      {
         var box:Box = new Box(size,size,size);
         box.setMaterialToAllFaces(new FillMaterial(color,1,0,16777215));
         box.x = position.x;
         box.y = position.y;
         box.z = position.z;
         this.addObject(box);
      }
   }
}
