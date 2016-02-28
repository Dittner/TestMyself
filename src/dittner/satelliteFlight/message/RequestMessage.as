package dittner.satelliteFlight.message {
import dittner.async.IAsyncOperation;

public class RequestMessage implements IRequestMessage {
	public function RequestMessage(completeCallback:Function = null, data:Object = null) {
		_data = data;
		this.completeCallback = completeCallback;
	}

	private var completeCallback:Function;

	private var _data:Object;
	public function get data():Object { return _data; }

	public function onComplete(op:IAsyncOperation):void {
		if (completeCallback != null)  completeCallback(op);
	}

}
}
