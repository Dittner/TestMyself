package dittner.testmyself.model.theme {

public class Theme implements ITheme {
	public function Theme() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  name
	//--------------------------------------
	private var _name:String = "";
	public function get name():String {return _name;}
	public function set name(value:String):void {_name = value;}

}
}
