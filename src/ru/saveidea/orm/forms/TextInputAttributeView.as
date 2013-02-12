package ru.saveidea.orm.forms {
	import ru.saveidea.orm.AccessorProperties;

	import com.bit101.components.InputText;

	import flash.events.Event;

	/**
	 * @author antonsidorenko
	 */
	public class TextInputAttributeView extends MinimalCompsAttributeView {
		
		private var textInput : InputText;

		public function TextInputAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			textInput = new InputText();

			textInput.addEventListener(Event.CHANGE, aa);

			addChild(textInput);
			
			expandInputWide(textInput);
		}

		private function aa(event : Event) : void {
			onChange(event);
		}

		override public function set value(value : Object) : void {
			super.value = value;
			textInput.text = String(value);
		}

		override public function get value() : Object {
			return textInput.text;
		}
	}
}