package de.dittner.testmyself.model.page {
import de.dittner.testmyself.model.domain.test.TestSpec;

public interface ITestPageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get tasks():Array;
	function get notes():Array;
	function get testSpec():TestSpec;
}
}
