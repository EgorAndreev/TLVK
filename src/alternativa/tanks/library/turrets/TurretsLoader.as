package alternativa.tanks.library.turrets
{
   public class TurretsLoader
   {
       
      
      private var callback:Function;
      
      private var processes:Object;
      
      public function TurretsLoader(callback:Function)
      {
         this.processes = {};
         super();
         this.callback = callback;
      }
      
      public function load(descriptor:TurretDescriptor, callback:Function) : void
      {
         var process:TurretLoadingProcess = this.getOrCreateProcess(descriptor);
         process.addListener(callback);
      }
      
      private function getOrCreateProcess(descriptor:TurretDescriptor) : TurretLoadingProcess
      {
         var process:TurretLoadingProcess = this.processes[descriptor.id];
         if(process == null)
         {
            process = new TurretLoadingProcess(descriptor,this.onProcessComplete);
            this.processes[descriptor.id] = process;
         }
         return process;
      }
      
      private function onProcessComplete(process:TurretLoadingProcess) : void
      {
         delete this.processes[process.getTurretId()];
         this.callback(process.getTurretId(),process.getTurret());
         process.notifyListeners();
      }
   }
}
