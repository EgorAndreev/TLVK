package alternativa.tanks
{
   import alternativa.tanks.display.DebugPanel;
   import alternativa.tanks.utils.KeyboardListener;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.UserTankController;
   import flash.ui.Keyboard;
   
   public class TanksManager
   {
       
      
      private var game:Game;
      
      private var tanks:Vector.<Tank>;
      
      private var currentTankIndex:int = -1;
      
      private var keyboardListener:KeyboardListener;
      
      private var userTankController:UserTankController;
      
      private const turretSetters:TankPartSetters = new TankPartSetters();
      
      private const hullSetters:TankPartSetters = new TankPartSetters();
      
      private const colormapSetters:TankPartSetters = new TankPartSetters();
      
      private var weapons:Weapons;
      
      private var debugPanel:DebugPanel;
      
      public function TanksManager(game:Game, debugPanel:DebugPanel)
      {
         this.tanks = new Vector.<Tank>();
         this.weapons = new Weapons();
         super();
         this.game = game;
         this.debugPanel = debugPanel;
         this.initKeyboardListeners();
         this.userTankController = new UserTankController(game.stage);
      }
      
      public function addTank(tank:Tank) : void
      {
         if(this.contains(tank))
         {
            throw new Error("Tank already exists");
         }
         tank.setWeapon(this.weapons.getCurrentWeapon());
         this.tanks.push(tank);
         this.game.addGameObject(tank);
         if(this.tanks.length == 1)
         {
            this.selectTank(0);
         }
         this.printTanksNumber();
      }
      
      private function printTanksNumber() : void
      {
         this.game.debugPanel.printValue("Количество танков",this.tanks.length);
      }
      
      private function contains(tank:Tank) : Boolean
      {
         return this.tanks.indexOf(tank) >= 0;
      }
      
      private function initKeyboardListeners() : void
      {
         this.keyboardListener = new KeyboardListener(this.game.stage);
         this.keyboardListener.addHandler(Keyboard.DELETE,this.removeCurrentTank);
         this.keyboardListener.addHandler(Keyboard.N,this.selectNextTank);
         this.keyboardListener.addHandler(Keyboard.N | KeyboardListener.BIT_SHIFT,this.selectPrevTank);
         this.keyboardListener.addHandler(Keyboard.F9,this.test);
      }
      
      private function test() : void
      {
         var tank:Tank = this.currentTank();
         tank.chassis.state.position.reset(Infinity,Infinity,Infinity);
      }
      
      private function selectNextTank() : void
      {
         if(this.hasTanks())
         {
            this.selectTank(this.currentTankIndex + 1);
         }
      }
      
      private function selectPrevTank() : void
      {
         if(this.hasTanks())
         {
            if(this.currentTankIndex == 0)
            {
               this.selectTank(this.tanks.length - 1);
            }
            else
            {
               this.selectTank(this.currentTankIndex - 1);
            }
         }
      }
      
      private function removeCurrentTank() : void
      {
         var tank:Tank = null;
         if(this.tanks.length > 0)
         {
            tank = this.tanks[this.currentTankIndex];
            this.turretSetters.clear(tank);
            this.hullSetters.clear(tank);
            this.colormapSetters.clear(tank);
            this.tanks.splice(this.currentTankIndex,1);
            tank.destroy();
            this.game.tankRemoved(tank);
            if(this.currentTankIndex == this.tanks.length)
            {
               --this.currentTankIndex;
            }
            if(this.currentTankExists())
            {
               this.selectTank(this.currentTankIndex);
            }
            this.printTanksNumber();
         }
      }
      
      private function selectTank(tankIndex:uint) : void
      {
         if(this.currentTankExists())
         {
            this.currentTank().controller = null;
         }
         this.currentTankIndex = tankIndex % this.tanks.length;
         this.currentTank().controller = this.userTankController;
         this.game.currentTankChanged(this.currentTank());
         this.printWeaponName();
         this.printWeaponEffectsName();
      }
      
      private function printWeaponName() : void
      {
         this.debugPanel.printValue("Тип пушек",this.currentTank().getWeapon().name);
      }
      
      private function printWeaponEffectsName() : void
      {
         this.debugPanel.printValue("Пушка",this.currentTank().getWeapon().getEffectsName());
      }
      
      private function hasTanks() : Boolean
      {
         return this.tanks.length > 0;
      }
      
      public function numTanks() : int
      {
         return this.tanks.length;
      }
      
      public function currentTank() : Tank
      {
         if(this.currentTankIndex < 0)
         {
            throw new Error("There is no current tank");
         }
         return this.tanks[this.currentTankIndex];
      }
      
      public function setTurretForCurrentTank(turretId:String) : void
      {
         var tank:Tank = null;
         var turretSetter:TurretSetter = null;
         if(this.currentTankExists())
         {
            tank = this.currentTank();
            this.turretSetters.cancel(tank);
            turretSetter = new TurretSetter(tank,this);
            this.turretSetters.add(tank,turretSetter);
            this.game.config.turretsLibrary.getTurret(turretId,turretSetter.onTurretReady);
         }
      }
      
      public function removeTurretSetter(tank:Tank) : void
      {
         this.turretSetters.clear(tank);
      }
      
      public function setHullForCurrentTank(hullId:String) : void
      {
         var tank:Tank = null;
         var hullSetter:HullSetter = null;
         if(this.currentTankExists())
         {
            tank = this.currentTank();
            this.hullSetters.cancel(tank);
            hullSetter = new HullSetter(tank,this);
            this.hullSetters.add(tank,hullSetter);
            this.game.config.hullsLibrary.getHull(hullId,hullSetter.onHullReady);
         }
      }
      
      public function removeHullSetter(tank:Tank) : void
      {
         this.hullSetters.clear(tank);
      }
      
      public function setColorForCurrentTank(colormapId:String) : void
      {
         var tank:Tank = null;
         var colormapSetter:ColormapSetter = null;
         if(this.currentTankExists())
         {
            tank = this.currentTank();
            this.colormapSetters.cancel(tank);
            colormapSetter = new ColormapSetter(tank,this);
            this.colormapSetters.add(tank,colormapSetter);
            this.game.config.colormapsLibrary.getColormap(colormapId,colormapSetter.onColormapReady);
         }
      }
      
      public function currentTankExists() : Boolean
      {
         return this.currentTankIndex >= 0;
      }
      
      public function removeColormapSetter(tank:Tank) : void
      {
         this.colormapSetters.clear(tank);
      }
      
      public function setNextWeaponForCurrentTank() : void
      {
         var tank:Tank = null;
         if(this.currentTankExists())
         {
            tank = this.currentTank();
            tank.setWeapon(this.weapons.getNextWeapon());
            this.printWeaponName();
            this.printWeaponEffectsName();
         }
      }
      
      public function setPrevWeaponForCurrentTank() : void
      {
         var tank:Tank = null;
         if(this.currentTankExists())
         {
            tank = this.currentTank();
            tank.setWeapon(this.weapons.getPrevWeapon());
            this.printWeaponName();
            this.printWeaponEffectsName();
         }
      }
      
      public function setPrevWeaponEffects() : void
      {
         if(this.currentTankExists())
         {
            this.currentTank().getWeapon().setPrevEffects();
            this.printWeaponEffectsName();
         }
      }
      
      public function setNextWeaponEffects() : void
      {
         if(this.currentTankExists())
         {
            this.currentTank().getWeapon().setNextEffects();
            this.printWeaponEffectsName();
         }
      }
   }
}

import alternativa.tanks.vehicles.tank.Tank;
import flash.utils.Dictionary;

class TankPartSetters
{
    
   
   private const setters:Dictionary = new Dictionary();
   
   function TankPartSetters()
   {
      super();
   }
   
   public function add(tank:Tank, setter:TankPartSetter) : void
   {
      this.cancel(tank);
      this.setters[tank] = setter;
   }
   
   public function cancel(tank:Tank) : void
   {
      if(this.setters[tank])
      {
         TankPartSetter(this.setters[tank]).cancel();
         this.clear(tank);
      }
   }
   
   public function clear(tank:Tank) : void
   {
      delete this.setters[tank];
   }
}

interface TankPartSetter
{
    
   
   function cancel() : void;
}

import alternativa.tanks.TanksManager;
import alternativa.tanks.vehicles.tank.Tank;

class TankPartSetterBase implements TankPartSetter
{
    
   
   protected var tank:Tank;
   
   protected var tanksManager:TanksManager;
   
   protected var cancelled:Boolean;
   
   function TankPartSetterBase(tank:Tank, tanksManager:TanksManager)
   {
      super();
      this.tank = tank;
      this.tanksManager = tanksManager;
   }
   
   public function cancel() : void
   {
      this.cancelled = true;
   }
}

import alternativa.tanks.TanksManager;
import alternativa.tanks.library.turrets.TurretReadyEvent;
import alternativa.tanks.vehicles.tank.Tank;

class TurretSetter extends TankPartSetterBase
{
    
   
   function TurretSetter(tank:Tank, tanksManager:TanksManager)
   {
      super(tank,tanksManager);
      this.tank = tank;
      this.tanksManager = tanksManager;
   }
   
   public function onTurretReady(event:TurretReadyEvent) : void
   {
      if(!cancelled)
      {
         tank.setTurret(event.turret);
         tanksManager.removeTurretSetter(tank);
      }
   }
}

import alternativa.tanks.TanksManager;
import alternativa.tanks.library.hulls.HullReadyEvent;
import alternativa.tanks.vehicles.tank.Tank;

class HullSetter extends TankPartSetterBase
{
    
   
   function HullSetter(tank:Tank, tanksManager:TanksManager)
   {
      super(tank,tanksManager);
   }
   
   public function onHullReady(event:HullReadyEvent) : void
   {
      if(!cancelled)
      {
         tank.setHull(event.hull);
         tanksManager.removeHullSetter(tank);
      }
   }
}

import alternativa.tanks.TanksManager;
import alternativa.tanks.library.colormaps.ColormapReadyEvent;
import alternativa.tanks.vehicles.tank.Tank;

class ColormapSetter extends TankPartSetterBase
{
    
   
   function ColormapSetter(tank:Tank, tanksManager:TanksManager)
   {
      super(tank,tanksManager);
   }
   
   public function onColormapReady(event:ColormapReadyEvent) : void
   {
      if(!cancelled)
      {
         tank.setColormap(event.bitmapData);
         tanksManager.removeColormapSetter(tank);
      }
   }
}
