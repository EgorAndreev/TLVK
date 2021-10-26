package alternativa.tanks.objects
{
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.Game;
   import alternativa.tanks.GameObject;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   
   public class SpriteSpotMarker extends GameObject
   {
       
      
      private var marker:Sprite3D;
      
      private var _position:Vector3D;
      
      private var actualPosition:Vector3D;
      
      private var _visible:Boolean;
      
      public function SpriteSpotMarker(id:int, originX:Number, originY:Number, scale:Number, texture:BitmapData)
      {
         this._position = new Vector3D();
         this.actualPosition = new Vector3D();
         super(id,"Active spawn marker");
         this.marker = new Sprite3D(100,100,new TextureMaterial(texture));
         this.marker.originX = originX;
         this.marker.originY = originY;
         this.marker.clipping = Clipping.FACE_CLIPPING;
         this.marker.scaleX = scale;
         this.marker.scaleY = scale;
         this.marker.scaleZ = scale;
         this._visible = true;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         if(this._visible == value)
         {
            return;
         }
         this._visible = value;
         if(this._visible)
         {
            game.config.map.mapContainer.addChild(this.marker);
         }
         else
         {
            game.config.map.mapContainer.removeChild(this.marker);
         }
      }
      
      public function set position(value:Vector3) : void
      {
         this._position.x = value.x;
         this._position.y = value.y;
         this._position.z = value.z;
         this.actualPosition.x = value.x;
         this.actualPosition.y = value.y;
         this.actualPosition.z = value.z;
      }
      
      override public function addToGame(game:Game) : void
      {
         this.game = game;
         if(this._visible)
         {
            game.config.map.mapContainer.addChild(this.marker);
         }
      }
      
      override public function removeFromGame() : void
      {
         if(this._visible)
         {
            game.config.map.mapContainer.removeChild(this.marker);
         }
         this.game = null;
      }
      
      override public function update(time:uint, deltaMsec:uint, deltaSec:Number, t:Number) : void
      {
         if(!this._visible)
         {
            return;
         }
         var omega:Number = 5;
         var halfAmplitude:Number = 50;
         var offset:Number = halfAmplitude * (1 + Math.sin(omega * 0.001 * time));
         this.actualPosition.z = this._position.z + offset;
         this.marker.x = this.actualPosition.x;
         this.marker.y = this.actualPosition.y;
         this.marker.z = this.actualPosition.z;
      }
   }
}
