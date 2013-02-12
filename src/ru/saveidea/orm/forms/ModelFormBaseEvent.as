package ru.saveidea.orm.forms {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class ModelFormBaseEvent extends Event {
		
		public static const SAVE : String = "SAVE";

		public function ModelFormBaseEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}