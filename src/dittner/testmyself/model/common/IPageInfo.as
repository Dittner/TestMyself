package dittner.testmyself.model.common {
public interface IPageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get transUnits():Array;
	function get filter():Array;

	function get selectedTransUnit():ITransUnit;
	function set selectedTransUnit(value:ITransUnit):void;
}
}
