package dittner.testmyself.core.command.backend.deferredOperation {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;

public class DeferredOperation implements IDeferredOperation {
	public function DeferredOperation() {}

	private var completeCallbackQueue:Array = [];
	public function addCompleteCallback(handler:Function):void {
		completeCallbackQueue.push(handler);
	}

	private var errorCallbackQueue:Array = [];
	public function addErrorCallback(handler:Function):void {
		errorCallbackQueue.push(handler);
	}

	/*abstract*/
	public function process():void {}

	/*abstract*/
	protected function destroy():void {}

	final protected function dispatchCompleteSuccess(result:CommandResult):void {
		for each(var handler:Function in completeCallbackQueue) handler(result);
		completeCallbackQueue = null;
		destroy();
	}

	final protected function dispatchCompleteWithError(exc:CommandException):void {
		for each(var handler:Function in errorCallbackQueue) handler(exc);
		errorCallbackQueue = null;
		destroy();
	}

}
}