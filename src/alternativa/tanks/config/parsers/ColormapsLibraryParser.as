package alternativa.tanks.config.parsers
{
   import alternativa.tanks.config.Config;
   import alternativa.tanks.library.colormaps.ColormapDescriptor;
   import alternativa.tanks.library.colormaps.ColormapsLibrary;
   import alternativa.utils.Task;
   import flash.utils.setTimeout;
   
   public class ColormapsLibraryParser extends Task
   {
       
      
      private var config:Config;
      
      private var basePath:String;
      
      private var colormapDescriptors:Vector.<ColormapDescriptor>;
      
      public function ColormapsLibraryParser(config:Config)
      {
         super();
         this.config = config;
      }
      
      override public function run() : void
      {
         this.parseBaseUrl();
         this.parseColormaps();
         this.complete();
      }
      
      private function parseBaseUrl() : void
      {
         this.basePath = this.getColormapsXml().@path;
      }
      
      private function getColormapsXml() : XML
      {
         return this.config.xml.colormaps[0];
      }
      
      private function parseColormaps() : void
      {
         var colormapXml:XML = null;
         this.colormapDescriptors = new Vector.<ColormapDescriptor>();
         for each(colormapXml in this.getColormapsXml().colormap)
         {
            this.colormapDescriptors.push(this.parseColormap(colormapXml));
         }
      }
      
      private function parseColormap(colormapXml:XML) : ColormapDescriptor
      {
         var id:String = colormapXml.@id;
         var fileUrl:String = this.makeFullPath(colormapXml.@file);
         return new ColormapDescriptor(id,fileUrl);
      }
      
      private function makeFullPath(fileName:String) : String
      {
         return this.basePath + "/" + fileName;
      }
      
      private function complete() : void
      {
         this.config.colormapsLibrary = new ColormapsLibrary(this.colormapDescriptors);
         setTimeout(completeTask,0);
      }
   }
}
