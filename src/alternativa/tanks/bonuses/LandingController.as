package alternativa.tanks.bonuses
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class LandingController implements BonusController
   {
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const m:Matrix3 = new Matrix3();
      
      private static const ANGULAR_SPEED:Number = 2.5;
       
      
      private var bonus:BattleBonus;
      
      private var normal:Vector3;
      
      private var pivot:Vector3;
      
      private var r:Vector3;
      
      private var angle:Number;
      
      private var axis:Vector3;
      
      private var oldState:LandingState;
      
      private var newState:LandingState;
      
      private var interpolatedState:LandingState;
      
      public function LandingController(bonus:BattleBonus)
      {
         this.normal = new Vector3();
         this.pivot = new Vector3();
         this.r = new Vector3();
         this.axis = new Vector3();
         this.oldState = new LandingState();
         this.newState = new LandingState();
         this.interpolatedState = new LandingState();
         super();
         this.bonus = bonus;
      }
      
      public function init(pivot:Vector3, normal:Vector3) : void
      {
         this.pivot.copy(pivot);
         this.normal.copy(normal);
      }
      
      public function start() : void
      {
         var mesh:BonusMesh = this.bonus.getBonusMesh();
         this.r.reset(mesh.x,mesh.y,mesh.z);
         this.r.subtract(this.pivot);
         this.axis.copy(Vector3.Z_AXIS);
         this.axis.cross(this.normal);
         this.axis.normalize();
         this.angle = Math.acos(this.normal.z);
         this.newState.position.reset(mesh.x,mesh.y,mesh.z);
         this.newState.orientation.setFromEulerAnglesXYZ(mesh.rotationX,mesh.rotationY,mesh.rotationZ);
         this.oldState.copy(this.newState);
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.oldState.copy(this.newState);
         var deltaAngle:Number = ANGULAR_SPEED * dt;
         if(deltaAngle > this.angle)
         {
            deltaAngle = this.angle;
            this.angle = 0;
         }
         else
         {
            this.angle -= deltaAngle;
         }
         m.fromAxisAngle(this.axis,deltaAngle);
         this.r.transform3(m);
         this.newState.position.copy(this.pivot).add(this.r);
         this.newState.orientation.addScaledVector(this.axis,deltaAngle);
         this.updateTrigger();
         if(this.angle == 0)
         {
            this.interpolatePhysicsState(1);
            this.render();
            this.bonus.onLandingComplete();
         }
      }
      
      private function updateTrigger() : void
      {
         this.newState.orientation.toMatrix3(m);
         this.bonus.getTrigger().setTransform(this.newState.position,m);
      }
      
      public function interpolatePhysicsState(interpolationCoeff:Number) : void
      {
         this.interpolatedState.interpolate(this.oldState,this.newState,interpolationCoeff);
      }
      
      public function render() : void
      {
         var mesh:BonusMesh = this.bonus.getBonusMesh();
         mesh.x = this.interpolatedState.position.x;
         mesh.y = this.interpolatedState.position.y;
         mesh.z = this.interpolatedState.position.z;
         this.interpolatedState.orientation.getEulerAngles(eulerAngles);
         mesh.rotationX = eulerAngles.x;
         mesh.rotationY = eulerAngles.y;
         mesh.rotationZ = eulerAngles.z;
      }
   }
}
