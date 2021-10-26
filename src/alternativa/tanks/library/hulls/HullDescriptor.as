package alternativa.tanks.library.hulls
{
   public class HullDescriptor
   {
       
      
      private var _id:String;
      
      private var _modelUrl:String;
      
      private var _detailsUrl:String;
      
      private var _lightmapUrl:String;
      
      private var _shadowTextureUrl:String;
      
      public function HullDescriptor(id:String, modelUrl:String, detailsUrl:String, lightmapUrl:String, shadowTextureUrl:String)
      {
         super();
         trace("HullDescriptor::HullDescriptor()",id,modelUrl,detailsUrl,lightmapUrl,shadowTextureUrl);
         this._id = id;
         this._modelUrl = modelUrl;
         this._detailsUrl = detailsUrl;
         this._lightmapUrl = lightmapUrl;
         this._shadowTextureUrl = shadowTextureUrl;
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
      
      public function get shadowTextureUrl() : String
      {
         return this._shadowTextureUrl;
      }
   }
}
