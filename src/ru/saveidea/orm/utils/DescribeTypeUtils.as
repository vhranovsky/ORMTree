package ru.saveidea.orm.utils {
	import flash.utils.describeType;

	/**
	 * @author antonsidorenko
	 */
	public class DescribeTypeUtils {
		
		/*
		 * Метод сортирует accessor'ы по аргументу в перечисленных мета-тегах
		 */
		public static function getOrderedAccessorsByArgumentInMetaDataList(definition : Class, metaDataNames : Array, argumentKey : String) : XML {
			var temp : Array = [];

			var classDescription : XML = describeType(definition);
			
			var accessorXMLList : XMLList = classDescription.descendants("accessor");
			var accessor : XML;
			var metaDataName : String;
			var metaDataArgumentXMLList : XMLList;
			var argumentsXMLList : XMLList;
			var argumentKeyValue : Number;
			var containAtLeastOnMetaData : Boolean = false;
			accessorsLoop:
			for (var i : int = 0; i < accessorXMLList.length(); i++) {
				accessor = accessorXMLList[i];
				argumentKeyValue = NaN;
				containAtLeastOnMetaData = false;
				metaDataLoop:
				for (var ii : int = 0; ii < metaDataNames.length; ii++) {
					metaDataName = metaDataNames[ii];
					metaDataArgumentXMLList = accessor..descendants("metadata").(@name == metaDataName);
					if (metaDataArgumentXMLList.length() > 0) {
						argumentsXMLList = XML(metaDataArgumentXMLList[0]).descendants("arg").(@key == argumentKey);
						if (argumentsXMLList.length() > 0) {
							argumentKeyValue = parseInt(XML(argumentsXMLList[0]).attribute("value"));

							break metaDataLoop;
						}
						containAtLeastOnMetaData = true;
					} else {
						continue metaDataLoop;
					}
				}
				if (containAtLeastOnMetaData) {
					temp.push({"argumentKey":argumentKeyValue, "accessor":accessor});
				}
			}

			temp.sortOn("argumentKey");

			var accessors : XMLList = new XMLList("<accessors></accessors>");
			for (var j : int = 0; j < temp.length; j++) {
				accessor = temp[j]["accessor"];
				accessors.appendChild(temp[j]["accessor"]);
			}

			return XML(accessors);
		}
	}
}