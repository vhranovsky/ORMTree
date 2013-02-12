package ru.saveidea.ormtree.manager {
	import ru.saveidea.orm.form.ObjectFormPanelEvent;
	import ru.saveidea.ormtree.example.model.ORMTreeModel;
	import ru.saveidea.tree.manager.TreeManager;

	import mx.collections.ArrayCollection;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeManager extends TreeManager {
		
		public function ORMTreeManager(treeNodeClass : Class, formClass : Class) {
			super(treeNodeClass, formClass);
		}

		override protected function onObjectSaveHandler(event : ObjectFormPanelEvent) : void {
			
			// Если в папином списке элементов нету нового элемента, нужно добавить!
			
			var data : ORMTreeModel = event.model as ORMTreeModel;
			if (data.parent && data.parentListName) {
				var parentList : Array = (data.parent[data.parentListName] as ArrayCollection).source;

				if (parentList.indexOf(data) == -1) {
					parentList.push(data);
				}
			}

			super.onObjectSaveHandler(event);
		}
	}
}