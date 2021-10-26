package alternativa.tanks.systems.objectcontrollers
{
   import alternativa.tanks.IGameObjectController;
   import alternativa.tanks.systems.SystemTags;
   import alternativa.tanks.systems.timesystem.TimeSystem;
   import alternativa.tanks.taskmanager.GameTask;
   import alternativa.tanks.utils.GOList;
   import alternativa.tanks.utils.GOListItem;
   
   public class ObjectControllersSystem extends GameTask
   {
       
      
      private var timeSystem:TimeSystem;
      
      private var gameObjects:GOList;
      
      public function ObjectControllersSystem(priority:int, tag:String, gameObjects:GOList)
      {
         super(priority,tag);
         this.gameObjects = gameObjects;
      }
      
      override public function onStart() : void
      {
         this.timeSystem = TimeSystem(taskManager.getTaskByTag(SystemTags.TIME));
      }
      
      override public function run() : void
      {
         var controller:IGameObjectController = null;
         var goListItem:GOListItem = this.gameObjects.head;
         while(goListItem != null)
         {
            controller = goListItem.gameObject.controller;
            if(controller != null)
            {
               controller.update(goListItem.gameObject,this.timeSystem.time,this.timeSystem.deltaTimeMs,this.timeSystem.deltaTime);
            }
            goListItem = goListItem.next;
         }
      }
   }
}
