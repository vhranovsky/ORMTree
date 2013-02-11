package ru.saveidea.ormtree.view {
	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeNodeData {
		
		private var _data : Object;
		private var _property : String;
		private var _label : String;

		public function get data() : Object {
			return _data;
		}

		public function set data(data : Object) : void {
			_data = data;
		}

		public function get property() : String {
			return _property;
		}

		public function set property(property : String) : void {
			_property = property;
		}

		public function get label() : String {
			return _label;
		}

		public function set label(label : String) : void {
			_label = label;
		}
		
	}
}