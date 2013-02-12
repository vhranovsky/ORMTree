package ru.saveidea.tree.manager {
	import ru.saveidea.minimalcomps.components.ScrollPane;
	import ru.saveidea.orm.AirDBEntityManager;
	import ru.saveidea.tree.view.TreeView;
	import ru.saveidea.tree.view.TreeViewEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;

	/**
	 * @author antonsidorenko
	 */
	public class TreePanel extends ScrollPane {
		
		private var ui : TreePanelUI;
		public var treeView : TreeView;
		private var _data : Object;
		
		private var fileReference : FileReference;

		public function TreePanel(treeNodeClass : Class) {
			autoHideScrollBar = true;

			dragContent = false;

			ui = new TreePanelUI();
			addChild(ui);

			treeView = new TreeView(treeNodeClass);
			// treeView.addEventListener(TreeViewEvent.CHANGE, onTreeViewChangeHandler);
			treeView.addEventListener(TreeViewEvent.NODE_ADD, onNodeAddHandler);
			treeView.addEventListener(TreeViewEvent.NODE_SELECT, onNodeSelectHandler);
			addChild(treeView);
			treeView.y = 35;
			// treeView.x = 5;

			// ui.addFolderButton.buttonMode = true;
			// ui.addDocumentButton.buttonMode = true;
			ui.saveButton.buttonMode = true;
			ui.exportButton.buttonMode = true;
			ui.importButton.buttonMode = true;

			// ui.addFolderButton.addEventListener(MouseEvent.CLICK, onAddFolderButtonClickHandler);
			// ui.addDocumentButton.addEventListener(MouseEvent.CLICK, onAddDocumentButtonClickHandler);
			ui.saveButton.addEventListener(MouseEvent.CLICK, onSaveButtonClickHandler);
			ui.exportButton.addEventListener(MouseEvent.CLICK, onExportButtonClickHandler);
			ui.importButton.addEventListener(MouseEvent.CLICK, onImportButtonClickHandler);

			addEventListener(MouseEvent.CLICK, onClickHandler);

			width = 250;
			height = 500;
		}

		private function onImportButtonClickHandler(event : MouseEvent) : void {
			// открываем файл менеджер, чтобы загрузить файл базы данных
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, onFileSelectHandler);
			fileReference.browse();
		}

		private function onFileSelectHandler(event : Event) : void {
			fileReference.addEventListener(Event.COMPLETE, onFileLoadComplete);
			fileReference.load();
		}

		private function onFileLoadComplete(event : Event) : void {
			trace(fileReference.data);
		}

		private function onNodeSelectHandler(event : TreeViewEvent) : void {
			trace("TreePanel.onNodeSelectHandler(event)");
			dispatchEvent(new TreePanelEvent(TreePanelEvent.SELECT_NODE, event.data));
		}

		private function onNodeAddHandler(event : TreeViewEvent) : void {
			dispatchEvent(new TreePanelEvent(TreePanelEvent.MAKE_NODE, event.data));
		}		
		
		private function onTreeViewChangeHandler(event : TreeViewEvent) : void {
			update();
		}

		private function onExportButtonClickHandler(event : MouseEvent) : void {
			save();
			AirDBEntityManager.instance.export();
		}

		private function onClickHandler(event : MouseEvent) : void {
			//treeView.deselect();
		}

		private function onSaveButtonClickHandler(event : MouseEvent) : void {
			save();
		}

		private function save() : void {
			dispatchEvent(new TreePanelEvent(TreePanelEvent.SAVE, null));
			AirDBEntityManager.instance.save(_data);
		}

		public function set data(data : Object) : void {
			_data = data;
			treeView.data = data;
		}

		public function updateView() : void {
			treeView.update();
		}

		override public function set width(w : Number) : void {
			super.width = w;
			treeView.width = w;
		}
	}
}