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
		
		[ManyToOne(isHidden="true")]
		public var parent : Object;
		
		[Mapped(isHidden="true")]
		public var parentListName : String;
	
		[Transient]
		public function allowedChildTypesForList(propertyName : String) : Vector.<TreeNodeType> {
			propertyName;
			return null;
		}
	}
}