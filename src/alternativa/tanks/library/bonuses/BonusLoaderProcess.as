package alternativa.tanks.library.bonuses 
{
	import alternativa.tanks.bonuses.BonusSkin;
	import alternativa.tanks.library.Listeners;
	import flash.events.Event;
	/**
	 * ...
	 * @author TLVK official
	 */
	public class BonusLoaderProcess 
	{
		/*
		  private var descriptor:BonusDescriptor;
      
		  private var callback:Function;
		  
		  private var listeners:Listeners;
		  
		  private var loader:BonusLoader;
		  
		  function BonusLoaderProcess(descriptor:BonusDescriptor, callback:Function)
		  {
			 this.listeners = new Listeners();
			 super();
			 this.descriptor = descriptor;
			 this.callback = callback;
			 this.start();
		  }
		  
		  function getBonusId() : String
		  {
			 return this.descriptor.id;
		  }
		  
		  function getBonus() : BonusSkin
		  {
			 return this.loader.getBonus();
		  }
		  
		  function addListener(listener:Function) : void
		  {
			 this.listeners.add(listener);
		  }
		  
		  function notifyListeners() : void
		  {
			 this.listeners.notify(new BonusReadyEvent(this.descriptor.id,this.getBonus()));
		  }
		  
		  private function start() : void
		  {
			 this.loader = new BonusLoader(this.descriptor);
			 this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
			 this.loader.load();
		  }
		  
		  private function onLoadingComplete(event:Event) : void
		  {
			 this.callback(this);
		  }
		  */

	}
}