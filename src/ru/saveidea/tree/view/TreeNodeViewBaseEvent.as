package ru.saveidea.tree.view {
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class TreeNodeViewBaseEvent extends Event {
		
		public static const UPDATE_DATA : String = "UPDATE_DATA";
		public static const UPDATE_VIEW : String = "UPDATE_VIEW";
		public static const SELECT : String = "SELECT";
		public static const ADD_CHILD : String = "ADD_CHILD";
		
		public var nodeView : TreeNodeViewBase;
		public var child : Object;

		public function TreeNodeViewBaseEvent(type : String, _nodeView : TreeNodeViewBase, _child : Object=null, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);

			nodeView = _nodeView;
			child = _child;
		}
		
	}
}