package alternativa.tanks.library.colormaps
{
   class ColormapsLoader
   {
       
      
      private var mainCallback:Function;
      
      private var processes:Object;
      
      function ColormapsLoader(mainCallback:Function)
      {
         this.processes = {};
         super();
         this.mainCallback = mainCallback;
      }
      
      function load(descriptor:ColormapDescriptor, callback:Function) : void
      {
         var process:ColormapLoaderProcess = this.getOrCreateProcess(descriptor);
         process.addListener(callback);
      }
      
      private function getOrCreateProcess(descriptor:ColormapDescriptor) : ColormapLoaderProcess
      {
         var process:ColormapLoaderProcess = this.processes[descriptor.id];
         if(process == null)
         {
            process = new ColormapLoaderProcess(descriptor,this.onLoaderProcessComplete);
            this.processes[descriptor.id] = process;
         }
         return process;
      }
      
      private function onLoaderProcessComplete(process:ColormapLoaderProcess) : void
      {
         delete this.processes[process.getColormapId()];
         this.mainCallback(process.getColormapId(),process.getBitmapData());
         process.notifyListeners();
      }
   }
}
