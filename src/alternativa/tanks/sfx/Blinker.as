package alternativa.tanks.sfx
{
   public class Blinker
   {
       
      
      private var initialInterval:int;
      
      private var minInterval:int;
      
      private var intervalDecrement:int;
      
      private var maxValue:Number;
      
      private var minValue:Number;
      
      private var speedCoeff:Number;
      
      private var value:Number;
      
      private var _speed:Number;
      
      private var valueDelta:Number;
      
      private var switchTime:int;
      
      private var currInterval:int;
      
      public function Blinker(initialInterval:int, minInterval:int, intervalDecrement:int, minValue:Number, maxValue:Number, speedCoeff:Number)
      {
         super();
         this.initialInterval = initialInterval;
         this.minInterval = minInterval;
         this.intervalDecrement = intervalDecrement;
         this.minValue = minValue;
         this.maxValue = maxValue;
         this.speedCoeff = speedCoeff;
         this.valueDelta = maxValue - minValue;
      }
      
      public function setInitialInterval(value:int) : void
      {
         this.initialInterval = value;
      }
      
      public function init(currentTimeMs:int) : void
      {
         this.value = this.maxValue;
         this.currInterval = this.initialInterval;
         this._speed = this.getSpeed(-1);
         this.switchTime = currentTimeMs + this.currInterval;
      }
      
      public function setMaxValue(value:Number) : void
      {
         if(value >= this.minValue)
         {
            this.maxValue = value;
            this.valueDelta = this.maxValue - this.minValue;
         }
      }
      
      public function setMinValue(value:Number) : void
      {
         if(value <= this.maxValue)
         {
            this.minValue = value;
            this.valueDelta = this.maxValue - this.minValue;
         }
      }
      
      public function getMinValue() : Number
      {
         return this.minValue;
      }
      
      public function updateValue(currentTimeMs:int, deltaTimeMs:int) : Number
      {
         this.value += this._speed * deltaTimeMs;
         if(this.value > this.maxValue)
         {
            this.value = this.maxValue;
         }
         if(this.value < this.minValue)
         {
            this.value = this.minValue;
         }
         if(currentTimeMs >= this.switchTime)
         {
            if(this.currInterval > this.minInterval)
            {
               this.currInterval -= this.intervalDecrement;
               if(this.currInterval < this.minInterval)
               {
                  this.currInterval = this.minInterval;
               }
            }
            this.switchTime = currentTimeMs + this.currInterval;
            if(this._speed < 0)
            {
               this._speed = this.getSpeed(1);
            }
            else
            {
               this._speed = this.getSpeed(-1);
            }
         }
         return this.value;
      }
      
      private function getSpeed(direction:Number) : Number
      {
         return direction * this.speedCoeff * this.valueDelta / this.currInterval;
      }
   }
}
