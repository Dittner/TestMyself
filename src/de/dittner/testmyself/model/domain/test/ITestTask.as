package de.dittner.testmyself.model.domain.test {
public interface ITestTask {
	function get testID():int;
	function get noteID():int;
	function get complexity():int;
	function get isFailed():Boolean;
	function get lastTestedDate():Number;
}
}
