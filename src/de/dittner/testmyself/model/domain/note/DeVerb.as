package de.dittner.testmyself.model.domain.note {
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteValidationErrorKey;

public class DeVerb extends Note {
	public function DeVerb():void {}

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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():Object {
		var res:Object = super.serialize();
		res.options.present = present || null;
		res.options.past = past || null;
		res.options.perfect = perfect || null;
		res.searchText = title + "+" + description + "+" + present + "+" + past + "+" + perfect;
		res.searchText = res.searchText.toLowerCase();
		return res;
	}

	override public function deserialize(data:Object):void {
		super.deserialize(data);
		present = data.options.present || "";
		past = data.options.past || "";
		perfect = data.options.perfect || "";
	}

	override public function validate():String {
		if (!present || !past || !perfect)
			return NoteValidationErrorKey.EMPTY_VERB_FIELDS;
		else
			return super.validate();
	}

	override public function hasDuplicate():Boolean {
		if (super.hasDuplicate()) {
			return true;
		}
		else {
			var wordVocabulary:Vocabulary = vocabulary.lang.vocabularyHash.read(VocabularyID.DE_WORD);
			return wordVocabulary.noteTitleHash.has(title);
		}
	}

}
}
