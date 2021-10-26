package alternativa.tanks.animations
{
   public class KeyFrameAnimation
   {
       
      
      private var track:AnimationTrack;
      
      private var currentFrame:int;
      
      private var time:Number;
      
      private var animatedValue:AnimatedValue;
      
      public function KeyFrameAnimation(track:AnimationTrack, animatedValue:AnimatedValue)
      {
         super();
         this.track = track;
         this.animatedValue = animatedValue;
      }
      
      public function start() : void
      {
         this.time = this.track.getMinTime();
         this.currentFrame = 0;
      }
      
      public function isComplete() : Boolean
      {
         return this.currentFrame == this.track.getNumFrames() - 1;
      }
      
      public function update(dt:Number) : void
      {
         if(!this.isComplete())
         {
            this.time += dt;
            while(this.time > this.track.getFrameTime(this.currentFrame + 1))
            {
               ++this.currentFrame;
               if(this.isComplete())
               {
                  this.time = this.track.getMaxTime();
                  break;
               }
            }
            this.animatedValue.setAnimatedValue(this.getValue());
         }
      }
      
      private function getValue() : Number
      {
         var t1:Number = NaN;
         var t2:Number = NaN;
         var a:Number = NaN;
         var b:Number = NaN;
         if(this.isComplete())
         {
            return this.track.getFrameTime(this.currentFrame);
         }
         t1 = this.track.getFrameTime(this.currentFrame);
         t2 = this.track.getFrameTime(this.currentFrame + 1);
         a = this.track.getFrameValue(this.currentFrame);
         b = this.track.getFrameValue(this.currentFrame + 1);
         return a + (b - a) * (this.time - t1) / (t2 - t1);
      }
   }
}
