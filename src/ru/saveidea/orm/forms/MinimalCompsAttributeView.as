package ru.saveidea.orm.forms {
	import ru.saveidea.orm.AccessorProperties;

	import flash.display.DisplayObject;

	/**
	 * @author antonsidorenko
	 */
	public class MinimalCompsAttributeView extends LabeledAttributeView {
		
		private static const ALIGN_RIGHT : String = "ALIGN_RIGHT";
		private static const ALIGN_LEFT : String = "ALIGN_LEFT";
		private static const ALIGN_WIDE : String = "ALIGN_WIDE";
		
		private var align : String;
		private var input : DisplayObject;
		
		public function MinimalCompsAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);
		}

		protected function alignInputRight(target : DisplayObject) : void {
			align = ALIGN_RIGHT;
			input = target;
			target.y = panel.height / 2 - target.height / 2;
			target.x = panel.width - target.width - _padding;
		}

		protected function alignInputLeft(target : DisplayObject) : void {
			align = ALIGN_LEFT;
			input = target;
			target.y = panel.height / 2 - target.height / 2;
			target.x = 100;
		}

		protected function expandInputWide(target : DisplayObject) : void {
			align = ALIGN_WIDE;
			input = target;
			target.x = 100;
			target.y = panel.height / 2 - target.height / 2;
			target.width = panel.width - 100 - _padding;
		}

		override public function set width(value : Number) : void {
			super.width = value;
			
			if (align==MinimalCompsAttributeView.ALIGN_LEFT) {
				alignInputLeft(input);
			}
			if (align==MinimalCompsAttributeView.ALIGN_RIGHT) {
				alignInputRight(input);
			}
			if (align==MinimalCompsAttributeView.ALIGN_WIDE) {
				expandInputWide(input);
			}
		}

	}
}