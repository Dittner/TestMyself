package dittner.testmyself.command.core.operation {
public class PhaseOperation {
	public function PhaseOperation() {
	}

	internal var completeCallback:Function;
	internal var errorCallback:Function;

	//abstract
	public function execute():void {}

	final protected function completeSuccess():void {
		completeCallback();
		destroy();
	}

	final protected function completeWithError(msg:String = ""):void {
		errorCallback(msg);
		destroy();
	}

	protected function destroy():void {
		completeCallback = null;
		errorCallback = null;
	}

}
}
