package ru.saveidea.ormtree.view {
	import flash.events.ContextMenuEvent;
	import flash.utils.Dictionary;
	import flash.ui.ContextMenu;
	import ru.saveidea.ormtree.example.model.ORMTreeModel;
	import flash.ui.ContextMenuItem;
	import ru.saveidea.tree.models.TreeNodeType;
	import ru.saveidea.orm.AccessorProperties;
	import ru.saveidea.orm.utils.DescribeTypeUtils;

	import mx.collections.ArrayCollection;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeNodeView extends TreeNodeViewBase {
		
		private var _contextMenu : ContextMenu;
		private var _typeByContextMenuItem : Dictionary;
		
		public function ORMTreeNodeView(parentNodeView : TreeNodeViewBase) {
			super(parentNodeView);
		}

		override public function set data(data : Object) : void {
			super.data = data;

			var childViewClass : Class = getChildNodeViewClass();
			var childView : TreeNodeViewBase;
			var childData : ORMTreeNodeData;
			var dataSpecified : ORMTreeNodeData;

			var i : int = 0;

			if (data is ORMTreeNodeData) {
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
			dispatchEvent(new TreeNodeViewBaseEvent(TreeNodeViewBaseEvent.ADD_CHILD, _typeByContextMenuItem[event.target], null, true));
		}
		
		override protected function getSkinClass() : Class {
			return ORMTreeNodeSkin;
		}
		
	}
}