package ru.saveidea.orm.form {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class ObjectFormPanelEvent extends Event {
		
		public static const SAVE : String = "SAVE";
		
		public var model : Object;
		
		public function ObjectFormPanelEvent(type : String, _model : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			model = _model;
		}
	}
}