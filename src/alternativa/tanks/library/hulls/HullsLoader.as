package alternativa.tanks.library.hulls
{
   public class HullsLoader
   {
       
      
      private var callback:Function;
      
      private var processes:Object;
      
      public function HullsLoader(callback:Function)
      {
         this.processes = {};
         super();
         this.callback = callback;
      }
      
      public function load(descriptor:HullDescriptor, callback:Function) : void
      {
         var process:HullLoaderProcess = this.getOrCreateProcess(descriptor);
         process.addListener(callback);
      }
      
      private function getOrCreateProcess(descriptor:HullDescriptor) : HullLoaderProcess
      {
         var process:HullLoaderProcess = this.processes[descriptor.id];
         if(process == null)
         {
            process = new HullLoaderProcess(descriptor,this.onHullReady);
            this.processes[descriptor.id] = process;
         }
         return process;
      }
      
      private function onHullReady(process:HullLoaderProcess) : void
      {
         delete this.processes[process.getHullId()];
         this.callback(process.getHullId(),process.getHull());
         process.notifyListeners();
      }
   }
}
