package ru.saveidea.ormtree.view {
	import ru.saveidea.orm.AccessorProperties;
	import ru.saveidea.orm.utils.DescribeTypeUtils;
	import ru.saveidea.ormtree.example.model.ORMTreeModel;
	import ru.saveidea.tree.models.TreeNodeType;
	import ru.saveidea.tree.view.TreeNodeViewBase;
	import ru.saveidea.tree.view.TreeNodeViewBaseEvent;

	import mx.collections.ArrayCollection;

	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeNodeView extends TreeNodeViewBase {
		private var _contextMenu : ContextMenu;
		private var _typeByContextMenuItem : Dictionary;
		private var isDynamicContent : Boolean = false;

		public function ORMTreeNodeView(parentNodeView : TreeNodeViewBase) {
			super(parentNodeView);
		}

		override public function update() : void {
			if (isDynamicContent) {
				var dataSpecified : ORMTreeNodeData = data as ORMTreeNodeData;
				var dataChilds : Array = (dataSpecified.data[dataSpecified.property] as ArrayCollection).source;

				if (dataChilds.length != childs.length) {
					// пересоздать детей
					clear();

					var childViewClass : Class = getChildNodeViewClass();
					var childView : TreeNodeViewBase;

					for (var i : int = 0; i < dataChilds.length; i++) {
						childView = new childViewClass(this);
						childView.data = dataChilds[i];
						addChildView(childView);
					}
				}
			}

			super.update();
		}

		override public function set data(data : Object) : void {
			super.data = data;

			var childViewClass : Class = getChildNodeViewClass();
			var childView : TreeNodeViewBase;
			var childData : ORMTreeNodeData;
			var dataSpecified : ORMTreeNodeData;

			var i : int = 0;

			if (data is ORMTreeNodeData) {
				isDynamicContent = true;

				dataSpecified = data as ORMTreeNodeData;
				var childs : Array = (dataSpecified.data[dataSpecified.property] as ArrayCollection).source;

				for (i = 0; i < childs.length; i++) {
					childView = new childViewClass(this);

					addChildView(childView);

					childView.data = childs[i];

					// modelToView[childs[i]] = childView;
				}

				var model : ORMTreeModel = dataSpecified.data as ORMTreeModel;
				if (model) {
					_contextMenu = new ContextMenu();
					_typeByContextMenuItem = new Dictionary();

					var types : Vector.<TreeNodeType> = model.allowedChildTypesForList(dataSpecified.property);

					var item : ContextMenuItem;
					for (i = 0; i < types.length; i++) {
						item = new ContextMenuItem("Add " + types[i].name);
						item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelectHandler);
						_contextMenu.customItems.push(item);

						_typeByContextMenuItem[item] = types[i];
					}

					// Настроить контекстное меню для создания вложенных элементов
					skin.contextMenu = _contextMenu;
				}
			} else {
				// не было указано поле, детей которого надо выводить
				var modelClass : Class = getDefinitionByName(getQualifiedClassName(data)) as Class;
				var listAccessors : XML = DescribeTypeUtils.getOrderedAccessorsByArgumentInMetaDataList(modelClass, ["OneToMany"], "orderIndex");

				var accessors : XMLList = listAccessors.descendants("accessor");
				var accessorProperties : AccessorProperties;
				var accessor : XML;

				for (i = 0; i < accessors.length(); i++) {
					accessor = accessors[i];

					accessorProperties = new AccessorProperties();
					accessorProperties.parse(accessor);

					childView = new childViewClass(this);

					childData = new ORMTreeNodeData();
					childData.data = data;
					childData.property = accessorProperties.name;
					childData.label = accessorProperties.label;
					childView.data = childData;

					addChildView(childView);

					// modelToView[model] = childView;
				}
			}

			update();
		}

		private function onContextMenuItemSelectHandler(event : ContextMenuEvent) : void {
			var newNodeDefinition : Class = (_typeByContextMenuItem[event.target] as TreeNodeType).definition;
			var newNode : ORMTreeModel = new newNodeDefinition();

			var dataSpecified : ORMTreeNodeData = data as ORMTreeNodeData;
			newNode.parentListName = dataSpecified.property;
			newNode.parent = dataSpecified.data as ORMTreeModel;

			dispatchEvent(new TreeNodeViewBaseEvent(TreeNodeViewBaseEvent.ADD_CHILD, this, newNode, true));
		}

		override protected function getSkinClass() : Class {
			return ORMTreeNodeSkin;
		}

		override protected function onTreeNodeViewSelectHandler(event : TreeNodeViewBaseEvent) : void {
			super.onTreeNodeViewSelectHandler(event);

			if (event.nodeView.data is ORMTreeNodeData) {
				event.stopImmediatePropagation();
			}
		}
	}
}