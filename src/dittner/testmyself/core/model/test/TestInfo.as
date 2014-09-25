package dittner.testmyself.core.model.test {
public class TestInfo {
	public function TestInfo(id:uint, moduleName:String, title:String) {
		_id = id;
		_title = title;
		_moduleName = moduleName;
	}

	private var _id:uint;
	public function get id():uint {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

	private var _moduleName:String;
	public function get moduleName():String {return _moduleName;}

}
}
