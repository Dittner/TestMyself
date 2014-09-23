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
	//  balance
	//--------------------------------------
	private var _balance:int = -1;
	public function get balance():int {return _balance;}
	public function set balance(value:int):void {_balance = value;}

	//--------------------------------------
	//  balanceIndex
	//--------------------------------------
	private var _balanceIndex:int = -1;
	public function get balanceIndex():int {return _balanceIndex;}
	public function set balanceIndex(value:int):void {_balanceIndex = value;}

	//--------------------------------------
	//  amount
	//--------------------------------------
	private var _amount:int = -1;
	public function get amount():int {return _amount;}
	public function set amount(value:int):void {_amount = value;}

	//--------------------------------------
	//  amountIndex
	//--------------------------------------
	private var _amountIndex:int = -1;
	public function get amountIndex():int {return _amountIndex;}
	public function set amountIndex(value:int):void {_amountIndex = value;}
}
}
