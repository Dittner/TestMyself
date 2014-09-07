package dittner.testmyself.core.service {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.demo.IDemoData;
import dittner.testmyself.core.model.note.Note;

public class NoteServiceSpec extends SFProxy {

	//--------------------------------------
	//  dbName
	//--------------------------------------
	private var _dbName:String = "dataBase";
	public function get dbName():String {return _dbName;}
	public function set dbName(value:String):void {
		_dbName = value;
	}

	//--------------------------------------
	//  noteClass
	//--------------------------------------
	private var _noteClass:Class = Note;
	public function get noteClass():Class {return _noteClass;}
	public function set noteClass(value:Class):void {
		_noteClass = value;
	}

	//--------------------------------------
	//  demoData
	//--------------------------------------
	private var _demoData:IDemoData;
	public function get demoData():IDemoData {return _demoData;}
	public function set demoData(value:IDemoData):void {
		_demoData = value;
	}
}
}
