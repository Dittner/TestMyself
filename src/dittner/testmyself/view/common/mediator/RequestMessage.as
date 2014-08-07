package dittner.testmyself.view.common.mediator {
public class RequestMessage implements IRequestMessage {
	public function RequestMessage(completeCallback:Function, errorCallback:Function = null, data:Object = null) {
		_data = data;
		_completeSuccess = completeCallback;
		_completeWithError = errorCallback;
	}

	private var _data:Object;
	public function get data():Object { return _data; }

	private var _completeSuccess:Function;
	public function get completeSuccess():Function { return _completeSuccess; }

	private var _completeWithError:Function;
	public function get completeWithError():Function { return _completeWithError; }

}
}
