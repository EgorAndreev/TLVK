package alternativa.tanks.library.colormaps
{
   public class ColormapDescriptor
   {
       
      
      private var _id:String;
      
      private var _url:String;
      
      public function ColormapDescriptor(id:String, url:String)
      {
         super();
         this._id = id;
         this._url = url;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get url() : String
      {
         return this._url;
      }
   }
}
