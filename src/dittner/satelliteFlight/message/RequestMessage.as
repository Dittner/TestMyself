package dittner.satelliteFlight.message {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;

public class RequestMessage implements IRequestMessage {
	public function RequestMessage(completeCallback:Function = null, errorCallback:Function = null, data:Object = null) {
		_data = data;
		this.completeCallback = completeCallback;
		this.errorCallback = errorCallback;
	}

	private var completeCallback:Function;
	private var errorCallback:Function;

	private var _data:Object;
	public function get data():Object { return _data; }

	public function completeSuccess(res:CommandResult):void {
		if (completeCallback != null)  completeCallback(res);
	}

	public function completeWithError(exc:CommandException):void {
		if (errorCallback != null)  errorCallback(exc);
	}

}
}
