package de.dittner.testmyself.model.domain.language {
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.domain_internal;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.verb.DeVerb;
import de.dittner.testmyself.model.domain.note.word.DeWord;
import de.dittner.testmyself.model.domain.test.SelectArticleTest;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestID;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

use namespace domain_internal;

public class DeLang extends Language {
	public function DeLang(storage:SQLStorage) {
		super(LanguageID.DE, storage);
		initVocabularies();
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
		initWordVocabulary();
		initVerbVocabulary();
		initLessonVocabulary();

		_vocabularies = [wordVocabulary, verbVocabulary, lessonVocabulary];
	}

	private function initWordVocabulary():void {
		_wordVocabulary = new Vocabulary(VocabularyID.DE_WORD, id, DeWord, storage, "Wörter");
		var test:Test;
		test = new Test(TestID.SPEAK_WORD_TRANSLATION, wordVocabulary, "Aus dem Deutschen übersetzen");
		test._loadExamplesWhenTesting = true;
		test._isWritten = false;
		test._useExamples = false;
		test._needTranslationInvert = false;
		wordVocabulary.addTest(test);

		test = new Test(TestID.SPEAK_WORD_IN_DEUTSCH, wordVocabulary, "Ins Deutsche übersetzen");
		test._loadExamplesWhenTesting = true;
		test._isWritten = false;
		test._useExamples = false;
		test._needTranslationInvert = true;
		wordVocabulary.addTest(test);

		test = new Test(TestID.WRITE_WORD, wordVocabulary, "Rechtschreibung");
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = false;
		test._needTranslationInvert = false;
		wordVocabulary.addTest(test);

		test = new SelectArticleTest(wordVocabulary, "Artikel auswählen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = false;
		test._needTranslationInvert = false;
		wordVocabulary.addTest(test);

		test = new Test(TestID.SPEAK_WORD_EXAMPLE_TRANSLATION, wordVocabulary, "Aus dem Deutschen die Beispiele übersetzen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._needTranslationInvert = false;
		wordVocabulary.addTest(test);

		test = new Test(TestID.SPEAK_WORD_EXAMPLE_IN_DEUTSCH, wordVocabulary, "Ins Deutsche die Beispiele übersetzen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._needTranslationInvert = true;
		wordVocabulary.addTest(test);

		test = new Test(TestID.WRITE_WORD_EXAMPLE, wordVocabulary, "Rechtschreibung der Beispiele");
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = true;
		test._needTranslationInvert = false;
		wordVocabulary.addTest(test);
	}

	private function initVerbVocabulary():void {
		_verbVocabulary = new Vocabulary(VocabularyID.DE_VERB, id, DeVerb, storage, "Starke Verben");
		var test:Test;
		test = new Test(TestID.SPEAK_VERB_FORMS, verbVocabulary, "Deklination der starken Verben");
		test._loadExamplesWhenTesting = true;
		test._isWritten = false;
		test._useExamples = false;
		test._needTranslationInvert = false;
		verbVocabulary.addTest(test);

		test = new Test(TestID.SPEAK_VERB_EXAMPLE_TRANSLATION, verbVocabulary, "Aus dem Deutschen die Beispiele übersetzen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._needTranslationInvert = false;
		verbVocabulary.addTest(test);

		test = new Test(TestID.SPEAK_VERB_EXAMPLE_IN_DEUTSCH, verbVocabulary, "Ins Deutsche die Beispiele übersetzen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._needTranslationInvert = true;
		verbVocabulary.addTest(test);

		test = new Test(TestID.WRITE_VERB_EXAMPLE, verbVocabulary, "Rechtschreibung der Beispiele");
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = true;
		test._needTranslationInvert = false;
		verbVocabulary.addTest(test);
	}

	private function initLessonVocabulary():void {
		_lessonVocabulary = new Vocabulary(VocabularyID.DE_LESSON, id, Note, storage, "Übungen");
		var test:Test;
		test = new Test(TestID.SPEAK_LESSON_TRANSLATION, lessonVocabulary, "Aus dem Deutschen übersetzen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = false;
		test._needTranslationInvert = false;
		lessonVocabulary.addTest(test);

		test = new Test(TestID.SPEAK_LESSON_IN_DEUTSCH, lessonVocabulary, "Ins Deutsche übersetzen");
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = false;
		test._needTranslationInvert = true;
		lessonVocabulary.addTest(test);

		test = new Test(TestID.WRITE_LESSON, lessonVocabulary, "Rechtschreibung");
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = false;
		test._needTranslationInvert = false;
		lessonVocabulary.addTest(test);
	}

}
}
