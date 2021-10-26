package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.tanks.Game;
   
   public class TankPhysicsData
   {
      
      public static var fields:Array = ["mass","springDamping","power","maxForwardSpeed","maxBackwardSpeed","maxTurnSpeed","drivingForceOffsetZ","smallVelocity","rayLength","dynamicFriction","brakeFriction","sideFriction","spotTurnPowerCoeff","spotTurnDynamicFriction","spotTurnSideFriction","moveTurnPowerCoeffInner","moveTurnPowerCoeffOuter","moveTurnDynamicFrictionInner","moveTurnDynamicFrictionOuter","moveTurnSideFriction","moveTurnSpeedCoeffInner","moveTurnSpeedCoeffOuter"];
       
      
      public var mass:Number = 6000;
      
      public var power:Number = 1000000;
      
      public var maxForwardSpeed:Number = 1500;
      
      public var maxBackwardSpeed:Number = 1500;
      
      public var maxTurnSpeed:Number = 0.5;
      
      public var springDamping:Number = 1000;
      
      public var drivingForceOffsetZ:Number = 0;
      
      public var smallVelocity:Number = 50;
      
      public var rayLength:Number = 50;
      
      public var dynamicFriction:Number = 0.05;
      
      public var brakeFriction:Number = 2;
      
      public var sideFriction:Number = 2;
      
      public var spotTurnPowerCoeff:Number = 1.9;
      
      public var spotTurnDynamicFriction:Number = 0.05;
      
      public var spotTurnSideFriction:Number = 1;
      
      public var moveTurnPowerCoeffOuter:Number = 1.17;
      
      public var moveTurnPowerCoeffInner:Number = 0.39;
      
      public var moveTurnDynamicFrictionInner:Number = 0.5;
      
      public var moveTurnDynamicFrictionOuter:Number = 0.05;
      
      public var moveTurnSideFriction:Number = 1;
      
      public var moveTurnSpeedCoeffInner:Number = 0.39;
      
      public var moveTurnSpeedCoeffOuter:Number = 1.17;
      
      public function TankPhysicsData()
      {
         this.maxTurnSpeed = 0.5;
         this.dynamicFriction = 0.05;
         this.spotTurnPowerCoeff = 1.9;
         this.spotTurnDynamicFriction = 0.05;
         this.moveTurnPowerCoeffOuter = 1.17;
         this.moveTurnPowerCoeffInner = 0.39;
         this.moveTurnDynamicFrictionInner = 0.5;
         this.moveTurnDynamicFrictionOuter = 0.05;
         this.moveTurnSpeedCoeffInner = 0.39;
         this.moveTurnSpeedCoeffOuter = 1.17;
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         this.dynamicFriction = Number(0.05);
         this.spotTurnPowerCoeff = Number(1.9);
         this.spotTurnDynamicFriction = Number(0.05);
         this.moveTurnPowerCoeffOuter = Number(1.17);
         this.moveTurnPowerCoeffInner = Number(0.39);
         this.moveTurnDynamicFrictionInner = Number(0.5);
         this.moveTurnDynamicFrictionOuter = Number(0.05);
         this.moveTurnSpeedCoeffInner = Number(0.39);
         this.moveTurnSpeedCoeffOuter = Number(1.17);
         var _loc1_:Game = Game.getInstance();
         this.mass = Number(Number(_loc1_.config.xml.attribute("mass").toString()));
         this.power = Number(Number(_loc1_.config.xml.attribute("power").toString()));
         this.maxForwardSpeed = Number(Number(_loc1_.config.xml.attribute("speed").toString()));
         this.maxBackwardSpeed = Number(Number(_loc1_.config.xml.attribute("speed").toString()));
         super();
      }
      
      public function copy(param1:TankPhysicsData) : void
      {
         this.mass = Number(param1.mass);
         this.power = Number(param1.power);
         this.maxForwardSpeed = Number(param1.maxForwardSpeed);
         this.maxBackwardSpeed = Number(param1.maxBackwardSpeed);
         this.maxTurnSpeed = Number(param1.maxTurnSpeed);
         this.springDamping = Number(param1.springDamping);
         this.drivingForceOffsetZ = Number(param1.drivingForceOffsetZ);
         this.smallVelocity = Number(param1.smallVelocity);
         this.rayLength = Number(param1.rayLength);
         this.dynamicFriction = Number(param1.dynamicFriction);
         this.brakeFriction = Number(param1.brakeFriction);
         this.sideFriction = Number(param1.sideFriction);
         this.spotTurnPowerCoeff = Number(param1.spotTurnPowerCoeff);
         this.spotTurnDynamicFriction = Number(param1.spotTurnDynamicFriction);
         this.spotTurnSideFriction = Number(param1.spotTurnSideFriction);
         this.moveTurnPowerCoeffOuter = Number(param1.moveTurnPowerCoeffOuter);
         this.moveTurnPowerCoeffInner = Number(param1.moveTurnPowerCoeffInner);
         this.moveTurnDynamicFrictionInner = Number(param1.moveTurnDynamicFrictionInner);
         this.moveTurnDynamicFrictionOuter = Number(param1.moveTurnDynamicFrictionOuter);
         this.moveTurnSideFriction = Number(param1.moveTurnSideFriction);
         this.moveTurnSpeedCoeffInner = Number(param1.moveTurnSpeedCoeffInner);
         this.moveTurnSpeedCoeffOuter = Number(param1.moveTurnSpeedCoeffOuter);
      }
      
      public function getXml() : XML
      {
         var _loc1_:String = null;
         var _loc2_:XML = <profile></profile>;
         for each(_loc1_ in fields)
         {
            _loc2_.appendChild(XML("<" + _loc1_ + ">" + this[_loc1_] + "</" + _loc1_ + ">"));
         }
         return _loc2_;
      }
      
      public function loadFromXml(param1:XML) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in fields)
         {
            this[_loc2_] = Number(param1.elements(_loc2_)[0]);
         }
      }
      
      public function clone() : TankPhysicsData
      {
         var _loc1_:TankPhysicsData = new TankPhysicsData();
         _loc1_.copy(this);
         return _loc1_;
      }
   }
}
