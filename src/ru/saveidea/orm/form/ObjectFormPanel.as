package ru.saveidea.orm.form {
	import com.bit101.components.Panel;

	/**
	 * @author antonsidorenko
	 */
	public class ObjectFormPanel extends Panel {
		
		private var _data : Object;
		private var form : ObjectForm;

		public function ObjectFormPanel(formClass : Class) {
			form = new ObjectForm(formClass);
			form.width = 800;
			form.height = 500;

			form.addEventListener(ObjectFormEvent.SAVE, onModelSaveHandler);
			addChild(form);
		}

		private function onModelSaveHandler(event : ObjectFormEvent) : void {
			dispatchEvent(new ObjectFormPanelEvent(ObjectFormPanelEvent.SAVE, _data));
		}

		public function set data(data : Object) : void {
			_data = data;
			form.data = data;
		}

		override public function set width(w : Number) : void {
			super.width = w;
			form.width = w;
		}

		override public function set height(h : Number) : void {
			super.height = h;
			form.height = h;
		}
	}
}