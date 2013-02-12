package ru.saveidea.ormtree.example.admin {
	import ru.saveidea.view.ManualSizedSprite;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author antonsidorenko
	 */
	public class Header extends ManualSizedSprite {
		
		private var textfield : TextField;
		private var _title : String;
		private var h : Number = 50;

		public function Header(title : String) {
			width = 500;
			height = h;

			textfield = new TextField();
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.selectable = false;
			var dtf : TextFormat = new TextFormat("Arial", 25);
			textfield.defaultTextFormat = dtf;

			addChild(textfield);

			textfield.x = 10;

			this.title = title;
		}

		public function set title(title : String) : void {
			_title = title;
			textfield.text = title;
			textfield.y = h / 2 - textfield.height / 2;
		}
	}
}