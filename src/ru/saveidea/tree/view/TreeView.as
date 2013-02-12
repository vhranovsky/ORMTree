package ru.saveidea.tree.view {
	import flash.display.Sprite;

	/**
	 * @author antonsidorenko
	 */
	public class TreeView extends Sprite {
		private var nodeClass : Class;
		protected var rootNode : TreeNodeViewBase;

		public function TreeView(nodeClass : Class) {
			this.nodeClass = nodeClass;

			// FIXME: Проверить, чтобы nodeClass был наследником TreeNodeViewBase

			rootNode = new nodeClass(null);
			rootNode.addEventListener(TreeNodeViewBaseEvent.SELECT, onTreeNodeSelectHandler);
			rootNode.addEventListener(TreeNodeViewBaseEvent.ADD_CHILD, onTreeNodeAddHandler);
			addChild(rootNode);
		}

		private function onTreeNodeAddHandler(event : TreeNodeViewBaseEvent) : void {
			dispatchEvent(new TreeViewEvent(TreeViewEvent.NODE_ADD, event.child));
		}

		private function onTreeNodeSelectHandler(event : TreeNodeViewBaseEvent) : void {
			dispatchEvent(new TreeViewEvent(TreeViewEvent.NODE_SELECT, event.nodeView.data));
		}

		public function get data() : Object {
			return rootNode.data;
		}

		public function set data(data : Object) : void {
			rootNode.data = data;
		}

		public function update() : void {
			rootNode.update();
		}
	}
}