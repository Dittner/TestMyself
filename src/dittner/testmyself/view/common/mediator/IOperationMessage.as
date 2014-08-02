package dittner.testmyself.view.common.mediator {
public interface IOperationMessage {
	function get data():Object;
	function get complete():Function;
	function get fail():Function;
}
}
