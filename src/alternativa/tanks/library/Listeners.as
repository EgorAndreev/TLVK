package alternativa.tanks.library
{
   public class Listeners
   {
       
      
      private var listeners:Vector.<Function>;
      
      public function Listeners()
      {
         this.listeners = new Vector.<Function>();
         super();
      }
      
      public function add(listener:Function) : void
      {
         if(this.listeners.indexOf(listener) < 0)
         {
            this.listeners.push(listener);
         }
      }
      
      public function notify(argument:Object) : void
      {
         var listener:Function = null;
         for each(listener in this.listeners)
         {
            try
            {
               listener(argument);
            }
            catch(e:Error)
            {
               trace(e.message,e.getStackTrace());
            }
         }
      }
   }
}
