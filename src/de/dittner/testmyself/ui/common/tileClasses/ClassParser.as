package de.dittner.testmyself.ui.common.tileClasses {
import flash.utils.describeType;

public class ClassParser {

	public static function parseEnumReturnValues(enumClass:Class):Array {
		var xml:XML = describeType(enumClass);
		var values:Array = [];
		var names:Array = xml.constant.@name.toXMLString().split('\n');

		for (var i:int = 0; i < names.length; i++)
			values.push(enumClass[names[i]]);
		return values;
	}

	/**
	 * Парсит класс enumClass с статическими константами типа EnumClass.CONSTANT1, возвращает объект вида { CONSTANT1: value1,  CONSTANT2: value2 }
	 * @param enumClass
	 * @return Object
	 *
	 */
	public static function parseEnumReturnNamesAndValues(enumClass:Class):Object {
		var xml:XML = describeType(enumClass);
		var names:Array = xml.constant.@name.toXMLString().split('\n');
		var namesAndValues:Object = {};
		var name:String;
		for (var i:int = 0; i < names.length; i++) {
			namesAndValues[names[i]] = enumClass[names[i]];
		}
		return namesAndValues;
	}

}
}
