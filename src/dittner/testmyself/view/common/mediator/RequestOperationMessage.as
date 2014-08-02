package dittner.testmyself.view.common.mediator {
public class RequestOperationMessage implements IOperationMessage {
	public function RequestOperationMessage(completeHandler:Function, data:Object = null, failHandler:Function = null) {
		_data = data;
		_complete = completeHandler;
		_fail = failHandler;
	}

	private var _data:Object;
	public function get data():Object { return _data; }

	private var _complete:Function;
	public function get complete():Function { return _complete; }

	private var _fail:Function;
	public function get fail():Function { return _fail; }

}
}
