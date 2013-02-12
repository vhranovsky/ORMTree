package ru.saveidea.tree.manager {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class TreeManagerEvent extends Event {
		
		public static const SAVE : String = "SAVE";
		
		public var data : Object;
		
		public function TreeManagerEvent(type : String, _data : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			data = _data;
		}
		
	}
}