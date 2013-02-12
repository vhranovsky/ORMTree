package ru.saveidea.minimalcomps.components {
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author antonsidorenko
	 */
	public class ScrollPaneExtended extends ScrollPane {
		
		private var _mouseWheelEnabled : Boolean = false;
		
		public function ScrollPaneExtended(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0) {
			super(parent, xpos, ypos);
			_vScrollbar.tabEnabled = false;
			_vScrollbar.tabChildren = false;
			_hScrollbar.tabEnabled = false;
			_hScrollbar.tabChildren = false;
		}

		public function isVisibleVerticalScroll() : Boolean {
			return _vScrollbar.visible;
		}

		public function get mouseWheelEnabled() : Boolean {
			return _mouseWheelEnabled;
		}

		public function set mouseWheelEnabled(mouseWheelEnabled : Boolean) : void {
			_mouseWheelEnabled = mouseWheelEnabled;
			if (mouseWheelEnabled) {
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			} else {
				removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			}
		}

		private function onMouseWheelHandler(event : MouseEvent) : void {
			var bounds : Rectangle = new Rectangle(0, 0, Math.min(0, _width - content.width), Math.min(0, _height - content.height));
			
			content.y+=event.delta;
			if (content.y<bounds.height) {
				content.y = bounds.height;
			}
			if (content.y>0) {
				content.y = 0;
			}
			onMouseMove(null);
			
		}
	}
}