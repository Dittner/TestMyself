package dittner.testmyself.model.common {
import dittner.testmyself.command.backend.utils.SQLFactory;

public interface ITransUnitModel {

	function get dbName():String;
	function get sqlFactory():SQLFactory;
	function get transUnitClass():Class;

	function get pageInfo():IPageInfo;
	function set pageInfo(value:IPageInfo):void;

	function get themes():Array;
	function set themes(value:Array):void;

	function get dataBaseInfo():DataBaseInfo;
	function set dataBaseInfo(value:DataBaseInfo):void;

	function get selectedTransUnit():ITransUnit;
	function set selectedTransUnit(value:ITransUnit):void;

	function get filter():Array;
	function set filter(value:Array):void;

}
}
