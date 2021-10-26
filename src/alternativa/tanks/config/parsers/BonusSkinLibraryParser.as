package alternativa.tanks.config.parsers 
{
	
    import alternativa.tanks.config.Config;
    import alternativa.tanks.bonuses.BonusSkin;
	import alternativa.tanks.library.bonuses.BonusLibrary;
	import alternativa.tanks.library.bonuses.BonusDescriptor;
    import alternativa.utils.Task;
    import flash.utils.setTimeout;
    import alternativa.tanks.Game;
	/**
	 * ...
	 * @author TLVK official
	 */
	public class BonusSkinLibraryParser extends Task
	{
		  private var config:Config;
      
		  private var basePath:String;
		  
		  private var bonusDescriptors:Vector.<BonusDescriptor>;
		  
		  public function BonusSkinLibraryParser(config:Config)
		  {
			 super();
			 this.config = config;
		  }
		  
		  override public function run() : void
		  {
			 this.parseBasePath();
			 this.parseBonuses();
			 this.complete();
		  }
		  
		  private function parseBasePath() : void
		  {
			 this.basePath = this.getBonusesXml().@path;
		  }
		  
		  private function getBonusesXml() : XML
		  {
			 return this.config.xml.bonuses[0];
		  }
		  
		  private function parseBonuses() : void
		  {
			 var bonusXml:XML = null;
			 this.bonusDescriptors = new Vector.<BonusDescriptor>();
			 for each(bonusXml in this.getBonusesXml().bonus)
			 {
				this.bonusDescriptors.push(this.parseBonus(bonusXml));
			 }
		  }
		  
		  private function parseBonus(bonusXml:XML) : BonusDescriptor
		  {
			 var id:String = bonusXml.@id;
			 var bonusPath:String = bonusXml.@path;
			 var modelUrl:String = this.makeUrl(bonusPath,bonusXml.bonus.@file);
			 var textureUrl:String = this.makeUrl(bonusPath,bonusXml.bonus.texture);
			 return new BonusDescriptor(id,modelUrl,textureUrl);
		  }
		  
		  
		  private function makeUrl(bonusPath:String, fileName:String) : String
		  {
			 return this.basePath + "/" + bonusPath + "/" + fileName;
		  }
		  
		  private function complete() : void
		  {
			 this.config.bonusesLibrary = new BonusLibrary(this.bonusDescriptors);
			 setTimeout(completeTask,0);
		  }
			
	}

}