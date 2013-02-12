package ru.saveidea.tree.view {
	import ru.saveidea.tree.models.TreeNodeType;

	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class TreeViewEvent extends Event {
		
		public static const NODE_SELECT : String = "NODE_SELECT";
		public static const NODE_ADD : String = "NODE_ADD";
		
		public var data : Object;

		public function TreeViewEvent(type : String, _data : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);

			data = _data;
		}
	}
}