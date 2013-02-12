package ru.saveidea.tree.view {
	import flash.display.Sprite;

	/**
	 * @author antonsidorenko
	 */
	public class TreeNodeSkinBase extends Sprite {
		
		protected var view : TreeNodeViewBase;
		
		private var _data : Object;
		
		protected var currentState : String;
		
		public function TreeNodeSkinBase(view : TreeNodeViewBase) {
			this.view = view;
		}

		public function get data() : Object {
			return _data;
		}

		public function set data(data : Object) : void {
			_data = data;
		}

		//Calling by view
		public function changeState(state : String) : void {
			currentState = state;
		}

		public function update() : void {
			
		}

		public function destroy() : void {
			
		}
		
	}
}