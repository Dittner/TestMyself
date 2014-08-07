package dittner.testmyself.view.common.mediator {
public interface IRequestMessage {
	function get data():Object;
	function get completeSuccess():Function;
	function get completeWithError():Function;
}
}
