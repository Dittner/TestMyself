package dittner.testmyself.core.model.test {
public class TestInfo {
	public function TestInfo(id:uint, moduleName:String, title:String, loadExamplesWhenTesting:Boolean = false, useNoteExample:Boolean = false) {
		_id = id;
		_title = title;
		_loadExamplesWhenTesting = loadExamplesWhenTesting;
		_moduleName = moduleName;
		_useNoteExample = useNoteExample;
	}

	private var _id:uint;
	public function get id():uint {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

	private var _loadExamplesWhenTesting:Boolean;
	public function get loadExamplesWhenTesting():Boolean {return _loadExamplesWhenTesting;}

	private var _moduleName:String;
	public function get moduleName():String {return _moduleName;}

	private var _useNoteExample:Boolean;
	public function get useNoteExample():Boolean {return _useNoteExample;}

}
}
