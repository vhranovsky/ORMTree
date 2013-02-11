package ru.saveidea.ormtree.view {
	import ru.saveidea.tree.models.TreeNodeType;
	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class TreeNodeViewBaseEvent extends Event {
		
		public static const UPDATE_DATA : String = "UPDATE_DATA";
		public static const UPDATE_VIEW : String = "UPDATE_VIEW";
		public static const SELECT : String = "SELECT";
		
		public static const ADD_CHILD : String = "ADD_CHILD";
		
		public var childType : TreeNodeType;
		public var selectedNode : TreeNodeViewBase;
		
		public function TreeNodeViewBaseEvent(type : String, _childType : TreeNodeType=null, _selectedNode : TreeNodeViewBase=null, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			childType = _childType;
			selectedNode = _selectedNode;
		}
		
	}
}