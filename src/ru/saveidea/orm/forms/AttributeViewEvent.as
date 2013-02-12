package ru.saveidea.orm.forms {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class AttributeViewEvent extends Event {
		
		public static const ON_CHANGE : String = "ON_CHANGE";
		public static const MAKE_CHILD : String = "MAKE_CHILD";
		
		public var childModel : Object;
		public var parentPropertyName : String;
		
		public function AttributeViewEvent(type : String, _childModel : Object=null, _parentPropertyName : String=null, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			childModel = _childModel;
			parentPropertyName = _parentPropertyName;
		}
	}
}