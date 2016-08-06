package de.dittner.testmyself.model.domain.note {
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

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

	//--------------------------------------
	//  declension
	//--------------------------------------
	private var _declension:String;
	public function get declension():String {return _declension;}
	public function set declension(value:String):void {
		_declension = value || "";
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():Object {
		var res:Object = super.serialize();
		res.options.article = article || null;
		res.options.declension = declension || null;
		return res;
	}

	override public function deserialize(data:Object):void {
		super.deserialize(data);
		article = data.options.article || "";
		declension = data.options.declension || "";
	}

	override public function hasDuplicate():Boolean {
		if (super.hasDuplicate()) {
			return true;
		}
		else {
			var verbVocabulary:Vocabulary = vocabulary.lang.vocabularyHash.read(VocabularyID.DE_VERB);
			return verbVocabulary.noteTitleHash.has(title);
		}
	}
}
}
