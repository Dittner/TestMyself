package de.dittner.testmyself.model.domain.theme {
public class Theme implements ITheme {
	public function Theme() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  isNew
	//--------------------------------------
	public function get isNew():Boolean {return _id == -1;}

	//--------------------------------------
	//  name
	//--------------------------------------
	private var _name:String = "";
	public function get name():String {return _name;}
	public function set name(value:String):void {_name = value;}

	//--------------------------------------
	//  vocabularyID
	//--------------------------------------
	private var _vocabularyID:int = -1;
	public function get vocabularyID():int {return _vocabularyID;}
	public function set vocabularyID(value:int):void {_vocabularyID = value;}

	public function serialize():Object {
		var res:Object = {};
		res.id = id;
		res.vocabularyID = vocabularyID;
		res.name = name;
		return res;
	}

	public function deserialize(obj:Object):void {
		_id = obj.id;
		_vocabularyID = obj.vocabularyID;
		_name = obj.name;
	}

}
}
