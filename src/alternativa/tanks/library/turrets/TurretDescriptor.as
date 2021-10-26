package alternativa.tanks.library.turrets
{
   public class TurretDescriptor
   {
       
      
      private var _id:String;
      
      private var _modelUrl:String;
      
      private var _detailsUrl:String;
      
      private var _lightmapUrl:String;
      
      public function TurretDescriptor(id:String, modelUrl:String, detailsUrl:String, lightmapUrl:String)
      {
         super();
         trace("TurretDescriptor::TurretDescriptor()",id,modelUrl,detailsUrl,lightmapUrl);
         this._id = id;
         this._modelUrl = modelUrl;
         this._detailsUrl = detailsUrl;
         this._lightmapUrl = lightmapUrl;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get modelUrl() : String
      {
         return this._modelUrl;
      }
      
      public function get detailsUrl() : String
      {
         return this._detailsUrl;
      }
      
      public function get lightmapUrl() : String
      {
         return this._lightmapUrl;
      }
   }
}
