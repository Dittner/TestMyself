package dittner.testmyself.service.operation {
public class CompositePhase extends Phase {
	public function CompositePhase() {
		root = this;
	}

	public var completeCallback:Function;
	public var errorCallback:Function;

	override protected function process():void {
		completeSuccess();
	}
}
}
