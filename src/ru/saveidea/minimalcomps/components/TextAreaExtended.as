package ru.saveidea.minimalcomps.components {
	import com.bit101.components.TextArea;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author antonsidorenko
	 */
	public class TextAreaExtended extends TextArea {
		
		public function TextAreaExtended(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, text : String = "") {
			super(parent, xpos, ypos, text);
			_scrollbar.tabChildren = false;
			_scrollbar.tabEnabled = false;
		}
		
	}
}