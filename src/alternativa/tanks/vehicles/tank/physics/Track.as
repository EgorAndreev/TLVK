package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.math.Vector3;
   
   public class Track
   {
       
      
      public var _chassis:Chassis;
      
      public var _rays:Vector.<SuspensionRay>;
      
      public var _numRays:int;
      
      public var _numContacts:int;
      
      public var _rayRestLength:Number;
      
      public var _rayWorkLength:Number;
      
      private var speed:Number = 0;
      
      public function Track(chassis:Chassis, relativePosition:Vector3, trackLength:Number, collisionGroup:int)
      {
         var rayPosition:Vector3 = null;
         super();
         this._chassis = chassis;
         this._numRays = 5;
         this._rays = new Vector.<SuspensionRay>(this._numRays);
         var rayDirection:Vector3 = Vector3.DOWN.clone();
         var step:Number = trackLength / (this._numRays - 1);
         for(var i:int = 0; i < this._numRays; i++)
         {
            rayPosition = relativePosition.clone();
            rayPosition.y += 0.5 * trackLength - i * step;
            this._rays[i] = new SuspensionRay(this,rayPosition,rayDirection,collisionGroup);
         }
      }
      
      public function setRayLengths(restLength:Number, workLength:Number) : void
      {
         this._rayRestLength = restLength;
         this._rayWorkLength = workLength;
      }
      
      public function set collisionGroup(value:int) : void
      {
         var suspensionRay:SuspensionRay = null;
         for each(suspensionRay in this._rays)
         {
            suspensionRay.collisionGroup = value;
         }
      }
      
      public function updateControls(moveDirection:int, turnDirection:int) : void
      {
         var ray:SuspensionRay = null;
         for(var i:int = 0; i < this._numRays; i++)
         {
            ray = this._rays[i];
            ray.updateCachedValues(i,this._numRays);
         }
      }
      
      public function addForces(dt:Number, weight:Number, power:Number) : void
      {
         var ray:SuspensionRay = null;
         var springCoeff:Number = NaN;
         var ray2:SuspensionRay = null;
         this._numContacts = 0;
         for each(ray in this._rays)
         {
            if(ray.calculateIntersection())
            {
               ++this._numContacts;
            }
         }
         if(this._numContacts > 0)
         {
            this.speed = 0;
            springCoeff = 0.5 * weight / (this._numRays * (this._rayRestLength - this._rayWorkLength));
            for each(ray2 in this._rays)
            {
               ray2.addForce(dt,springCoeff,power);
               if(Math.abs(this.speed) < Math.abs(ray2.speed))
               {
                  this.speed = ray2.speed;
               }
            }
         }
         else
         {
            this.speed *= 0.98;
         }
      }
      
      public function getSpeed() : Number
      {
         return this.speed;
      }
   }
}
