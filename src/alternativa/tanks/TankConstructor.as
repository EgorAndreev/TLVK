package alternativa.tanks
{
   import alternativa.tanks.config.Config;
   import alternativa.tanks.library.LibraryIterator;
   import flash.utils.Dictionary;
   
   public class TankConstructor
   {
       
      
      private var config:Config;
      
      private var hullIds:LibraryIterator;
      
      private var turretIds:LibraryIterator;
      
      private var colormapIds:LibraryIterator;
      
      private var creationProcessCallbacks:Dictionary;
      
      public function TankConstructor(config:Config)
      {
         this.creationProcessCallbacks = new Dictionary();
         super();
         this.config = config;
         this.hullIds = config.hullsLibrary.getIterator();
         this.turretIds = config.turretsLibrary.getIterator();
         this.colormapIds = config.colormapsLibrary.getIterator();
      }
      
      public function nextHull() : String
      {
         return this.hullIds.next();
      }
      
      public function prevHull() : String
      {
         return this.hullIds.prev();
      }
      
      public function nextTurret() : String
      {
         return this.turretIds.next();
      }
      
      public function prevTurret() : String
      {
         return this.turretIds.prev();
      }
      
      public function nextColormap() : String
      {
         return this.colormapIds.next();
      }
      
      public function prevColormap() : String
      {
         return this.colormapIds.prev();
      }
      
      public function createTank(callback:Function) : void
      {
         var process:TankCreationProcess = new TankCreationProcess(this.hullIds.current(),this.turretIds.current(),this.colormapIds.current(),this.onProcessComplete,this.config);
         this.creationProcessCallbacks[process] = callback;
      }
      
      private function onProcessComplete(process:TankCreationProcess) : void
      {
         var callback:Function = this.creationProcessCallbacks[process];
         delete this.creationProcessCallbacks[process];
         callback(process.getTank());
      }
      
      public function deleteTank() : void
      {
      }
   }
}

import alternativa.tanks.config.Config;
import alternativa.tanks.library.colormaps.ColormapReadyEvent;
import alternativa.tanks.library.hulls.HullReadyEvent;
import alternativa.tanks.library.turrets.TurretReadyEvent;
import alternativa.tanks.vehicles.tank.Tank;
import alternativa.tanks.vehicles.tank.TankHull;
import alternativa.tanks.vehicles.tank.TankTurret;
import flash.display.BitmapData;

class TankCreationProcess
{
    
   
   private var callback:Function;
   
   private var hull:TankHull;
   
   private var turret:TankTurret;
   
   private var colormap:BitmapData;
   
   private var tank:Tank;
   
   function TankCreationProcess(hullId:String, turretId:String, colormapId:String, callback:Function, config:Config)
   {
      super();
      trace("TankCreationProcess::TankCreationProcess()",turretId,hullId,colormapId);
      this.callback = callback;
      config.hullsLibrary.getHull(hullId,this.onHullReady);
      config.turretsLibrary.getTurret(turretId,this.onTurretReady);
      config.colormapsLibrary.getColormap(colormapId,this.onColormapReady);
   }
   
   public function getTank() : Tank
   {
      return this.tank;
   }
   
   private function onHullReady(event:HullReadyEvent) : void
   {
      this.hull = event.hull;
      this.tryToCreate();
   }
   
   private function onTurretReady(event:TurretReadyEvent) : void
   {
      this.turret = event.turret;
      this.tryToCreate();
   }
   
   private function onColormapReady(event:ColormapReadyEvent) : void
   {
      this.colormap = event.bitmapData;
      this.tryToCreate();
   }
   
   private function tryToCreate() : void
   {
      if(this.allComponentsReady())
      {
         this.tank = new Tank(this.hull,this.turret,this.colormap);
         this.callback(this);
      }
   }
   
   private function allComponentsReady() : Boolean
   {
      return this.hull != null && this.turret != null && this.colormap != null;
   }
}
