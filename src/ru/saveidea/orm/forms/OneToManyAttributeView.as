package ru.saveidea.orm.forms {
	
	import ru.saveidea.orm.AccessorProperties;

	import com.bit101.components.PushButton;

	import flash.events.MouseEvent;

	/**
	 * @author antonsidorenko
	 */
	public class OneToManyAttributeView extends MinimalCompsAttributeView {
		
		private var addItem : PushButton;

		public function OneToManyAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);
			
			/*
			
			addItem = new PushButton();
			addItem.label = "Add";
			addItem.width = 50;

			combo.x = 100;
			combo.width = panel.width - 100 - _padding * 2 - addItem.width;
			combo.y = panel.height / 2 - combo.height / 2;

			addItem.x = combo.x + combo.width + _padding;
			addItem.y = panel.height / 2 - addItem.height / 2;

			addChild(addItem);

			addItem.addEventListener(MouseEvent.CLICK, onAddClickHandler);
			 * 
			 */
		}

		private function onAddClickHandler(event : MouseEvent) : void {
			// создать новый экземпляр нужного нам класса
			var itemDefinition : Class = accessorProperties.contentDataType;
			var item : Object = new itemDefinition();

			dispatchEvent(new AttributeViewEvent(AttributeViewEvent.MAKE_CHILD, item, accessorProperties.parentPropertyName));
		}
	}
}