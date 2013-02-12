package ru.saveidea.orm.forms {
	import ru.saveidea.minimalcomps.components.TextAreaExtended;
	import ru.saveidea.orm.AccessorProperties;

	/**
	 * @author antonsidorenko
	 */
	public class TextAreaAttributeView extends MinimalCompsAttributeView {
		
		private var textArea : TextAreaExtended;

		public function TextAreaAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			textArea = new TextAreaExtended();
			textArea.textField.wordWrap = true;
			addChild(textArea);

			textArea.height = 100;

			panel.height = textArea.height + _padding * 2;

			// panel.addChild(textArea);
			expandInputWide(textArea);

			labelView.y = panel.height / 2 - labelView.height / 2;

			textArea.y = _padding;
		}

		override public function set value(value : Object) : void {
			super.value = value;
			textArea.text = String(value);
		}

		override public function get value() : Object {
			return textArea.text;
		}
	}
}