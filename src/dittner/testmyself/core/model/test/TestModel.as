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

	private static const MSEC_IN_5HOURS:Number = 5 * 60 * 60 * 1000;

	public function calcTaskRate():Number {
		return (new Date).time + Math.round(Math.random() * MSEC_IN_5HOURS);
	}

	public function validate(note:INote, testInfo:TestInfo):Boolean {
		return true;
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}