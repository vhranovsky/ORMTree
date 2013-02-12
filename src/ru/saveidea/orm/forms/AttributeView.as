package ru.saveidea.orm.forms {
	
	import ru.saveidea.orm.AccessorProperties;
	import ru.saveidea.orm.DataTypeList;

	/**
	 * @author antonsidorenko
	 */
	public class AttributeView extends BaseAttributeView {
		
		private var attributeView : LabeledAttributeView;
		private var _accessorProperties : AccessorProperties;

		public function AttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			_accessorProperties = accessorProperties;

			attributeView = makeAttributeView(accessorProperties);

			attributeView.addEventListener(AttributeViewEvent.ON_CHANGE, onChange);
			attributeView.addEventListener(AttributeViewEvent.MAKE_CHILD, onMakeChild);
			addChild(attributeView);
		}

		override public function get value() : Object {
			return attributeView.value;
		}

		override public function set value(value : Object) : void {
			attributeView.value = value;
		}

		override public function set data(value : Object) : void {
			attributeView.data = value;
		}
		
		override public function get height() : Number {
			return attributeView.height;
		}
		
		override public function set width(value : Number) : void {
			attributeView.width = value;
		}
		
		override public function get width() : Number {
			return attributeView.width;
		}

		protected function makeAttributeView(accessorProperties : AccessorProperties) : LabeledAttributeView {
			var resultAttributeView : LabeledAttributeView;

			var definitionsHash : Object = {};
			definitionsHash[DataTypeList.BOOLEAN] = BooleanAttributeView;
			definitionsHash[DataTypeList.FILE] = FileAttributeView;
			definitionsHash[DataTypeList.INT] = TextInputAttributeView;
			definitionsHash[DataTypeList.NUMBER] = TextInputAttributeView;
			definitionsHash[DataTypeList.STRING] = TextInputAttributeView;
			definitionsHash[DataTypeList.TEXTAREA] = TextAreaAttributeView;
			definitionsHash[DataTypeList.MANY_TO_ONE] = ManyToOneAttributeView;
			definitionsHash[DataTypeList.ONE_TO_MANY] = OneToManyAttributeView;

			var definition : Class = definitionsHash[accessorProperties.dataType];

			if (definition) {
				resultAttributeView = new definition(this.accessorProperties);
				resultAttributeView.label = accessorProperties.label;
			} else {
				throw new Error("Unknown Data Type:" + accessorProperties.accessor.toXMLString());
			}

			return resultAttributeView;
		}

		public function getCustomAttributeView() : BaseAttributeView {
			return attributeView;
		}
	}
}