package ru.saveidea.orm.forms {
	import ru.saveidea.orm.AccessorProperties;

	import flash.display.Sprite;
	import flash.events.Event;

	/**

	 * @author antonsidorenko
	 */
	public class BaseAttributeView extends Sprite {
		private var _value : Object;
		public var accessorProperties : AccessorProperties;

		public function BaseAttributeView(accessorProperties : AccessorProperties) {
			this.accessorProperties = accessorProperties;
		}

		public function get value() : Object {
			return _value;
		}

		public function set value(value : Object) : void {
			_value = value;
		}

		public function set data(value : Object) : void {
		}

		protected function onChange(event : Event = null) : void {
			dispatchEvent(new AttributeViewEvent(AttributeViewEvent.ON_CHANGE));
		}

		protected function onMakeChild(event : AttributeViewEvent) : void {
			dispatchEvent(new AttributeViewEvent(AttributeViewEvent.MAKE_CHILD, event.childModel, event.parentPropertyName));
		}
	}
}