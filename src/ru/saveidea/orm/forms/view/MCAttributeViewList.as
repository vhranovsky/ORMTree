package ru.saveidea.orm.forms.view {
	import ru.saveidea.minimalcomps.components.ScrollPaneExtended;
	import ru.saveidea.orm.forms.AttributeView;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author antonsidorenko
	 */
	public class MCAttributeViewList extends AttributeViewList {
		
		private var panel : ScrollPaneExtended;
		private var nextAttributeViewPosition : Number = 0;
		private var updateTimer : uint;

		public function MCAttributeViewList() {
			panel = new ScrollPaneExtended();
			panel.autoHideScrollBar = true;
			panel.dragContent = false;
			panel.mouseWheelEnabled = true;
			addChild(panel);

			super();
		}

		private function delayedUpdate() : void {
			clearTimeout(updateTimer);
			updateTimer = setTimeout(update, 50);
		}

		private function update() : void {
			panel.update();
			if (panel.isVisibleVerticalScroll()) {
				// делаем всех поменьше
				setAttributeViewsWidth(width - 10);
			} else {
				// делаем всех нормальными
				setAttributeViewsWidth(width);
			}
		}

		override public function addAttributeView(attributeView : AttributeView) : void {
			super.addAttributeView(attributeView);

			attributeView.width = width - 10;
			attributeView.y = nextAttributeViewPosition;
			nextAttributeViewPosition += attributeView.height;

			panel.addChild(attributeView);
			delayedUpdate();
		}
		
		
		override public function clear() : void {
			super.clear();
			nextAttributeViewPosition = 0;
		}

		override public function set width(value : Number) : void {
			super.width = value;
			panel.width = value;
		}

		override public function set height(value : Number) : void {
			super.height = value;
			panel.height = value;
		}
	}
}