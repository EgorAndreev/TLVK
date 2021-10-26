package alternativa.tanks.taskmanager
{
   public class TagAlreadyExistsError extends Error
   {
       
      
      public function TagAlreadyExistsError(tag:String)
      {
         super("Tag already exists: " + tag);
      }
   }
}
