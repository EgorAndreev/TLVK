package alternativa.tanks.config
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.primitives.Box;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.tanks.SpawnPoint;
   import alternativa.tanks.Triangle;
   import alternativa.tanks.config.loaders.MapLoader;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   public class TanksMap extends ResourceLoader
   {
       
      
      public var mapContainer:KDContainer;
      
      public var collisionTree:KDContainer;
      
      private var loader:MapLoader;
      
      private var spawnMarkers:Object;
      
      private var ctfFlags:Object;
      
      public function TanksMap(config:Config)
      {
         this.spawnMarkers = {};
         this.ctfFlags = {};
         super("Tank map loader",config);
      }
      
      override public function run() : void
      {
         if(config.xml.map.length() == 0)
         {
            throw new Error("No map found");
         }
         this.loader = new MapLoader();
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.load(config.xml.map.@url,config.propLibRegistry);
      }
      
      public function getSpawnPoints(type:String) : Vector.<SpawnPoint>
      {
         return this.loader.getSpawnPoints(type);
      }
      
      public function get collisionPrimitives() : Vector.<CollisionPrimitive>
      {
         return this.loader.collisionPrimitives;
      }
      
      public function showSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(!visible)
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      public function hideSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(visible)
            {
               this.mapContainer.removeChild(marker);
            }
         }
      }
      
      public function toggleSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(visible)
            {
               this.mapContainer.removeChild(marker);
            }
            else
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      public function showCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null && marker.parent == null)
         {
            this.mapContainer.addChild(marker);
         }
      }
      
      public function hideCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null && marker.parent != null)
         {
            this.mapContainer.removeChild(marker);
         }
      }
      
      public function toggleCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null)
         {
            if(marker.parent != null)
            {
               this.mapContainer.removeChild(marker);
            }
            else
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      private function getCTFFlagMarker(type:String) : Sprite3D
      {
         var pos:Vector3D = null;
         var texture:BitmapData = null;
         var sprite:Sprite3D = this.ctfFlags[type];
         if(sprite == null)
         {
            pos = this.loader.getFlagPosition(type);
            if(pos == null)
            {
               return null;
            }
            texture = config.textureLibrary.getTexture(type + "_flag");
            sprite = new Sprite3D(texture.width,texture.height);
            sprite.originX = 0;
            sprite.originY = 1;
            sprite.clipping = Clipping.FACE_CLIPPING;
            sprite.material = new TextureMaterial(texture);
            sprite.x = pos.x;
            sprite.y = pos.y;
            sprite.z = pos.z;
            this.ctfFlags[type] = sprite;
         }
         return sprite;
      }
      
      private function getSpawnMarkers(type:String) : Vector.<Object3D>
      {
         var texture:BitmapData = null;
         var textureMaterial:TextureMaterial = null;
         var spawnPoints:Vector.<SpawnPoint> = null;
         var sp:SpawnPoint = null;
         var sprite:Sprite3D = null;
         var spawnMarkersData:SpawnMarkersData = this.spawnMarkers[type];
         if(spawnMarkersData == null)
         {
            spawnMarkersData = new SpawnMarkersData();
            texture = config.textureLibrary.getTexture(type + "_spawn_marker");
            textureMaterial = new TextureMaterial(texture);
            spawnMarkersData.markers = new Vector.<Object3D>();
            spawnPoints = this.loader.getSpawnPoints(type);
            for each(sp in spawnPoints)
            {
               sprite = new Sprite3D(texture.width,texture.height);
               sprite.originY = 1;
               sprite.clipping = Clipping.FACE_CLIPPING;
               sprite.material = textureMaterial;
               sprite.x = sp.position.x;
               sprite.y = sp.position.y;
               sprite.z = sp.position.z;
               spawnMarkersData.markers.push(sprite);
            }
            this.spawnMarkers[type] = spawnMarkersData;
         }
         return spawnMarkersData.markers;
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         var sprite:Sprite3D = null;
         var collisionGeometry:Vector.<Object3D> = null;
         var boxMaterial:TextureMaterial = null;
         var planeMaterial:TextureMaterial = null;
         var triangleMaterial:TextureMaterial = null;
         var object:Object3D = null;
         var material:Material = null;
         var mesh:Mesh = null;
         trace("Map loading completed");
         this.mapContainer = this.createKDContainer(this.loader.objects,this.loader.occluders);
         this.mapContainer.name = "Visual Kd-tree";
         for each(sprite in this.loader.sprites)
         {
            this.mapContainer.addChild(sprite);
         }
         collisionGeometry = this.loader.visualCollisionObjects;
         boxMaterial = new TextureMaterial(config.textureLibrary.getTexture("red_square"));
         planeMaterial = new TextureMaterial(config.textureLibrary.getTexture("green_square"));
         triangleMaterial = new TextureMaterial(config.textureLibrary.getTexture("teal_triangle"));
         for each(object in collisionGeometry)
         {
            material = null;
            if(object is Box)
            {
               material = boxMaterial;
            }
            else if(object is Plane)
            {
               material = planeMaterial;
            }
            else if(object is Triangle)
            {
               material = triangleMaterial;
            }
            mesh = Mesh(object);
            mesh.setMaterialToAllFaces(material);
            mesh.sorting = Sorting.DYNAMIC_BSP;
            mesh.calculateBounds();
            mesh.calculateFacesNormals();
         }
         this.collisionTree = this.createKDContainer(collisionGeometry,null);
         this.collisionTree.name = "Collision Kd-tree";
         trace("Collision visual Kd-tree is ready");
         completeTask();
      }
      
      private function createKDContainer(objects:Vector.<Object3D>, occluders:Vector.<Occluder>) : KDContainer
      {
         var container:KDContainer = new KDContainer();
         container.createTree(objects,occluders);
         return container;
      }
   }
}

import alternativa.engine3d.core.Object3D;

class SpawnMarkersData
{
    
   
   public var markers:Vector.<Object3D>;
   
   function SpawnMarkersData()
   {
      super();
   }
}
