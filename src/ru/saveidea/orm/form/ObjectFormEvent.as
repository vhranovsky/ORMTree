package ru.saveidea.orm.form {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class ObjectFormEvent extends Event {
		
		public static const SAVE : String = "SAVE";
		
		public function ObjectFormEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
}