package
{
   import alternativa.tanks.Game;
   import alternativa.tanks.GameEvent;
   import alternativa.tanks.config.Config;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;

   public class TLVK extends Sprite
   {
       
      
      private var config:Config;
      
      private var game:Game;
      
      public function TLVK()
      {
         super();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.quality = StageQuality.HIGH;
         this.loadConfig("config.xml");
      }
      
      private function loadConfig(url:String) : void
      {
         this.config = new Config();
         this.config.addEventListener(Event.COMPLETE,this.onConfigLoadingComplete);
         this.config.load(url);
      }
      
      private function onConfigLoadingComplete(e:Event) : void
      {
         trace("Config loaded");
         this.game = new Game(this.config,stage);
         this.game.addEventListener(GameEvent.INIT_COMPLETE,this.onGameInitComplete);
      }
      
      private function onGameInitComplete(e:Event) : void
      {
         trace("Game init complete");
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(e:Event) : void
      {
         this.game.tick();
      }
      
      private function testMapping(n:int) : void
      {
         var c:int = 0;
         var m:int = 0;
         var i:int = 0;
         for(var r:int = 0; r < n; r++)
         {
            for(c = r + 1; c < n; c++)
            {
               m = this.mapping(r,c,n);
               trace(r,c,m);
               if(m != i++)
               {
                  throw new Error();
               }
            }
         }
      }
      
      private function mapping(r:int, c:int, n:int) : int
      {
         return r * (n - 1) - (r * (r + 1) >> 1) + c - 1;
      }
   }
}
