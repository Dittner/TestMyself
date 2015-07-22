package dittner.testmyself.core.model.test {
public interface ITestTask {
	function get testID():int;
	function get noteID():int;
	function get correct():int;
	function get incorrect():int;
	function get complexity():int;
	function get isFailed():Boolean;
	function get lastTestedDate():Number;
}
}
