package alternativa.tanks.config.parsers
{
   import alternativa.tanks.config.Config;
   import alternativa.tanks.library.turrets.TurretDescriptor;
   import alternativa.tanks.library.turrets.TurretsLibrary;
   import alternativa.utils.Task;
   import flash.utils.setTimeout;
   
   public class TurretsLibraryParser extends Task
   {
       
      
      private var config:Config;
      
      private var basePath:String;
      
      private var turretDescriptors:Vector.<TurretDescriptor>;
      
      public function TurretsLibraryParser(config:Config)
      {
         super();
         this.config = config;
      }
      
      override public function run() : void
      {
         this.parseBasePath();
         this.parseTurrets();
         this.complete();
      }
      
      private function parseBasePath() : void
      {
         this.basePath = this.getTurretsXml().@path;
      }
      
      private function getTurretsXml() : XML
      {
         return this.config.xml.turrets[0];
      }
      
      private function parseTurrets() : void
      {
         var turretXml:XML = null;
         this.turretDescriptors = new Vector.<TurretDescriptor>();
         for each(turretXml in this.getTurretsXml().turret)
         {
            this.turretDescriptors.push(this.parseTurret(turretXml));
         }
      }
      
      private function parseTurret(turretXml:XML) : TurretDescriptor
      {
         var id:String = turretXml.@id;
         var hullPath:String = turretXml.@path;
         var modelUrl:String = this.makeUrl(hullPath,turretXml.model.@file);
         var detailsUrl:String = this.makeUrl(hullPath,turretXml.model.@details);
         var lightmapUrl:String = this.makeUrl(hullPath,turretXml.model.@lightmap);
         return new TurretDescriptor(id,modelUrl,detailsUrl,lightmapUrl);
      }
      
      private function complete() : void
      {
         this.config.turretsLibrary = new TurretsLibrary(this.turretDescriptors);
         setTimeout(completeTask,0);
      }
      
      private function makeUrl(hullPath:String, fileName:String) : String
      {
         return this.basePath + "/" + hullPath + "/" + fileName;
      }
   }
}
