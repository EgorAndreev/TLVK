package alternativa.tanks.library
{
   public class MissedDescriptorError extends Error
   {
       
      
      public function MissedDescriptorError(id:String)
      {
         super("Missed descriptor: " + id);
      }
   }
}
