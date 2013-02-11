package ru.saveidea.ormtree.example.model {
	import ru.saveidea.tree.models.TreeNodeType;
	import mx.collections.ArrayCollection;
	import ru.saveidea.ormtree.example.model.ORMTreeModel;

	/**
	 * @author antonsidorenko
	 */
	[Bindable]
	public class CourseModel extends ORMTreeModel {
		
		[Mapped]
		public var title : String;
		
		private var _scenes : ArrayCollection = new ArrayCollection();

		[OneToMany(indexed='true', lazy='true', isHidden='true')]
		public function set scenes(value : ArrayCollection) : void {
			_scenes = value;
		}

		public function get scenes() : ArrayCollection {
			return _scenes;
		}
		
		override public function allowedChildTypesForList(propertyName : String) : Vector.<TreeNodeType> {
			if (propertyName == "scenes") {
				return new <TreeNodeType>[new TreeNodeType(SceneModel, "Scene")];
			}
			
			return null;
		}
		
		public function toString() : String {
			return title;
		}
		
	}
}