package de.dittner.testmyself.model.domain.word {
import de.dittner.testmyself.model.domain.note.Note;

public class Word extends Note implements IWord {
	public function Word():void {}

	//--------------------------------------
	//  article
	//--------------------------------------
	private var _article:String = "";
	public function get article():String {return _article;}
	public function set article(value:String):void {
		_article = value || "";
	}

	//--------------------------------------
	//  options
	//--------------------------------------
	private var _options:String = "";
	public function get options():String {return _options;}
	public function set options(value:String):void {
		_options = value || "";
	}

	override public function toSQLData():Object {
		var res:Object = super.toSQLData();
		res.article = article || null;
		res.options = options || null;
		return res;
	}

}
}
