package alternativa.tanks.taskmanager
{
   public class TagNotFoundError extends Error
   {
       
      
      public function TagNotFoundError(tag:String)
      {
         super("Tag not found: " + tag);
      }
   }
}
