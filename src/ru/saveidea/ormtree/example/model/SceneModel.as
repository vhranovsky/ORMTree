package ru.saveidea.ormtree.example.model {
	import ru.saveidea.tree.models.TreeNodeType;

	import mx.collections.ArrayCollection;

	/**
	 * @author antonsidorenko
	 */
	[Bindable]
	public class SceneModel extends ORMTreeModel {
		
		[Mapped]
		public var title : String;
		[Mapped(dataType="File")]
		public var background : String;
		[Mapped]
		public var backgroundIsLooped : Boolean;
		[Mapped(dataType="File")]
		public var sound : String;
		private var _elements : ArrayCollection = new ArrayCollection();

		[OneToMany(indexed='true', lazy='true', isHidden='true')]
		public function set elements(value : ArrayCollection) : void {
			_elements = value;
		}

		public function get elements() : ArrayCollection {
			return _elements;
		}

		private var _widgets : ArrayCollection = new ArrayCollection();

		[OneToMany(indexed='true', lazy='true', isHidden='true')]
		public function set widgets(value : ArrayCollection) : void {
			_widgets = value;
		}

		public function get widgets() : ArrayCollection {
			return _widgets;
		}

		public function toString() : String {
			return title;
		}

		override public function allowedChildTypesForList(propertyName : String) : Vector.<TreeNodeType> {
			if (propertyName == "elements") {
				return new <TreeNodeType>[new TreeNodeType(Element, "Element")];
			}
			if (propertyName == "widgets") {
				return new <TreeNodeType>[new TreeNodeType(WidgetVideo, "WidgetVideo"), new TreeNodeType(WidgetHTMLData, "WidgetHTMLData")];
			}

			return null;
		}
	}
}