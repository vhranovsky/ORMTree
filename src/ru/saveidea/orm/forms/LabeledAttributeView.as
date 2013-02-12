package ru.saveidea.orm.forms {
	import ru.saveidea.orm.AccessorProperties;

	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	

	/**
	 * @author antonsidorenko
	 */
	public class LabeledAttributeView extends BaseAttributeView {
		
		protected var panel : Panel;
		protected var labelView : Label;
		private var _possibleValues : Object;
		private var _label : String;
		protected var _padding : Number;

		public function LabeledAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			init();

			labelView = new Label();
			labelView.y = panel.height / 2 - labelView.height / 2;
			labelView.x = _padding;
			addChild(labelView);
		}

		protected function init() : void {
			_padding = 10;

			panel = new Panel();
			panel.width = 300;
			panel.height = 50;
			//addChild(panel);
			redrawBackground();
		}

		private function redrawBackground() : void {
			
			return;
			
			graphics.clear();
			graphics.beginFill(0xffffff*Math.random(),0.2);
			graphics.drawRect(0, 0, panel.width, panel.height);
			graphics.endFill();
		}

		
		override public function set width(value : Number) : void {
			panel.width = value;
			redrawBackground();
		}
		
		override public function get width() : Number {
			return panel.width;
		}
		
		override public function get height() : Number {
			return panel.height;
		}

		public function set label(label : String) : void {
			_label = label;
			labelView.text = label;
		}

		public function set possibleValues(possibleValues : Object) : void {
			_possibleValues = possibleValues;
		}

	}
}