package ru.saveidea.ormtree.example.model {
	import ru.saveidea.tree.models.TreeNodeType;
	/**
	 * @author antonsidorenko
	 */
	
	[Bindable]
	public class ORMTreeModel {
		
		[Id]
		[Mapped]
		public var id : int;
		
		[Transient]
		public function allowedChildTypesForList(propertyName : String) : Vector.<TreeNodeType> {
			propertyName;
			return null;
		}
		
		
		
	}
}