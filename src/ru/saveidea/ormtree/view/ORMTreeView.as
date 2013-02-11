package ru.saveidea.ormtree.view {
	import ru.saveidea.ormtree.view.TreeNodeViewBase;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeView extends ORMTreeNodeView {
		
		private var selectedNodeView : TreeNodeViewBase;
		
		private var preventDispatchSelectEvent : Boolean = false;
		
		public function ORMTreeView() {
			super(null);
			
			addEventListener(TreeNodeViewBaseEvent.SELECT, onTreeNodeViewSelectHandler);
			addEventListener(TreeNodeViewBaseEvent.ADD_CHILD, onTreeNodeAddChildHandler);
		}
		
		private function onTreeNodeAddChildHandler(event : TreeNodeViewBaseEvent) : void {
			
			var node : Object = new event.childType.definition();
			
			dispatchEvent(new ORMTreeViewEvent(ORMTreeViewEvent.NODE_ADD, node));
		}

		private function onTreeNodeViewSelectHandler(event : TreeNodeViewBaseEvent) : void {
			if (selectedNodeView) {
				selectedNodeView.deselect();
			}
			
			selectedNodeView = event.selectedNode;
			
			if (!preventDispatchSelectEvent) {
				dispatchEvent(new ORMTreeViewEvent(ORMTreeViewEvent.NODE_SELECT,selectedNodeView.data));
			}
		}
		
		override protected function getChildNodeViewClass() : Class {
			return ORMTreeNodeView;
		}
		
	}
}