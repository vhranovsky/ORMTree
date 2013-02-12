package ru.saveidea.view {
	
	import flash.display.Sprite;

	/**
	 * @author antonsidorenko
	 */
	public class ManualSizedSprite extends Sprite {
		
		private var _width : Number;
		private var _height : Number;
		
		public function ManualSizedSprite() {
			
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set width(value : Number) : void {
			_width = value;
		}

		override public function get height() : Number {
			return _height;
		}

		override public function set height(value : Number) : void {
			_height = value;
		}
		
	}
}