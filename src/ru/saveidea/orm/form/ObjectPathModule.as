package ru.saveidea.orm.form {
	import ru.saveidea.view.ManualSizedSprite;

	import com.bit101.components.Label;

	/**
	 * @author antonsidorenko
	 */
	public class ObjectPathModule extends ManualSizedSprite {
		
		private var _data : Object;
		private var label : Label;

		public function ObjectPathModule() {
			super();

			label = new Label();
			addChild(label);

			width = 500;
			height = 30;
		}

		public function set data(data : Object) : void {
			_data = data;

			var path : String = "";

			/*
			

			var nodeParent : ITreeNodeData = model.parent;

			if (nodeParent) {
			path = nodeParent.toString();
			while (nodeParent != null) {
			nodeParent = nodeParent.parent;
			if (nodeParent) {
			path = nodeParent.toString() + " > " + path;
			}
			}
			}
			 * 
			 */

			label.text = path;
		}

		public function clear() : void {
			label.text = "";
		}

		private function redraw() : void {
			graphics.beginFill(0xeeeeee);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();

			label.x = 5;
			label.width = width - 10;
			label.y = height / 2 - label.height / 2;
		}

		override public function set width(value : Number) : void {
			super.width = value;
			tryToRedraw();
		}

		override public function set height(value : Number) : void {
			super.height = value;
			tryToRedraw();
		}

		private function tryToRedraw() : void {
			if (!isNaN(width) && !isNaN(height)) {
				redraw();
			}
		}
	}
}