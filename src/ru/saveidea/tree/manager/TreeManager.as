package ru.saveidea.tree.manager {
	import ru.saveidea.orm.form.ObjectFormPanel;
	import ru.saveidea.orm.form.ObjectFormPanelEvent;
	import ru.saveidea.view.ManualSizedSprite;

	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	 
	public class TreeManager extends ManualSizedSprite {
		public var treePanel : TreePanel;
		private var objectFormPanel : ObjectFormPanel;
		private var _data : Object;

		public function TreeManager(treeNodeClass : Class, formClass : Class) {
			treePanel = new TreePanel(treeNodeClass);
			treePanel.addEventListener(TreePanelEvent.SELECT_NODE, onSelectNodeHandler);
			treePanel.addEventListener(TreePanelEvent.MAKE_NODE, onMakeNodeHandler);
			treePanel.addEventListener(TreePanelEvent.SAVE, onSaveModelHandler);
			addChild(treePanel);

			objectFormPanel = new ObjectFormPanel(formClass);
			objectFormPanel.addEventListener(ObjectFormPanelEvent.SAVE, onObjectSaveHandler);
			addChild(objectFormPanel);
			objectFormPanel.x = treePanel.width;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}

		protected function onObjectSaveHandler(event : ObjectFormPanelEvent) : void {
			treePanel.treeView.update();
		}

		private function onSaveModelHandler(event : TreePanelEvent) : void {
			dispatchEvent(new TreeManagerEvent(TreeManagerEvent.SAVE, _data));
		}

		private function onSelectNodeHandler(event : TreePanelEvent) : void {
			trace("TreeManager.onSelectNodeHandler(event)");
			objectFormPanel.data = event.node;
		}

		private function onMakeNodeHandler(event : TreePanelEvent) : void {
			objectFormPanel.data = event.node;
		}

		private function onAddedToStageHandler(event : Event) : void {
			// stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEventHandler);
		}

		private function onNodeChangeHandler(event : Event) : void {
			treePanel.updateView();
		}

		/*
		private function onKeyboardEventHandler(event : KeyboardEvent) : void {
		if (event.keyCode == Keyboard.DELETE) {
		// удаляем ноду, если есть что удалять
		var selectedNode : ITreeNodeData = treePanel.treeView.getSelectedNode();
		if (selectedNode) {
		selectedNode.parent.childs.source.splice(selectedNode.parent.childs.source.indexOf(selectedNode), 1);
		// надо обновить внешний вид
		}
		treePanel.treeView.deselect();
		}
		treePanel.treeView.update();
		}
		 * 
		 */
		public function set data(data : Object) : void {
			_data = data;
			treePanel.data = data;
		}

		override public function set width(value : Number) : void {
			super.width = value;
			treePanel.width = 250;
			objectFormPanel.width = value - 250;
		}

		override public function set height(value : Number) : void {
			super.height = value;
			treePanel.height = value;
			objectFormPanel.height = value;
		}
	}
}