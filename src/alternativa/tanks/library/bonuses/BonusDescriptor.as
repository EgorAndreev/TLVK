package alternativa.tanks.library.bonuses 
{
	/**
	 * ...
	 * @author TLVK official
	 */
	public class BonusDescriptor 
	{
		
		  private var _id:String;
      
		  private var _modelUrl:String;
		  
		  private var _textureUrl:String;
		  
		  
		  public function BonusDescriptor(id:String, modelUrl:String, textureUrl:String)
		  {
			 super();
			 trace("BonusDescriptor::BonusDescriptor()",id,modelUrl,textureUrl);
			 this._id = id;
			 this._modelUrl = modelUrl;
			 this._textureUrl = textureUrl;

		  }
		  
		  public function get id() : String
		  {
			 return this._id;
		  }
		  
		  public function get modelUrl() : String
		  {
			 return this._modelUrl;
		  }
		  
		  public function get textureUrl() : String
		  {
			 return this._textureUrl;
		  }
		  
		
	}

}