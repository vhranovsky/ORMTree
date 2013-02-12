package ru.saveidea.tree.manager {
	import ru.saveidea.tree.view.TreeNodeViewBase;

	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class TreePanelEvent extends Event {
		
		public static const SAVE : String = "SAVE";
		public static const MAKE_NODE : String = "MAKE_NODE";
		public static const SELECT_NODE : String = "SELECT_NODE";
		
		public var node : Object;

		public function TreePanelEvent(type : String, _node : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			node = _node;
		}
		
	}
}