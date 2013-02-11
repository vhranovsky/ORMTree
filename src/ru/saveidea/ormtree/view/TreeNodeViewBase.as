package ru.saveidea.ormtree.view {
	import avmplus.getQualifiedClassName;

	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	/**
	 * @author antonsidorenko
	 */
	public class TreeNodeViewBase extends Sprite {
		
		// ссылка на родителя
		public var parentNodeView : TreeNodeViewBase;
		// Список детей
		protected var childs : Array;
		// Контейнер для детей
		public var childsContainer : Sprite;
		private var _isCollapsed : Boolean;
		private var _data : Object;
		// States
		private var currentState : String;
		public static const STATE_NORMAL : String = "STATE_NORMAL";
		public static const STATE_SELECTED : String = "STATE_SELECTED";
		protected var skin : TreeNodeSkinBase;

		public function TreeNodeViewBase(parentNodeView : TreeNodeViewBase) {
			this.parentNodeView = parentNodeView;
			
			_isCollapsed = true;

			childs = [];

			childsContainer = new Sprite();

			var skinClass : Class = getSkinClass();
			skin = new skinClass(this);
			addChild(skin);
		}

		public function update() : void {
			// пробегаю по списку детей и правильно расставляю их
			var child : TreeNodeViewBase;
			var childPosition : Number = 0;
			for (var i : int = 0; i < childs.length; i++) {
				child = childs[i];
				child.update();

				child.x = 0;
				child.y = childPosition;

				childPosition += child.height + 1;
			}

			skin.update();
		}

		public function get data() : Object {
			return _data;
		}

		public function set data(data : Object) : void {
			_data = data;

			skin.data = data;

			clear();
		}

		public function select() : void {
			getRootView().dispatchEvent(new TreeNodeViewBaseEvent(TreeNodeViewBaseEvent.SELECT, null, this));
			changeState(STATE_SELECTED);
		}

		public function deselect() : void {
			changeState(STATE_NORMAL);
		}

		public function expand(needToUpdateTree : Boolean = true) : void {
			if (_isCollapsed) {
				
				addChild(childsContainer);
				
				if (needToUpdateTree) {
					updateTree();
				}			
			}

			_isCollapsed = false;
		}

		public function expandAll() : void {
			expand(true);
			var child : TreeNodeViewBase;
			for (var i : int = 0; i < childs.length; i++) {
				child = childs[i];
				child.expandAll();
			}

			_isCollapsed = false;
		}

		public function collapse(needToUpdateTree : Boolean = true) : void {
			if (!_isCollapsed) {
				
				removeChild(childsContainer);
				
				if (needToUpdateTree) {
					updateTree();
				}

				
			}

			_isCollapsed = true;
		}

		public function collapseAll() : void {
			collapse(true);
			var child : TreeNodeViewBase;
			for (var i : int = 0; i < childs.length; i++) {
				child = childs[i];
				child.collapseAll();
			}

			_isCollapsed = true;
		}

		public function get isCollapsed() : Boolean {
			return _isCollapsed;
		}

		public function destroy() : void {
			removeChild(skin);

			clear();
		}

		protected function getRootView() : TreeNodeViewBase {
			var rootView : TreeNodeViewBase = parentNodeView;
			while (true) {
				if (rootView && rootView.parentNodeView != null) {
					rootView = rootView.parentNodeView;
				} else {
					break;
				}
			}

			// TODO: Пока не понятно, хороший это вариант или нет
			if (!rootView) {
				rootView = this;
			}
			return rootView;
		}

		protected function updateTree() : void {
			getRootView().update();
		}

		protected function changeState(state : String) : void {
			if (currentState != state) {
				currentState = state;
				onChangeState(currentState);
			}
		}

		protected function onChangeState(state : String) : void {
			skin.changeState(state);
		}

		protected function addChildView(child : TreeNodeViewBase) : void {
			childs.push(child);
			childsContainer.addChild(child);

			child.addEventListener(TreeNodeViewBaseEvent.UPDATE_DATA, onUpdateHandler);
			child.addEventListener(TreeNodeViewBaseEvent.UPDATE_VIEW, onUpdateViewHandler);

			update();
		}

		protected function clear() : void {
			var child : TreeNodeViewBase;

			for (var i : int = 0; i < childs.length; i++) {
				child = childs[i];

				child.removeEventListener(TreeNodeViewBaseEvent.UPDATE_DATA, onUpdateHandler);
				child.removeEventListener(TreeNodeViewBaseEvent.UPDATE_VIEW, onUpdateViewHandler);

				if (child.parent) {
					childsContainer.removeChild(child);
				}
				child.destroy();
			}

			childs = [];
		}

		protected function getChildNodeViewClass() : Class {
			return getDefinitionByName(getQualifiedClassName(this)) as Class;
		}

		protected function getSkinClass() : Class {
			return TreeNodeSkinBase;
		}

		private function onUpdateViewHandler(event : TreeNodeViewBaseEvent) : void {
			update();
			dispatchEvent(new TreeNodeViewBaseEvent(TreeNodeViewBaseEvent.UPDATE_VIEW));
		}

		private function onUpdateHandler(event : TreeNodeViewBaseEvent) : void {
			if (parentNodeView) {
				dispatchEvent(new TreeNodeViewBaseEvent(TreeNodeViewBaseEvent.UPDATE_DATA));
			} else {
				// model = _model;
				onUpdateViewHandler(null);
			}
		}
	}
}