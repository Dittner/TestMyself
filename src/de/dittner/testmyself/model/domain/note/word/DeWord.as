package de.dittner.testmyself.model.domain.note.word {
import de.dittner.testmyself.model.domain.note.Note;

public class DeWord extends Note {
	public function DeWord():void {}

	//--------------------------------------
	//  article
	//--------------------------------------
	private var _article:String = "";
	public function get article():String {return _article;}
	public function set article(value:String):void {
		_article = value || "";
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():Object {
		var res:Object = super.serialize();
		res.options.article = article || null;
		return res;
	}

	override public function deserialize(data:Object):void {
		super.deserialize(data);
		article = data.options.article || "";
	}

}
}
