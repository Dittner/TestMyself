package dittner.testmyself.core.model.test {
public class TestInfo {
	public function TestInfo(id:uint, title:String) {
		_id = id;
		_title = title;
	}

	private var _id:uint;
	public function get id():uint {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

}
}
