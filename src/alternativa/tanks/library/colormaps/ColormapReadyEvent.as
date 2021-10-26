package alternativa.tanks.library.colormaps
{
   import flash.display.BitmapData;
   
   public class ColormapReadyEvent
   {
       
      
      private var _colormapId:String;
      
      private var _bitmapData:BitmapData;
      
      public function ColormapReadyEvent(colormapId:String, bitmapData:BitmapData)
      {
         super();
         this._colormapId = colormapId;
         this._bitmapData = bitmapData;
      }
      
      public function get colormapId() : String
      {
         return this._colormapId;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
   }
}
