package ru.saveidea.orm.forms {
	import avmplus.getQualifiedClassName;

	import ru.saveidea.orm.AccessorProperties;
	import ru.saveidea.orm.DataTypeList;

	import com.bit101.components.ComboBox;

	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * @author antonsidorenko
	 */
	public class ManyToOneAttributeView extends MinimalCompsAttributeView {
		protected var combo : ComboBox;

		public function ManyToOneAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			trace("ManyToOneAttributeView", "content data type:", accessorProperties.contentDataType);

			combo = new ComboBox();
			combo.addEventListener(Event.SELECT, onSelectHandler);
			addChild(combo);
			expandInputWide(combo);
		}

		protected function onSelectHandler(event : Event) : void {
			if (accessorProperties.originalDataType == DataTypeList.STRING) {
				value = String(combo.selectedItem["data"]);
			} else {
				value = combo.selectedItem["data"];
			}
		}

		private function clear() : void {
			combo.removeEventListener(Event.SELECT, onSelectHandler);
			combo.selectedIndex = -1;
			combo.addEventListener(Event.SELECT, onSelectHandler);

			combo.removeAll();
		}

		override public function set data(value : Object) : void {
			clear();

			var item : Object;

			if (value is Array || getDefinitionByName("mx.collections::ArrayCollection") == getDefinitionByName(getQualifiedClassName(item))) {
				for (var i : int = 0; i < value["length"]; i++) {
					item = value[i];
					combo.addItem({label:String(item), data:item});
				}
			} else {
				throw new Error("Unknown data:" + value + " " + describeType(value));
			}
		}

		override public function set value(value : Object) : void {
			super.value = value;

			trace(accessorProperties.name, "set value", value, value is String);

			if (!value) {
				return;
			}

			if (combo.items.length == 0) {
				combo.addItem({data:value, label:String(value)});
			}

			var item : Object;

			var selectedIndex : Number;

			for (var i : int = 0; i < combo.items.length; i++) {
				item = combo.items[i];

				if (value is String) {
					if (String(item["data"]) == value) {
						selectedIndex = i;
						break;
					}
				} else {
					trace("OMG", item, item["data"]);
					if (item["data"]["id"] == value["id"]) {
						selectedIndex = i;
						break;
					}
				}
			}

			if (!isNaN(selectedIndex)) {
				combo.removeEventListener(Event.SELECT, onSelectHandler);
				combo.selectedIndex = selectedIndex;
				combo.addEventListener(Event.SELECT, onSelectHandler);
				onChange(null);
			}
		}
	}
}