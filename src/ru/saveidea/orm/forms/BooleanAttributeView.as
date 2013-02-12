package ru.saveidea.orm.forms {
	import ru.saveidea.orm.AccessorProperties;

	import com.bit101.components.CheckBox;

	import flash.events.MouseEvent;

	/**
	 * @author antonsidorenko
	 */
	public class BooleanAttributeView extends MinimalCompsAttributeView {
		
		private var checkbox : CheckBox;

		public function BooleanAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			checkbox = new CheckBox();
			checkbox.addEventListener(MouseEvent.CLICK, onCheckboxClickHandler);
			addChild(checkbox);

			alignInputRight(checkbox);
		}

		private function onCheckboxClickHandler(event : MouseEvent) : void {
			super.value = checkbox.selected;
		}

		override public function set value(value : Object) : void {
			super.value = value;
			checkbox.selected = value as Boolean;
		}
	}
}