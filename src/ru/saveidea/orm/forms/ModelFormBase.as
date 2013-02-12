package ru.saveidea.orm.forms {
	import flash.utils.getQualifiedClassName;
	import ru.saveidea.orm.AccessorProperties;
	import ru.saveidea.orm.forms.view.AttributeViewList;
	import ru.saveidea.orm.forms.view.MCAttributeViewList;
	import ru.saveidea.orm.utils.DescribeTypeUtils;
	import ru.saveidea.view.ManualSizedSprite;

	import com.bit101.components.PushButton;

	import flash.events.MouseEvent;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * @author antonsidorenko
	 * 
	 * Нужен, для того, чтобы использовать его в локальных проектах, для быстрого создания интерфейсов для редактирование полей сущностей (не содержит File)
	 */
	public class ModelFormBase extends ManualSizedSprite {
		private var _model : Object;
		private var modelClass : Class;
		private var modelAccessors : XML;
		private var attributeViews : Array;
		protected var attributeByName : Object;
		private var save : PushButton;
		private var attributeViewList : AttributeViewList;

		public function ModelFormBase() {
			/*
			 * Получает модель, пробегается по полям, строит форму, 
			 * каждому полю свой AttrbuteView, указывает текущее
			 * значение для attributeView на базе заполненных данных в моделе
			 * 
			 * 
			 * 
			 */

			attributeViewList = makeAttributeViewList();
			addChild(attributeViewList);

			attributeViews = [];
			attributeByName = {};

			// mainPanel = new Panel();
			// mainPanel.width = 500;
			// mainPanel.height = 500;
			// addChild(mainPanel);

			// attributesPanel = new ScrollPane();
			// attributesPanel.autoHideScrollBar = true;

			// attributesPanel.x = 10;
			// attributesPanel.y = 30;
			// attributesPanel.width = mainPanel.width - attributesPanel.x * 2;
			// attributesPanel.height = mainPanel.height - attributesPanel.y - 40;
			// addChild(attributesPanel);

			save = new PushButton();
			save.addEventListener(MouseEvent.CLICK, onSaveClickHandler);
			save.label = "Save";
			// save.x = mainPanel.width - save.width - 10;
			// save.y = mainPanel.height - save.height - 10;
			addChild(save);
		}

		protected function makeAttributeViewList() : AttributeViewList {
			return new MCAttributeViewList();
		}

		private function onSaveClickHandler(event : MouseEvent) : void {
			trace("ModelFormBase.onSaveClickHandler(event)");

			// сохранить модель
			// еще раз пробегаю по всем полям и забираю данные из просмотровщиков аттрибутов

			var accessors : XMLList = modelAccessors.descendants("accessor");
			var accessor : XML;
			for (var i : int = 0; i < accessors.length(); i++) {
				accessor = accessors[i];
				if (accessor.attribute("name") != "prototype" && accessor.attribute("name") != "id") {
					updateModelAttributeFromView(accessor);
				}
			}

			dispatchEvent(new ModelFormBaseEvent(ModelFormBaseEvent.SAVE));
		}

		protected function updateModelAttributeFromView(accessor : XML) : void {
			var attributeView : AttributeView = attributeByName[accessor.attribute("name")];

			if (!attributeView) {
				return;
			}

			model[accessor.attribute("name")] = attributeView.value;
		}

		public function clear() : void {
			var attributeView : AttributeView;
			for (var i : int = 0; i < attributeViews.length; i++) {
				attributeView = attributeViews[i];
				attributeView.removeEventListener(AttributeViewEvent.ON_CHANGE, onAttributeChange);
				attributeView.removeEventListener(AttributeViewEvent.MAKE_CHILD, onMakeChild);
			}
			attributeByName = {};
			attributeViews = [];
			attributeViewList.clear();
		}

		public function set model(model : Object) : void {
			clear();

			_model = model;

			modelClass = getDefinitionByName(getQualifiedClassName(model)) as Class;

			modelAccessors = DescribeTypeUtils.getOrderedAccessorsByArgumentInMetaDataList(modelClass, ["Mapped", "ManyToOne", "OneToMany"], "orderIndex");

			var accessors : XMLList = modelAccessors.descendants("accessor");

			var accessor : XML;
			for (var i : int = 0; i < accessors.length(); i++) {
				accessor = accessors[i];
				if (isEditableAccessor(accessor)) {
					addAttributeField(accessor);
				}
			}
		}

		private function isEditableAccessor(accessor : XML) : Boolean {
			var isEditable : Boolean = true;

			var accessorProperties : AccessorProperties = new AccessorProperties();
			accessorProperties.parse(accessor);

			if (accessorProperties.isHidden || accessor.attribute("name") == "prototype") {
				return false;
			}
			if (accessorProperties.containMetaData("Id")) {
				return false;
			}
			if (accessorProperties.containMetaData("Transient")) {
				return false;
			}

			return isEditable;
		}

		protected function addAttributeField(accessor : XML) : void {
			var accessorProperties : AccessorProperties = new AccessorProperties();
			accessorProperties.parse(accessor);

			trace("addAttributeField", accessorProperties.name);

			var attributeField : AttributeView = makeAttributeView(accessorProperties);
			attributeField.value = _model[accessorProperties.name];

			attributeField.addEventListener(AttributeViewEvent.ON_CHANGE, onAttributeChange);
			attributeField.addEventListener(AttributeViewEvent.MAKE_CHILD, onMakeChild);

			attributeViewList.addAttributeView(attributeField);

			attributeViews.push(attributeField);

			tryToProvideData(attributeField);

			attributeByName[accessorProperties.name] = attributeField;
		}

		protected function makeAttributeView(accessorProperties : AccessorProperties) : AttributeView {
			return new AttributeView(accessorProperties);
		}

		private function onMakeChild(event : AttributeViewEvent) : void {
			var childModelForm : ModelFormBase = new ModelFormBase();

			if (event.parentPropertyName) {
				event.childModel[event.parentPropertyName] = model;
			}

			childModelForm.model = event.childModel;

			addChild(childModelForm);
		}

		private function tryToProvideData(attributeView : AttributeView) : void {
			if (attributeView.accessorProperties.dataProvider) {
				// нужно обновить
				var dataProviderArray : Array = attributeView.accessorProperties.dataProvider.split(".");

				try {
					var object : Object = (attributeByName[dataProviderArray[0]] as AttributeView).value;

					for (var ii : int = 1; ii < dataProviderArray.length; ii++) {
						object = object[dataProviderArray[ii]];
					}
				} catch (e : Error) {
					// данные недоступны
				}
				if (object) {
					attributeView.data = object;
				}
			}
		}

		private function onAttributeChange(event : AttributeViewEvent) : void {
			var target : AttributeView = event.currentTarget as AttributeView;

			var attributeView : AttributeView;
			for (var i : int = 0; i < attributeViews.length; i++) {
				attributeView = attributeViews[i];
				if (attributeView.accessorProperties.dataProvider && attributeView.accessorProperties.dataProvider.split(".")[0] == target.accessorProperties.name) {
					// нужно обновить

					tryToProvideData(attributeView);
				}
			}
		}

		public function get model() : Object {
			return _model;
		}

		override public function set width(value : Number) : void {
			super.width = value;
			attributeViewList.width = value;
			save.x = value - save.width - 10;
		}

		override public function set height(value : Number) : void {
			super.height = value;

			save.y = value - save.height - 10;

			attributeViewList.height = value - save.height - 20;
		}
	}
}