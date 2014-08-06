package dittner.testmyself.service.operation {
public class Phase {
	public function Phase() {
	}

	protected var nextPhase:Phase;
	protected var root:CompositePhase;

	public function addPhase(op:Phase):Phase {
		op.root = root;
		nextPhase = op;
		return nextPhase;
	}

	final public function execute():void {
		if (validate()) process();
	}

	//abstract
	protected function validate():Boolean {return true;}
	//abstract
	protected function process():void {}

	final protected function completeSuccess():void {
		if (nextPhase) nextPhase.execute();
		else root.completeCallback();
		destroy();
	}

	final protected function completeWithError(msg:String = ""):void {
		root.errorCallback(msg);
		destroy();
	}

	protected function destroy():void {
		nextPhase = null;
		root = null;
	}

}
}
