package ru.saveidea.ormtree.view {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeViewEvent extends Event {
		
		public static const NODE_SELECT : String = "NODE_SELECT";
		public static const NODE_ADD : String = "NODE_ADD";
		public static const CHANGE : String = "CHANGE";
		
		public var node : Object;

		public function ORMTreeViewEvent(type : String, _node : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			node = _node;
		}
	}
}