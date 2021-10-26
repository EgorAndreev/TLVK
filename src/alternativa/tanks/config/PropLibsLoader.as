package alternativa.tanks.config
{
   import alternativa.proplib.PropLibRegistry;
   import alternativa.utils.TaskSequence;
   import flash.events.Event;
   
   public class PropLibsLoader extends ResourceLoader
   {
       
      
      private var libRegistry:PropLibRegistry;
      
      private var sequence:TaskSequence;
      
      public function PropLibsLoader(config:Config)
      {
         this.libRegistry = new PropLibRegistry();
         super("Props library loader",config);
      }
      
      override public function run() : void
      {
         var libXml:XML = null;
         this.sequence = new TaskSequence();
         var proplibsXml:XML = config.xml.proplibs[0];
         for each(libXml in proplibsXml.proplib)
         {
            this.sequence.addTask(new PropLibLoadingTask(libXml.@url,this.libRegistry));
         }
         this.sequence.addEventListener(Event.COMPLETE,this.onProplobsLoadingComplete);
         this.sequence.run();
      }
      
      private function onProplobsLoadingComplete(e:Event) : void
      {
         this.sequence = null;
         config.propLibRegistry = this.libRegistry;
         completeTask();
      }
   }
}

import alternativa.proplib.PropLibRegistry;
import alternativa.proplib.PropLibrary;
import alternativa.utils.ByteArrayMap;
import alternativa.utils.TARAParser;
import alternativa.utils.Task;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

class PropLibLoadingTask extends Task
{
    
   
   private var url:String;
   
   private var libRegistry:PropLibRegistry;
   
   private var loader:URLLoader;
   
   function PropLibLoadingTask(url:String, libRegistry:PropLibRegistry)
   {
      super();
      this.url = url;
      this.libRegistry = libRegistry;
   }
   
   override public function run() : void
   {
      this.loader = new URLLoader();
      this.loader.dataFormat = URLLoaderDataFormat.BINARY;
      this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
      this.loader.load(new URLRequest(this.url));
   }
   
   private function onLoadingComplete(event:Event) : void
   {
      var propLibrary:PropLibrary = new PropLibrary(new ByteArrayMap(TARAParser.parse(this.loader.data)));
      this.libRegistry.addLibrary(propLibrary);
      completeTask();
   }
}
