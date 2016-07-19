package de.dittner.testmyself.model.domain.language {
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.verb.DeVerb;
import de.dittner.testmyself.model.domain.note.word.DeWord;
import de.dittner.testmyself.model.domain.test.SelectArticleTest;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

import flash.events.Event;

public class GermanLang extends Language {
	public function GermanLang() {
		super();
		initVocabularies();
	}

	//--------------------------------------
	//  selectedVocabulary
	//--------------------------------------
	private var _selectedVocabulary:Vocabulary;
	[Bindable("selectedVocabularyChanged")]
	public function get selectedVocabulary():Vocabulary {return _selectedVocabulary;}
	public function set selectedVocabulary(value:Vocabulary):void {
		if (_selectedVocabulary != value) {
			_selectedVocabulary = value;
			dispatchEvent(new Event("selectedVocabularyChanged"));
		}
	}

	//--------------------------------------
	//  wordVocabulary
	//--------------------------------------
	private var _wordVocabulary:Vocabulary;
	public function get wordVocabulary():Vocabulary {return _wordVocabulary;}

	//--------------------------------------
	//  verbVocabulary
	//--------------------------------------
	private var _verbVocabulary:Vocabulary;
	public function get verbVocabulary():Vocabulary {return _verbVocabulary;}

	//--------------------------------------
	//  lessonVocabulary
	//--------------------------------------
	private var _lessonVocabulary:Vocabulary;
	public function get lessonVocabulary():Vocabulary {return _lessonVocabulary;}

	private var _vocabularies:Array;
	public function get vocabularies():Array {return _vocabularies;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function initVocabularies():void {
		_wordVocabulary = new Vocabulary(VocabularyID.DE_WORD, DeWord);
		wordVocabulary.addTest(new Test(TestID.SPEAK_WORD_TRANSLATION, wordVocabulary, "Aus dem Deutschen übersetzen", true, false, false));
		wordVocabulary.addTest(new Test(TestID.SPEAK_WORD_IN_DEUTSCH, wordVocabulary, "Ins Deutsche übersetzen", true, false, false));
		wordVocabulary.addTest(new Test(TestID.WRITE_WORD, wordVocabulary, "Rechtschreibung", false, true, false));
		wordVocabulary.addTest(new SelectArticleTest(wordVocabulary, "Artikel auswählen", false));
		wordVocabulary.addTest(new Test(TestID.SPEAK_WORD_EXAMPLE_TRANSLATION, wordVocabulary, "Aus dem Deutschen die Beispiele übersetzen", false, false, true));
		wordVocabulary.addTest(new Test(TestID.SPEAK_WORD_EXAMPLE_IN_DEUTSCH, wordVocabulary, "Ins Deutsche die Beispiele übersetzen", false, false, true));
		wordVocabulary.addTest(new Test(TestID.WRITE_WORD_EXAMPLE, wordVocabulary, "Rechtschreibung der Beispiele", false, true, true));

		_verbVocabulary = new Vocabulary(VocabularyID.DE_VERB, DeVerb);
		verbVocabulary.addTest(new Test(TestID.SPEAK_VERB_FORMS, verbVocabulary, "Deklination der starken Verben", true, false, false));
		verbVocabulary.addTest(new Test(TestID.SPEAK_VERB_EXAMPLE_TRANSLATION, verbVocabulary, "Aus dem Deutschen die Beispiele übersetzen", false, false, true));
		verbVocabulary.addTest(new Test(TestID.SPEAK_VERB_EXAMPLE_IN_DEUTSCH, verbVocabulary, "Ins Deutsche die Beispiele übersetzen", false, false, true));
		verbVocabulary.addTest(new Test(TestID.WRITE_VERB_EXAMPLE, verbVocabulary, "Rechtschreibung der Beispiele", false, true, true));

		_lessonVocabulary = new Vocabulary(VocabularyID.DE_LESSON, Note);
		lessonVocabulary.addTest(new Test(TestID.SPEAK_LESSON_TRANSLATION, lessonVocabulary, "Aus dem Deutschen übersetzen", false, false, false));
		lessonVocabulary.addTest(new Test(TestID.SPEAK_LESSON_IN_DEUTSCH, lessonVocabulary, "Ins Deutsche übersetzen", false, false, false));
		lessonVocabulary.addTest(new Test(TestID.WRITE_LESSON, lessonVocabulary, "Rechtschreibung", false, true, false));

		_vocabularies = [wordVocabulary, verbVocabulary, lessonVocabulary];
	}

}
}
