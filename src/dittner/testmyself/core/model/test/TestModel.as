package dittner.testmyself.core.model.test {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.note.INote;

public class TestModel extends SFProxy {

	//--------------------------------------
	//  testInfos
	//--------------------------------------
	private var _testInfos:Array = [];
	public function get testInfos():Array {return _testInfos;}

	//--------------------------------------
	//  testSpec
	//--------------------------------------
	private var _testSpec:TestSpec;
	public function get testSpec():TestSpec {return _testSpec;}
	public function set testSpec(value:TestSpec):void {
		if (_testSpec != value) {
			_testSpec = value;
		}
	}

	public function addTestInfo(info:TestInfo):void {
		testInfos.push(info);
	}

	public function calcBalanceIndex(balance:int, amount:int):int {
		return balance * 100000 + amount * 10 + Math.round(Math.random() * 9);
	}

	public function calcAmountIndex(balance:int, amount:int):int {
		return amount * 100000 + balance * 10 + Math.round(Math.random() * 9);
	}

	public function validate(note:INote, testInfo:TestInfo):Boolean {
		return true;
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}