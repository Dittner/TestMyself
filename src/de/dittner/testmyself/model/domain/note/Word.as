package de.dittner.testmyself.model.domain.note {
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

public class Word extends Note {
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
		res.searchText = toSearchText(article, title, declension, description);
		return res;
	}

	public static function toSearchText(article:String, title:String, declension:String, description:String):String {
		var res:String = "";
		if (declension)
			res = "+" + title + "+" + declension + "+" + description + "+";
		else
			res = "+" + title + "+" + description + "+";

		if (article)
			res = "+" + article + res;
		return res.toLocaleLowerCase();
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
			var verbVocabulary:Vocabulary;
			if (vocabulary.lang.id == LanguageID.DE)
				verbVocabulary = vocabulary.lang.vocabularyHash.read(VocabularyID.DE_VERB);
			else if (vocabulary.lang.id == LanguageID.EN)
				verbVocabulary = vocabulary.lang.vocabularyHash.read(VocabularyID.EN_VERB);
			return verbVocabulary.noteTitleHash.has(title);
		}
	}
}
}
