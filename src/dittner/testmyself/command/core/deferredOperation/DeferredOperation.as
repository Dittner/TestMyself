package dittner.testmyself.command.core.deferredOperation {

public class DeferredOperation implements IDeferredOperation {
	public function DeferredOperation() {}

	private var completeCallback:Function;
	public function addCompleteCallback(handler:*):void {
		completeCallback = handler;
	}

	/*abstract*/
	public function process():void {}

	/*abstract*/
	protected function destroy():void {}

	final protected function dispatchComplete():void {
		completeCallback();
		completeCallback = null;
		destroy();
	}

}
}
