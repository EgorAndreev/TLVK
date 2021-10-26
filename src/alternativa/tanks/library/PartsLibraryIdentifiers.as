package alternativa.tanks.library
{
   public class PartsLibraryIdentifiers implements LibraryIterator
   {
       
      
      private var ids:Vector.<String>;
      
      private var index:int;
      
      public function PartsLibraryIdentifiers(ids:Vector.<String>)
      {
         super();
         this.ids = ids;
      }
      
      public function next() : String
      {
         this.index = (this.index + 1) % this.ids.length;
         return this.current();
      }
      
      public function prev() : String
      {
         --this.index;
         if(this.index < 0)
         {
            this.index = this.ids.length - 1;
         }
         return this.current();
      }
      
      public function current() : String
      {
         return this.ids[this.index];
      }
   }
}
