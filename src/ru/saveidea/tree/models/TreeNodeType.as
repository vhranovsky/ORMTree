package ru.saveidea.tree.models {
	/**
	 * @author antonsidorenko
	 */
	public class TreeNodeType {
		
		private var _definition : Class;
		private var _name : String;
		
		public function TreeNodeType(definition : Class, name : String) {
			_definition = definition;
			_name = name;
		}

		public function get name() : String {
			return _name;
		}

		public function get definition() : Class {
			return _definition;
		}
		
	}
}