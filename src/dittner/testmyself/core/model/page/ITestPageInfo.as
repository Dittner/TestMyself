package dittner.testmyself.core.model.page {
public interface ITestPageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get tasks():Array;
	function get notes():Array;
	function get filter():Array;
}
}
