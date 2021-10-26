package alternativa.tanks
{
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   import alternativa.tanks.vehicles.tank.weapons.flamethrower.FlameThrower;
   import alternativa.tanks.vehicles.tank.weapons.plasmagun.PlasmaGun;
   import alternativa.tanks.vehicles.tank.weapons.railgun.Railgun;
   import alternativa.tanks.vehicles.tank.weapons.smoky.Smoky;
   
   public class Weapons
   {
       
      
      private var weaponClasses:Vector.<Class>;
      
      private var weaponIndex:int;
      
      public function Weapons()
      {
         this.weaponClasses = Vector.<Class>([Smoky,PlasmaGun,FlameThrower,Railgun]);
         super();
      }
      
      public function getCurrentWeapon() : Weapon
      {
         return this.createWeapon();
      }
      
      private function createWeapon() : Weapon
      {
         var weaponClass:Class = this.weaponClasses[this.weaponIndex];
         return new weaponClass();
      }
      
      public function getNextWeapon() : Weapon
      {
         this.selectNextWeapon();
         return this.getCurrentWeapon();
      }
      
      private function selectNextWeapon() : void
      {
         this.weaponIndex = (this.weaponIndex + 1) % this.weaponClasses.length;
      }
      
      public function getPrevWeapon() : Weapon
      {
         this.selectPrevWeapon();
         return this.getCurrentWeapon();
      }
      
      private function selectPrevWeapon() : void
      {
         if(this.weaponIndex == 0)
         {
            this.weaponIndex = this.weaponClasses.length - 1;
         }
         else
         {
            --this.weaponIndex;
         }
      }
   }
}
