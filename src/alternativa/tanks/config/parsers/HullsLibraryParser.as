package alternativa.tanks.config.parsers
{
   import alternativa.tanks.config.Config;
   import alternativa.tanks.library.hulls.HullDescriptor;
   import alternativa.tanks.library.hulls.HullsLibrary;
   import alternativa.utils.Task;
   import flash.utils.setTimeout;
   
   public class HullsLibraryParser extends Task
   {
       
      
      private var config:Config;
      
      private var basePath:String;
      
      private var hullDescriptors:Vector.<HullDescriptor>;
      
      public function HullsLibraryParser(config:Config)
      {
         super();
         this.config = config;
      }
      
      override public function run() : void
      {
         this.parseBasePath();
         this.parseHulls();
         this.complete();
      }
      
      private function parseBasePath() : void
      {
         this.basePath = this.getHullsXml().@path;
      }
      
      private function getHullsXml() : XML
      {
         return this.config.xml.hulls[0];
      }
      
      private function parseHulls() : void
      {
         var hullXml:XML = null;
         this.hullDescriptors = new Vector.<HullDescriptor>();
         for each(hullXml in this.getHullsXml().hull)
         {
            this.hullDescriptors.push(this.parseHull(hullXml));
         }
      }
      
      private function parseHull(hullXml:XML) : HullDescriptor
      {
         var id:String = hullXml.@id;
         var hullPath:String = hullXml.@path;
         var modelUrl:String = this.makeUrl(hullPath,hullXml.model.@file);
         var detailsUrl:String = this.makeUrl(hullPath,hullXml.model.@details);
         var lightmapUrl:String = this.makeUrl(hullPath,hullXml.model.@lightmap);
         var shadowTextureUrl:String = this.getShadowTextureUrl(hullPath,hullXml.model.@shadow);
         return new HullDescriptor(id,modelUrl,detailsUrl,lightmapUrl,shadowTextureUrl);
      }
      
      private function getShadowTextureUrl(hullPath:String, shadowTextureName:String) : String
      {
         if(shadowTextureName)
         {
            return this.makeUrl(hullPath,shadowTextureName);
         }
         return "";
      }
      
      private function makeUrl(hullPath:String, fileName:String) : String
      {
         return this.basePath + "/" + hullPath + "/" + fileName;
      }
      
      private function complete() : void
      {
         this.config.hullsLibrary = new HullsLibrary(this.hullDescriptors);
         setTimeout(completeTask,0);
      }
   }
}
