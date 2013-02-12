package ru.saveidea.orm {
	import avmplus.getQualifiedClassName;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * @author antonsidorenko
	 */
	public class DBEntityManager {
		
		private static var _instance : DBEntityManager;
		private static var _allowToCreateInstance : Boolean = false;
		protected var classes : Object;
		private var objects : Object;
		private var saveThreads : int = 0;
		private var _debugLevel : int = 0;

		public function DBEntityManager() {
			if (!_allowToCreateInstance) {
				//throw new Error("DBEntityManager is Singletone, use DBEntityManager.instance");
			}

			classes = {};
			objects = {};
		}

		public static function get instance() : DBEntityManager {
			if (!_instance) {
				_allowToCreateInstance = true;
				_instance = new DBEntityManager();
				_allowToCreateInstance = false;
			}
			return _instance;
		}

		public function save(object : Object=null) : void {
			// проверка на наличие необходимых полей в классе, тега Id например
			
			if (!object) {
				saveToDisk(JSON.stringify(classes));
				return;
			}
			
			debug("save", object);

			saveThreads++;

			var className : String = getQualifiedClassName(object);

			if (classes[className] == null) {
				// создаем список инстансов этого класса
				if (!classes["differentClassesQuantity"]) {
					classes["differentClassesQuantity"] = 1;
				} else {
					classes["differentClassesQuantity"]++;
				}
				classes[className] = {classIndex:classes["differentClassesQuantity"], entities:{}, lastIndex:1};
			}

			if (object["id"] == 0) {
				object["id"] = classes[className]["lastIndex"];

				cacheObject(object);

				classes[className]["lastIndex"]++;
				classes[className]["entities"][object["id"]] = convertObjectToJSONObject(object);
			} else {
				// FIXME: Тут, наверное надо будет смотреть какие поля обновились, а какие нет, но сейчас положим на это хуй :)
				classes[className]["entities"][object["id"]] = convertObjectToJSONObject(object);
			}

			saveThreads--;
			
			if (saveThreads==0) {
				saveToDisk(JSON.stringify(classes));
			}
		}

		protected function debug(...args) : void {
			if (_debugLevel > 0) {
				trace(args);
			}
		}

		private function cacheObject(object : Object) : void {
			var qualifiedClassName : String = getQualifiedClassName(getDefinitionByName(getQualifiedClassName(object)));

			if (!objects[qualifiedClassName]) {
				objects[qualifiedClassName] = {};
			}
			objects[qualifiedClassName][object["id"]] = object;
			debug("CACHE OBJECT:", qualifiedClassName, object["id"]);
		}

		private function getCachedObject(definition : Class, id : int) : Object {
			var instance : Object;

			var qualifiedClassName : String = getQualifiedClassName(definition);

			if (objects[qualifiedClassName]) {
				instance = objects[qualifiedClassName][id];
				if (instance) {
					return instance;
				}
			}

			return null;
		}

		public function findAll(definition : Class) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();

			if (classes[getQualifiedClassName(definition)] != null) {
				var entities : Object = classes[getQualifiedClassName(definition)]["entities"];
				var entity : Object;

				for (var id : String in entities) {
					entity = entities[id];
					result.addItem(getObject(definition, int(id)));
				}
			}

			return result;
		}

		public function getObject(definition : Class, id : int) : Object {
			debug("getObject", definition, id);

			var instance : Object = getCachedObject(definition, id);

			if (instance) {
				debug("Return from cache");
				return instance;
			}

			debug("Not Found in cache");

			instance = new definition();
			if (classes[getQualifiedClassName(definition)] && classes[getQualifiedClassName(definition)]["entities"]) {
				var entity : Object = classes[getQualifiedClassName(definition)]["entities"][id];
			} else {
				return null;
			}

			if (entity) {
				instance["id"] = id;
				cacheObject(instance);

				var accessorsData : Array;
				var accessorProperties : AccessorProperties;

				var itemData : Array;

				accessorsData = getAccessorsData(instance);
				for (var j : int = 0; j < accessorsData.length; j++) {
					accessorProperties = accessorsData[j];
					if (isTransparentDataType(accessorProperties.dataType)) {
						instance[accessorProperties.name] = entity[accessorProperties.name];
					} else {
						if (accessorProperties.dataType == DataTypeList.MANY_TO_ONE) {
							itemData = entity[accessorProperties.name];
							if (itemData) {
								var itemClass : Class = getClassDefinitionByIndex(itemData[0]);
								instance[accessorProperties.name] = getObject(itemClass, itemData[1]);
							}
						} else if (accessorProperties.dataType == DataTypeList.ONE_TO_MANY) {
							var itemId : int;
							var itemClassIndex : int;
							var itemClassDefinition : Class;

							var idList : Array = entity[accessorProperties.name];
							instance[accessorProperties.name] = new ArrayCollection();
							for (var i : int = 0; i < idList.length; i++) {
								itemData = idList[i];
								itemId = itemData[1];
								itemClassIndex = itemData[0];
								itemClassDefinition = getClassDefinitionByIndex(itemClassIndex);
								if (!itemClassDefinition) {
									throw new Error("Cant fint definition, classIndex:" + itemClassIndex);
								}

								(instance[accessorProperties.name] as ArrayCollection).addItem(getObject(itemClassDefinition, itemId));
							}
						}
					}
				}
			} else {
				return null;
			}

			debug("Return instance", instance);

			return instance;
		}

		private function getClassDefinitionByIndex(classIndex : int) : Class {
			var classDefinition : Class;

			for (var className : String in classes) {
				// FIXME: Очень коряво, потом надо будет сделать settings & classes
				if (className != "differentClassesQuantity" && classes[className]["classIndex"] == classIndex) {
					classDefinition = getDefinitionByName(className) as Class;
					break;
				}
			}

			return classDefinition;
		}

		private function getAccessorsData(object : Object) : Array {
			var accessorsData : Array = [];

			var classDescription : XML = describeType(object);

			var accessorXMLList : XMLList = classDescription.descendants("accessor");
			var accessor : XML;
			var accessorProperties : AccessorProperties;

			for (var i : int = 0; i < accessorXMLList.length(); i++) {
				accessor = accessorXMLList[i];
				accessorProperties = new AccessorProperties();
				accessorProperties.parse(accessor);
				if (!accessorProperties.isTransient) {
					accessorsData.push(accessorProperties);
				}
			}
			return accessorsData;
		}

		private function isTransparentDataType(dataType : String) : Boolean {
			var transparentDataTypes : Array = [DataTypeList.INT, DataTypeList.STRING, DataTypeList.TEXTAREA, DataTypeList.BOOLEAN, DataTypeList.FILE];
			return transparentDataTypes.indexOf(dataType) > -1;
		}

		private function convertObjectToJSONObject(object : Object) : Object {
			var result : Object = {};

			var accessorsData : Array = getAccessorsData(object);
			var accessorProperties : AccessorProperties;

			var fieldContent : Object;
			var fieldData : Array;

			for (var i : int = 0; i < accessorsData.length; i++) {
				accessorProperties = accessorsData[i];

				fieldContent = object[accessorProperties.name];

				if (isTransparentDataType(accessorProperties.dataType)) {
					result[accessorProperties.name] = object[accessorProperties.name] || "";
				} else {
					if (accessorProperties.dataType == DataTypeList.MANY_TO_ONE) {
						// ссылка на один элемент

						if (fieldContent != null) {
							if (fieldContent["id"] == 0) {
								// Сохранить объект в базе данных
								save(fieldContent);
							}
							fieldData = [classes[getQualifiedClassName(fieldContent)]["classIndex"], fieldContent["id"]];

							result[accessorProperties.name] = fieldData;
						}
					} else if (accessorProperties.dataType == DataTypeList.ONE_TO_MANY) {
						// ссылка на много элементов
						result[accessorProperties.name] = [];
						var list : IList = fieldContent as IList;
						var listItem : Object;
						var listItemData : Array;
						if (list) {
							for (var ii : int = 0; ii < list.length; ii++) {
								listItem = list[ii];
								// if (!listItem["id"]) {
								// FIXME: Сейчас пересохраняются все уровни вложенности
								save(listItem);
								// }
								// Кладу массив, первый индекс которого, это номер класса в списке классов: а второй - айдишник элемента этого класса
								listItemData = [classes[getQualifiedClassName(listItem)]["classIndex"], listItem["id"]];
								(result[accessorProperties.name] as Array).push(listItemData);
							}
						}
					}
				}
			}
			debug("convertObjectToJSONObject", object, JSON.stringify(result));

			return result;
		}

		protected function saveToDisk(data : String = "") : void {
			
		}

		public function setData(data : String) : void {
			classes = JSON.parse(data);
		}

		public function set debugLevel(debugLevel : int) : void {
			_debugLevel = debugLevel;
		}
	}
}