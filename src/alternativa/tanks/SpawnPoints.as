package alternativa.tanks
{
   import alternativa.tanks.objects.SpriteSpotMarker;
   import alternativa.tanks.utils.KeyboardListener;
   import flash.ui.Keyboard;
   
   public class SpawnPoints
   {
       
      
      private var groups:Vector.<SpawnPointsGroup>;
      
      private var currGroupIndex:int;
      
      private var game:Game;
      
      private var spawnMarker:SpriteSpotMarker;
      
      private var keboardListener:KeyboardListener;
      
      public function SpawnPoints(game:Game)
      {
         super();
         this.game = game;
         this.initKeyboardHandlers();
         this.addSpawnPoints("dm","Death Match");
         this.addSpawnPoints("red","Team Red");
         this.addSpawnPoints("blue","Team Blue");
      }
      
      private function addSpawnPoints(pointsType:String, groupName:String) : void
      {
         var points:Vector.<SpawnPoint> = this.game.config.map.getSpawnPoints(pointsType);
         if(points != null)
         {
            this.addSpawnPointsGroup(groupName,points);
         }
      }
      
      private function initKeyboardHandlers() : void
      {
         this.keboardListener = new KeyboardListener(this.game.stage);
         this.keboardListener.addHandler(Keyboard.T,this.selectNextPoint);
         this.keboardListener.addHandler(KeyboardListener.BIT_SHIFT | Keyboard.T,this.selectPrevPoint);
         this.keboardListener.addHandler(Keyboard.G,this.selectNextGroup);
         this.keboardListener.addHandler(KeyboardListener.BIT_SHIFT | Keyboard.G,this.selectPrevGroup);
      }
      
      public function showActiveSpawnMarker() : void
      {
         this.checkGroups();
         if(this.spawnMarker == null)
         {
            this.spawnMarker = new SpriteSpotMarker(GameObject.getId(),0.5,1,1,this.game.config.textureLibrary.getTexture("active_spawn_marker"));
            this.spawnMarker.position = this.currentPoint.position;
            this.game.addGameObject(this.spawnMarker);
         }
         this.spawnMarker.visible = true;
         this.updateSpawnMarker();
      }
      
      public function hideActiveSpawnMarker() : void
      {
         this.checkGroups();
         if(this.spawnMarker != null)
         {
            this.spawnMarker.visible = false;
         }
      }
      
      private function addSpawnPointsGroup(groupName:String, points:Vector.<SpawnPoint>) : void
      {
         if(this.groups == null)
         {
            this.groups = new Vector.<SpawnPointsGroup>();
         }
         this.groups.push(new SpawnPointsGroup(groupName,points));
      }
      
      public function selectNextGroup() : void
      {
         this.checkGroups();
         this.currGroupIndex = (this.currGroupIndex + 1) % this.groups.length;
         this.updateSpawnMarker();
      }
      
      public function selectPrevGroup() : void
      {
         this.checkGroups();
         --this.currGroupIndex;
         if(this.currGroupIndex < 0)
         {
            this.currGroupIndex = this.groups.length - 1;
         }
         this.updateSpawnMarker();
      }
      
      public function selectNextPoint() : void
      {
         this.checkGroups();
         var group:SpawnPointsGroup = this.groups[this.currGroupIndex];
         ++group.currPoint;
         if(group.currPoint > group.points.length - 1)
         {
            group.currPoint = 0;
         }
         this.updateSpawnMarker();
      }
      
      public function selectPrevPoint() : void
      {
         this.checkGroups();
         var group:SpawnPointsGroup = this.groups[this.currGroupIndex];
         --group.currPoint;
         if(group.currPoint < 0)
         {
            group.currPoint = group.points.length - 1;
         }
         this.updateSpawnMarker();
      }
      
      public function get currentPoint() : SpawnPoint
      {
         this.checkGroups();
         var group:SpawnPointsGroup = this.getCurrentGroup();
         return group.points[group.currPoint];
      }
      
      public function get currentGroupName() : String
      {
         this.checkGroups();
         return this.getCurrentGroup().groupName;
      }
      
      public function get currentGroupSize() : int
      {
         return this.getCurrentGroup().points.length;
      }
      
      private function getCurrentGroup() : SpawnPointsGroup
      {
         return this.groups[this.currGroupIndex];
      }
      
      private function checkGroups() : void
      {
         if(this.groups == null)
         {
            throw new Error("No groups found");
         }
      }
      
      private function updateSpawnMarker() : void
      {
         this.game.debugPanel.printValue("Current spawn group",this.currentGroupName);
         this.spawnMarker.position = this.currentPoint.position;
      }
   }
}

import alternativa.tanks.SpawnPoint;

class SpawnPointsGroup
{
    
   
   public var groupName:String;
   
   public var points:Vector.<SpawnPoint>;
   
   public var currPoint:int;
   
   function SpawnPointsGroup(groupName:String, points:Vector.<SpawnPoint>)
   {
      super();
      this.groupName = groupName;
      this.points = points;
   }
}
