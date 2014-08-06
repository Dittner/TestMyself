package dittner.testmyself.view.common.mediator {
public class RequestMessage implements IRequestMessage {
	public function RequestMessage(completeCallback:Function, errorCallback:Function = null, data:Object = null) {
		_data = data;
		_complete = completeCallback;
		_error = errorCallback;
	}

	private var _data:Object;
	public function get data():Object { return _data; }

	private var _complete:Function;
	public function get complete():Function { return _complete; }

	private var _error:Function;
	public function get error():Function { return _error; }

}
}
