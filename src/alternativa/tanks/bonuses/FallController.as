package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class FallController implements BonusController
   {
      
      private static const MAX_ANGLE_X:Number = 0.1;
      
      private static const ANGLE_X_FREQ:Number = 1;
      
      private static const m:Matrix3 = new Matrix3();
      
      private static const v:Vector3 = new Vector3();
       
      
      private const interpolatedMatrix:Matrix3 = new Matrix3();
      
      private const interpolatedVector:Vector3 = new Vector3();
      
      private const oldState:BattleBonusState = new BattleBonusState();
      
      private const newState:BattleBonusState = new BattleBonusState();
      
      private const interpolatedState:BattleBonusState = new BattleBonusState();
      
      private var battleBonus:BattleBonus;
      
      private var minPivotZ:Number;
      
      private var time:Number;
      
      private var fallSpeed:Number;
      
      private var t0:Number;
      
      private var x:Number = 0;
      
      private var y:Number = 0;
      
      public function FallController(battleBonus:BattleBonus)
      {
         super();
         this.battleBonus = battleBonus;
      }
      
      public function init(spawnPosition:Vector3, fallSpeed:Number, minPivotZ:Number, t0:Number, startTime:Number, startingAngleZ:Number) : void
      {
         this.x = spawnPosition.x;
         this.y = spawnPosition.y;
         this.newState.pivotZ = spawnPosition.z + BonusConst.BONUS_OFFSET_Z - fallSpeed * startTime;
         this.newState.angleZ = startingAngleZ + BonusConst.ANGULAR_SPEED_Z * startTime;
         this.fallSpeed = fallSpeed;
         this.minPivotZ = minPivotZ;
         this.t0 = t0;
         this.time = startTime;
      }
      
      public function start() : void
      {
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.oldState.copy(this.newState);
         this.time += dt;
         this.newState.pivotZ -= this.fallSpeed * dt;
         this.newState.angleX = MAX_ANGLE_X * Math.sin(ANGLE_X_FREQ * (this.t0 + this.time));
         this.newState.angleZ += BonusConst.ANGULAR_SPEED_Z * dt;
         if(this.newState.pivotZ <= this.minPivotZ)
         {
            this.newState.pivotZ = this.minPivotZ;
            this.newState.angleX = 0;
            this.interpolatePhysicsState(1);
            this.render();
            this.battleBonus.onTouchGround();
         }
         this.updateTrigger();
      }
      
      private function updateTrigger() : void
      {
         m.setRotationMatrix(this.newState.angleX,0,this.newState.angleZ);
         m.transformVector(Vector3.DOWN,v);
         v.scale(BonusConst.BONUS_OFFSET_Z);
         this.battleBonus.getTrigger().update(this.x + v.x,this.y + v.y,this.newState.pivotZ + v.z,this.newState.angleX,0,this.newState.angleZ);
      }
      
      public function interpolatePhysicsState(interpolationCoeff:Number) : void
      {
         this.interpolatedState.interpolate(this.oldState,this.newState,interpolationCoeff);
         this.interpolatedMatrix.setRotationMatrix(this.interpolatedState.angleX,0,this.interpolatedState.angleZ);
         this.interpolatedMatrix.transformVector(Vector3.DOWN,this.interpolatedVector);
      }
      
      public function render() : void
      {
         this.setObjectTransform(this.battleBonus.getParachute(),BonusConst.PARACHUTE_OFFSET_Z,this.interpolatedVector);
         this.setObjectTransform(this.battleBonus.getBonusMesh(),BonusConst.BONUS_OFFSET_Z,this.interpolatedVector);
         this.battleBonus.getCords().updateVertices();
      }
      
      private function setObjectTransform(object:Object3D, objectOffset:Number, offsetVector:Vector3) : void
      {
         object.rotationX = this.interpolatedState.angleX;
         object.rotationZ = this.interpolatedState.angleZ;
         object.x = this.x + objectOffset * offsetVector.x;
         object.y = this.y + objectOffset * offsetVector.y;
         object.z = this.interpolatedState.pivotZ + objectOffset * offsetVector.z;
      }
   }
}
