package de.dittner.testmyself.model.domain.test {
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
	//  rate
	//--------------------------------------
	private var _rate:Number = -1;
	public function get rate():Number {return _rate;}
	public function set rate(value:Number):void {_rate = value;}

	//--------------------------------------
	//  complexity
	//--------------------------------------
	private var _complexity:int = TestTaskComplexity.HIGH;
	public function get complexity():int {return _complexity;}
	public function set complexity(value:int):void {_complexity = value;}

	//--------------------------------------
	//  isFailed
	//--------------------------------------
	private var _isFailed:Boolean;
	public function get isFailed():Boolean {return _isFailed;}
	public function set isFailed(value:Boolean):void {_isFailed = value;}

	//--------------------------------------
	//  lastTestedDate
	//--------------------------------------
	private var _lastTestedDate:Number;
	public function get lastTestedDate():Number {return _lastTestedDate;}
	public function set lastTestedDate(value:Number):void {_lastTestedDate = value;}

}
}
