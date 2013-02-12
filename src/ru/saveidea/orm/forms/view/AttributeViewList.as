package ru.saveidea.orm.forms.view {
	import ru.saveidea.orm.forms.AttributeView;

	/**
	 * @author antonsidorenko
	 */
	public class AttributeViewList extends ManualSizedSprite {
		
		private var attributeViewList : Array;

		public function AttributeViewList() {
			attributeViewList = [];
			width = 500;
			height = 300;
		}

		public function addAttributeView(attributeView : AttributeView) : void {
			attributeViewList.push(attributeView);
		}

		public function clear() : void {
			var attributeView : AttributeView;
			for (var i : int = 0; i < attributeViewList.length; i++) {
				attributeView = attributeViewList[i];
				attributeView.parent.removeChild(attributeView);
			}
			attributeViewList = [];
		}

		protected function setAttributeViewsWidth(value : Number) : void {
			var attributeView : AttributeView;
			for (var i : int = 0; i < attributeViewList.length; i++) {
				attributeView = attributeViewList[i];
				attributeView.width = value;
			}
		}

		override public function set width(value : Number) : void {
			super.width = value;
			var attributeView : AttributeView;
			for (var i : int = 0; i < attributeViewList.length; i++) {
				attributeView = attributeViewList[i];
				attributeView.width = value;
			}
		}
	}
}