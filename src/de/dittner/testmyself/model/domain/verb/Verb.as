package de.dittner.testmyself.model.domain.verb {
import de.dittner.testmyself.model.domain.note.Note;

public class Verb extends Note implements IVerb {
	public function Verb():void {}

	//--------------------------------------
	//  present
	//--------------------------------------
	private var _present:String = "";
	public function get present():String {return _present;}
	public function set present(value:String):void {
		_present = value || "";
	}

	//--------------------------------------
	//  past
	//--------------------------------------
	private var _past:String = "";
	public function get past():String {return _past;}
	public function set past(value:String):void {
		_past = value || "";
	}

	//--------------------------------------
	//  perfect
	//--------------------------------------
	private var _perfect:String = "";
	public function get perfect():String {return _perfect;}
	public function set perfect(value:String):void {
		_perfect = value || "";
	}

	override public function toSQLData():Object {
		var res:Object = super.toSQLData();
		res.present = present || null;
		res.past = past || null;
		res.perfect = perfect || null;
		return res;
	}

}
}
