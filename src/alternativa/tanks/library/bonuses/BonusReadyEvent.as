package alternativa.tanks.library.bonuses 
{
	import alternativa.tanks.bonuses.BonusSkin;
	/**
	 * ...
	 * @author TLVK official
	 */
	public class BonusReadyEvent 
	{
		private var _bonusId:String;
      
      private var _bonus:BonusSkin;
      
      public function BonusReadyEvent(bonusId:String, bonus:BonusSkin)
      {
         super();
         this._bonusId = bonusId;
         this._bonus = bonus;
      }
      
      public function get bonusId() : String
      {
         return this._bonusId;
      }
      
      public function get bonus() : BonusSkin
      {
         return this._bonus;
      }
		
	}

}