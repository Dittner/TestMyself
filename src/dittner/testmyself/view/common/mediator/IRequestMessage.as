package dittner.testmyself.view.common.mediator {
public interface IRequestMessage {
	function get data():Object;
	function get complete():Function;
	function get error():Function;
}
}
