package alternativa.tanks.systems.gameobjectssystem
{
   import alternativa.tanks.systems.SystemPriority;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.physicssystem.PhysicsSystem;
   import alternativa.tanks.systems.timesystem.TimeSystem;
   import alternativa.tanks.taskmanager.GameTask;
   import alternativa.tanks.utils.GOList;
   import alternativa.tanks.utils.GOListItem;
   
   public class GameObjectsSystem extends GameTask
   {
       
      
      private var timeSystem:TimeSystem;
      
      private var physicsSystem:PhysicsSystem;
      
      private var gameObjects:GOList;
      
      public function GameObjectsSystem(objects:GOList)
      {
         super(SystemPriority.OBJECTS,SystemTags.OBJECTS);
         this.gameObjects = objects;
      }
      
      override public function onStart() : void
      {
         this.timeSystem = TimeSystem(taskManager.getTaskByTag(SystemTags.TIME));
         this.physicsSystem = PhysicsSystem(taskManager.getTaskByTag(SystemTags.PHYSICS));
      }
      
      override public function run() : void
      {
         var goListItem:GOListItem = this.gameObjects.head;
         while(goListItem != null)
         {
            goListItem.gameObject.update(this.timeSystem.time,this.timeSystem.deltaTimeMs,this.timeSystem.deltaTime,this.physicsSystem.interpolationCoefficient);
            goListItem = goListItem.next;
         }
      }
   }
}
