package alternativa.tanks.config.parsers
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.config.TextureAnimations;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.UVFrame;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.utils.Task;
   import flash.display.BitmapData;
   import flash.utils.setTimeout;
   
   public class TextureAnimationsParser extends Task
   {
       
      
      private var config:Config;
      
      private var textureAnimations:Object;
      
      public function TextureAnimationsParser(config:Config)
      {
         this.textureAnimations = {};
         super();
         this.config = config;
      }
      
      override public function run() : void
      {
         var textureAnimationXml:XML = null;
         for each(textureAnimationXml in this.config.xml.textureAnimations.animation)
         {
            this.parseTextureAnimation(textureAnimationXml);
         }
         setTimeout(this.complete,0);
      }
      
      private function parseTextureAnimation(textureAnimationXml:XML) : void
      {
         var animationId:String = textureAnimationXml.@id;
         var textureId:String = textureAnimationXml.textureId;
         var frameWidth:int = int(textureAnimationXml.frameWidth);
         var frameHeight:int = int(textureAnimationXml.frameHeight);
         var numFrames:int = int(textureAnimationXml.numFrames);
         var fps:Number = Number(textureAnimationXml.fps);
         var texture:BitmapData = this.config.textureLibrary.getTexture(textureId);
         if(frameWidth <= 0)
         {
            frameWidth = texture.height;
         }
         if(frameHeight <= 0)
         {
            frameHeight = texture.height;
         }
         var frames:Vector.<UVFrame> = GraphicsUtils.getUVFramesFromTexture(texture,frameWidth,frameHeight,numFrames);
         if(textureAnimationXml.@mirror == "true")
         {
            this.addMirroredFrames(frames);
         }
         this.textureAnimations[animationId] = new TextureAnimation(animationId,new TextureMaterial(texture),frames,fps);
      }
      
      private function addMirroredFrames(frames:Vector.<UVFrame>) : void
      {
         var frame:UVFrame = null;
         var num:int = frames.length;
         for(var i:int = 0; i < num; i++)
         {
            frame = frames[i];
            frames.push(new UVFrame(frame.bottomRightU,frame.topLeftV,frame.topLeftU,frame.bottomRightV));
         }
      }
      
      private function complete() : void
      {
         this.config.textureAnimations = new TextureAnimations(this.textureAnimations);
         completeTask();
      }
   }
}
