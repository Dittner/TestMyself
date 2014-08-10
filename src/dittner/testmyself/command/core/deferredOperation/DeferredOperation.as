package dittner.testmyself.command.core.deferredOperation {
import dittner.testmyself.command.backend.common.exception.CommandException;

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

	final protected function dispatchCompleteSuccess(result:Object = null):void {
		for each(var handler:Function in completeCallbackQueue) result ? handler(result) : handler();
		completeCallbackQueue = null;
		destroy();
	}

	final protected function dispatchCompletWithError(exc:CommandException):void {
		for each(var handler:Function in errorCallbackQueue) handler(exc);
		errorCallbackQueue = null;
		destroy();
	}

}
}
