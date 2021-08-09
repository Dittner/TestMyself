package de.dittner.testmyself.model.domain.language {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.domain_internal;
import de.dittner.testmyself.model.domain.note.IrregularVerb;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.Word;
import de.dittner.testmyself.model.domain.test.SelectArticleTest;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestID;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

import mx.resources.ResourceManager;

use namespace domain_internal;

public class DeLang extends Language {
	public function DeLang(storage:Storage) {
		super(LanguageID.DE, storage);
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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var isInitialized:Boolean = false;
	override public function init():IAsyncOperation {
		if (!isInitialized) {
			isInitialized = true;
			initWordVocabulary();
			initVerbVocabulary();
			initLessonVocabulary();

			addVocabulary(wordVocabulary);
			addVocabulary(verbVocabulary);
			addVocabulary(lessonVocabulary);
		}
		return super.init();
	}

	private function initWordVocabulary():void {
		_wordVocabulary = new Vocabulary(VocabularyID.DE_WORD, this, Word, storage, getLocaleString('Words'));
		var test:Test;
		test = new Test(TestID.DE_TRANSLATE_WORD_FROM_GERMAN, wordVocabulary, getLocaleString('TranslateFromGerman'));
		test._loadExamplesWhenTesting = true;
		test._isWritten = false;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		wordVocabulary.addTest(test);

		test = new Test(TestID.DE_TRANSLATE_WORD_INTO_GERMAN, wordVocabulary, getLocaleString('TranslateIntoGerman'));
		test._loadExamplesWhenTesting = true;
		test._isWritten = false;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = true;
		wordVocabulary.addTest(test);

		test = new Test(TestID.DE_WRITE_WORD, wordVocabulary, getLocaleString('Spelling'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		wordVocabulary.addTest(test);

		test = new SelectArticleTest(wordVocabulary, getLocaleString('ChooseArticle'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		wordVocabulary.addTest(test);

		test = new Test(TestID.DE_TRANSLATE_WORD_EXAMPLE_FROM_GERMAN, wordVocabulary, getLocaleString('TranslateExamplesFromGerman'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._translateFromNativeIntoForeign = false;
		wordVocabulary.addTest(test);

		test = new Test(TestID.DE_TRANSLATE_WORD_EXAMPLE_INTO_GERMAN, wordVocabulary, getLocaleString('TranslateExamplesIntoGerman'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._translateFromNativeIntoForeign = true;
		wordVocabulary.addTest(test);
	}

	private function initVerbVocabulary():void {
		_verbVocabulary = new Vocabulary(VocabularyID.DE_VERB, this, IrregularVerb, storage, getLocaleString('IrregularVerbs'));
		var test:Test;
		test = new Test(TestID.DE_DECLENSION_VERB_FORMS, verbVocabulary, getLocaleString('DeclensionOfVerbs'));
		test._loadExamplesWhenTesting = true;
		test._isWritten = false;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		verbVocabulary.addTest(test);

		test = new Test(TestID.DE_WRITE_VERB, verbVocabulary, getLocaleString('Spelling'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		verbVocabulary.addTest(test);

		test = new Test(TestID.DE_TRANSLATE_VERB_EXAMPLE_FROM_GERMAN, verbVocabulary, getLocaleString('TranslateExamplesFromGerman'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._translateFromNativeIntoForeign = false;
		verbVocabulary.addTest(test);

		test = new Test(TestID.DE_TRANSLATE_VERB_EXAMPLE_INTO_GERMAN, verbVocabulary, getLocaleString('TranslateExamplesIntoGerman'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = true;
		test._translateFromNativeIntoForeign = true;
		verbVocabulary.addTest(test);
	}

	private function initLessonVocabulary():void {
		_lessonVocabulary = new Vocabulary(VocabularyID.DE_LESSON, this, Note, storage, getLocaleString('Lessons'));
		var test:Test;
		test = new Test(TestID.DE_TRANSLATE_LESSON_FROM_GERMAN, lessonVocabulary, getLocaleString('TranslateFromGerman'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		lessonVocabulary.addTest(test);

		test = new Test(TestID.DE_TRANSLATE_LESSON_INTO_GERMAN, lessonVocabulary, getLocaleString('TranslateIntoGerman'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = false;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = true;
		lessonVocabulary.addTest(test);

		test = new Test(TestID.DE_WRITE_LESSON, lessonVocabulary, getLocaleString('Spelling'));
		test._loadExamplesWhenTesting = false;
		test._isWritten = true;
		test._useExamples = false;
		test._translateFromNativeIntoForeign = false;
		lessonVocabulary.addTest(test);
	}

	private function getLocaleString(key:String):String {
		return ResourceManager.getInstance().getString('app', key, null, 'de_DE');
	}

}
}
