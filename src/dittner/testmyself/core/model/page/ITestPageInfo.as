package dittner.testmyself.core.model.page {
import dittner.testmyself.core.model.test.TestSpec;

public interface ITestPageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get tasks():Array;
	function get notes():Array;
	function get testSpec():TestSpec;
}
}
