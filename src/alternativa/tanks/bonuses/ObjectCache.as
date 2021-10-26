package alternativa.tanks.bonuses
{
   public class ObjectCache
   {
       
      
      private var size:int;
      
      private var objects:Vector.<Object>;
      
      public function ObjectCache()
      {
         this.objects = new Vector.<Object>();
         super();
      }
      
      public function put(object:Object) : void
      {
         var _loc2_:* = this.size++;
         this.objects[_loc2_] = object;
      }
      
      public function get() : Object
      {
         if(this.isEmpty())
         {
            throw new Error();
         }
         --this.size;
         var object:Object = this.objects[this.size];
         this.objects[this.size] = null;
         return object;
      }
      
      public function isEmpty() : Boolean
      {
         return this.size == 0;
      }
   }
}
