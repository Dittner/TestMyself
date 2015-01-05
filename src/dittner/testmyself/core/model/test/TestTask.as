package dittner.testmyself.core.model.test {
public class TestTask implements ITestTask {

	//--------------------------------------
	//  testID
	//--------------------------------------
	private var _testID:int = -1;
	public function get testID():int {return _testID;}
	public function set testID(value:int):void {_testID = value;}

	//--------------------------------------
	//  noteID
	//--------------------------------------
	private var _noteID:int = -1;
	public function get noteID():int {return _noteID;}
	public function set noteID(value:int):void {_noteID = value;}

	//--------------------------------------
	//  correct
	//--------------------------------------
	private var _correct:int = 0;
	public function get correct():int {return _correct;}
	public function set correct(value:int):void {_correct = value;}

	//--------------------------------------
	//  incorrect
	//--------------------------------------
	private var _incorrect:int = 0;
	public function get incorrect():int {return _incorrect;}
	public function set incorrect(value:int):void {_incorrect = value;}

	//--------------------------------------
	//  rate
	//--------------------------------------
	private var _rate:int = -1;
	public function get rate():int {return _rate;}
	public function set rate(value:int):void {_rate = value;}

	//--------------------------------------
	//  complexity
	//--------------------------------------
	private var _complexity:int = TestTaskComplexity.HIGH;
	public function get complexity():int {return _complexity;}
	public function set complexity(value:int):void {_complexity = value;}
}
}
