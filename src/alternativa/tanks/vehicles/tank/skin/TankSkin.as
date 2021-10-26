package alternativa.tanks.vehicles.tank.skin
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.TankConst;
   import alternativa.tanks.vehicles.tank.TankHull;
   import alternativa.tanks.vehicles.tank.TankPart;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   
   use namespace alternativa3d;
   
   public class TankSkin
   {
      
      private static const m1:Matrix4 = new Matrix4();
      
      private static const m2:Matrix4 = new Matrix4();
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const turretMatrix:Matrix4 = new Matrix4();
       
      
      private var _colormap:BitmapData;
      
      private var _hull:TankHull;
      
      private var _hullMesh:Mesh;
      
      private var _turret:TankTurret;
      
      private var _turretMesh:Mesh;
      
      private var container:Object3DContainer;
      
      private var leftTrackSkin:TrackSkin;
      
      private var rightTrackSkin:TrackSkin;
      
      public function TankSkin()
      {
         this._hullMesh = new Mesh();
         this._turretMesh = new Mesh();
         super();
      }
      
      private static function setObjectTransformation(object:Object3D, m:Matrix4) : void
      {
         m.getEulerAngles(eulerAngles);
         object.x = m.d;
         object.y = m.h;
         object.z = m.l;
         object.rotationX = eulerAngles.x;
         object.rotationY = eulerAngles.y;
         object.rotationZ = eulerAngles.z;
      }
      
      public function get visible() : Boolean
      {
         return this._hullMesh.visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this._hullMesh.visible = value;
         this._turretMesh.visible = value;
      }
      
      public function addToContainer(container:Object3DContainer) : void
      {
         this.container = container;
         if(this._hullMesh != null)
         {
            container.addChild(this._hullMesh);
         }
         if(this._turretMesh != null)
         {
            container.addChild(this._turretMesh);
         }
      }
      
      public function removeFromContainer() : void
      {
         if(this.container != null)
         {
            if(this._hullMesh != null)
            {
               this.container.removeChild(this._hullMesh);
            }
            if(this._turretMesh != null)
            {
               this.container.removeChild(this._turretMesh);
            }
         }
      }
      
      public function get hullMesh() : Mesh
      {
         return this._hullMesh;
      }
      
      public function get turretMesh() : Mesh
      {
         return this._turretMesh;
      }
      
      public function getHull() : TankHull
      {
         return this._hull;
      }
      
      public function setHull(value:TankHull) : void
      {
         if(this._hull != null && this.container != null)
         {
            this.container.removeChild(this._hullMesh);
         }
         this._hull = value;
         if(this._hull != null)
         {
            this._hullMesh = Mesh(this._hull.skin.clone());
            this.parseTrackSkins(this._hullMesh);
            if(this.container != null)
            {
               this.container.addChild(this._hullMesh);
            }
         }
         this.updatePartTexture(this._hull,this._hullMesh);
      }
      
      private function parseTrackSkins(mesh:Mesh) : void
      {
         var face:Face = null;
         this.leftTrackSkin = new TrackSkin();
         this.rightTrackSkin = new TrackSkin();
         for each(face in mesh.faces)
         {
            if(face.material.name == "tracks")
            {
               this.addFaceToTrackSkin(face);
            }
         }
         this.leftTrackSkin.init();
         this.rightTrackSkin.init();
      }
      
      private function addFaceToTrackSkin(face:Face) : void
      {
         var vertex:Vertex = face.vertices[0];
         trace(vertex.x);
         if(vertex.x < 0)
         {
            this.leftTrackSkin.addFace(face);
         }
         else
         {
            this.rightTrackSkin.addFace(face);
         }
      }
      
      public function getTurret() : TankTurret
      {
         return this._turret;
      }
      
      public function setTurret(value:TankTurret) : void
      {
         var container:Object3DContainer = null;
         if(this._turret != null)
         {
            container = this._turretMesh.parent;
            this._turretMesh.removeFromParent();
         }
         this._turret = value;
         if(this._turret != null)
         {
            this._turretMesh = Mesh(this._turret.skin.clone());
            if(container != null)
            {
               container.addChild(this._turretMesh);
            }
         }
         this.updatePartTexture(this._turret,this._turretMesh);
      }
      
      public function setColormap(value:BitmapData) : void
      {
         if(value != null)
         {
            this._colormap = value;
            this.updatePartTexture(this._hull,this._hullMesh);
            this.updatePartTexture(this._turret,this._turretMesh);
         }
      }
      
      public function getHalfHeight() : Number
      {
         return (this._hullMesh.boundMaxZ - this._hullMesh.boundMinZ) / 2;
      }
      
      public function updateTransform(position:Vector3, orientation:Quaternion, turretDirection:Number) : void
      {
         if(this._hull != null)
         {
            orientation.toMatrix4(m1);
            m1.setPosition(position);
            m2.toIdentity();
            m2.l = -(this.getHalfHeight() + TankConst.SKIN_DISPLACEMENT_Z);
            m2.append(m1);
            setObjectTransformation(this._hullMesh,m2);
            if(this._turret != null)
            {
               m1.toIdentity();
               m1.setPosition(this._hull.turretSkinMountPoint);
               m1.setRotationMatrix(0,0,-turretDirection);
               m1.append(m2);
               setObjectTransformation(this._turretMesh,m1);
            }
         }
      }
      
      public function updateTracks(deltaLeft:Number, deltaRight:Number) : void
      {
         this.leftTrackSkin.move(deltaLeft);
         this.rightTrackSkin.move(deltaRight);
      }
      
      private function updatePartTexture(part:TankPart, mesh:Mesh) : void
      {
         var shape:Shape = null;
         var texture:BitmapData = null;
         var trackMaterial:TrackMaterial = null;
         var face:Face = null;
         if(part != null && this._colormap != null)
         {
            shape = new Shape();
            shape.graphics.beginBitmapFill(this._colormap);
            shape.graphics.drawRect(0,0,part.lightmap.width,part.lightmap.height);
            texture = new BitmapData(part.lightmap.width,part.lightmap.height,false,0);
            texture.draw(shape);
            texture.draw(part.lightmap,null,null,BlendMode.HARDLIGHT);
            texture.draw(part.details);
            for each(face in mesh.faces)
            {
               if(trackMaterial == null)
               {
                  trackMaterial = new TrackMaterial(texture,true,true,MipMapping.PER_PIXEL,2.5);
               }
               face.material = trackMaterial;
            }
         }
      }
      
      public function getGlobalMuzzlePosition(index:int) : Vector3
      {
         turretMatrix.setMatrix(this._turretMesh.x,this._turretMesh.y,this._turretMesh.z,this._turretMesh.rotationX,this._turretMesh.rotationY,this._turretMesh.rotationZ);
         var result:Vector3 = new Vector3();
         turretMatrix.transformVector(this._turret.muzzlePoints[index],result);
         return result;
      }
   }
}
