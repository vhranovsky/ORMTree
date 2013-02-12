package ru.saveidea.orm.form {
	import ru.saveidea.orm.forms.ModelForm;
	import ru.saveidea.orm.forms.ModelFormBase;
	import ru.saveidea.orm.forms.ModelFormBaseEvent;
	import ru.saveidea.view.ManualSizedSprite;

	/**
	 * @author antonsidorenko
	 */
	public class ObjectForm extends ManualSizedSprite {
		
		private var path : ObjectPathModule;
		private var form : ModelFormBase;
		private var _data : Object;
		
		private var formClass : Class;

		public function ObjectForm(formClass : Class) {
			super();
			
			this.formClass = formClass;

			path = new ObjectPathModule();
			addChild(path);

			form = makeForm();
			form.addEventListener(ModelFormBaseEvent.SAVE, onFormSaveHandler);
			addChild(form);

			width = 500;
			height = 500;
		}

		private function onFormSaveHandler(event : ModelFormBaseEvent) : void {
			dispatchEvent(new ObjectFormEvent(ObjectFormEvent.SAVE));
		}

		protected function makeForm() : ModelFormBase {
			return new formClass();
		}

		override public function set width(value : Number) : void {
			super.width = value;
			update();
		}

		override public function set height(value : Number) : void {
			super.height = value;
			update();
		}

		private function update() : void {
			if (isNaN(width) || isNaN(height)) {
				return;
			}

			path.width = width;
			form.width = width;
			path.height = 30;
			form.y = 30;
			form.height = height - 30;
		}

		public function set data(data : Object) : void {
			_data = data;
			
			trace("FORM SET DATA", data);

			path.data = data;
			form.model = data;
		}

		public function clear() : void {
			form.clear();
			path.clear();
		}
	}
}
