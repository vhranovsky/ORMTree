package ru.saveidea.orm {
	import flash.utils.getDefinitionByName;
	/**
	 * @author antonsidorenko
	 */
	public class AccessorProperties {
		
		private var _name : String;
		private var _label : String;
		private var _originalDataType : String;
		private var _dataType : String;
		private var _orderIndex : int;
		private var _isHidden : Boolean;
		private var _dataProvider : String;
		private var actualMeta : XML;
		private var _contentDataType : Class;
		private var _parentPropertyName : String;
		private var _isTransient : Boolean;
		
		private var _parentListName : String;
		
		private var _accessor : XML;

		public function parse(accessor : XML) : void {
			_accessor = accessor;
			_name = accessor.attribute("name");

			// Если тег Mapped, то здесь возьмётся базовый аттрибут
			if (accessor.hasOwnProperty("@type")) {
				_originalDataType = _dataType = accessor.attribute("type");
			}

			var extensionDataType : XML;

			var mappedMeta : XML = accessor.descendants("metadata").(@name == "Mapped")[0];
			if (mappedMeta) {
				actualMeta = mappedMeta;
				extensionDataType = actualMeta.descendants("arg").(@key == "dataType")[0];
				if (extensionDataType) {
					// Если тег Mapped и аттрибут перегружен — возьмётся он
					_dataType = extensionDataType.attribute("value");
				}
				//return;
			}

			var oneToManyMeta : XML = accessor.descendants("metadata").(@name == "OneToMany")[0];
			if (oneToManyMeta) {
				actualMeta = oneToManyMeta;
				
				_dataType = DataTypeList.ONE_TO_MANY;
				
				//FIXME:Нужно ли вообще указывать тип данных у списка?
				var contentDataTypeArg : XML = actualMeta.descendants("arg").(@key == "type")[0];
				if (contentDataTypeArg) {
					_contentDataType = getDefinitionByName(contentDataTypeArg.attribute("value")) as Class;
				}
				
				var parentPropertyNameArg : XML = actualMeta.descendants("arg").(@key == "parentPropertyName")[0];
				if (parentPropertyNameArg) {
					_parentPropertyName = parentPropertyNameArg.attribute("value");
				}
			}

			var manyToOneMeta : XML = accessor.descendants("metadata").(@name == "ManyToOne")[0];
			if (manyToOneMeta) {
				actualMeta = manyToOneMeta;
				_dataType = DataTypeList.MANY_TO_ONE;
				_contentDataType = getDefinitionByName(_originalDataType) as Class;
			}

			if (actualMeta) {
				var labelArgument : XML = actualMeta.descendants("arg").(@key == "label")[0];
				_label = labelArgument ? labelArgument.attribute("value") : _name;

				var orderIndexArgument : XML = actualMeta.descendants("arg").(@key == "orderIndex")[0];
				_orderIndex = orderIndexArgument ? parseInt(orderIndexArgument.attribute("value")) : 0;

				var isHiddenArgument : XML = actualMeta.descendants("arg").(@key == "isHidden")[0];
				_isHidden = isHiddenArgument ? Boolean(isHiddenArgument.attribute("value")) : false;
				
				var dataProviderArgument : XML = actualMeta.descendants("arg").(@key == "dataProvider")[0];
				_dataProvider = dataProviderArgument ? dataProviderArgument.attribute("value") : null;
				
				var parenListNameArgument : XML = actualMeta.descendants("arg").(@key == "parentListName")[0];
				_parentListName = parenListNameArgument ? parenListNameArgument.attribute("value") : null;
			}
			
			var transientMeta : XML = accessor.descendants("metadata").(@name == "Transient")[0];
			if (transientMeta) {
				_isTransient = true;
			}
		}
		
		public function containMetaData(metaDataName : String) : Boolean {
			return accessor.descendants("metadata").(@name == metaDataName).length() > 0;
		}

		public function getParameter(parameterName : String) : Object {
			var parameterArgument : XML = actualMeta.descendants("arg").(@key == parameterName)[0];
			return parameterArgument ? parameterArgument.attribute("value") : null;
		}

		public function get name() : String {
			return _name;
		}

		public function get label() : String {
			return _label;
		}

		public function get dataType() : String {
			return _dataType;
		}

		public function get orderIndex() : int {
			return _orderIndex;
		}

		public function get isHidden() : Boolean {
			return _isHidden;
		}

		public function get accessor() : XML {
			return _accessor;
		}

		public function get dataProvider() : String {
			return _dataProvider;
		}

		public function get originalDataType() : String {
			return _originalDataType;
		}

		public function get contentDataType() : Class {
			return _contentDataType;
		}

		public function get parentPropertyName() : String {
			return _parentPropertyName;
		}

		public function get isTransient() : Boolean {
			return _isTransient;
		}
		
	}
}