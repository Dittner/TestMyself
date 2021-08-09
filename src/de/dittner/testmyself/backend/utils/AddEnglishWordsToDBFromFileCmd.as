package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.async.utils.doLaterInSec;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.cmd.StoreNoteCmd;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.IrregularVerb;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.Word;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.view.form.search.WebSearchAPI;
import de.dittner.testmyself.ui.view.form.search.WebSearchResult;
import de.dittner.walter.Walter;

import flash.data.SQLResult;

public class AddEnglishWordsToDBFromFileCmd extends ProgressCommand {
	public function AddEnglishWordsToDBFromFileCmd(storage:Storage, lang:Language) {
		super();
		this.storage = storage;
		Walter.instance.injector.inject(this);

		wordVocabulary = lang.vocabularyHash.read(VocabularyID.EN_WORD) as Vocabulary;
		verbVocabulary = lang.vocabularyHash.read(VocabularyID.EN_VERB) as Vocabulary;
	}

	[Inject]
	public var appModel:AppModel;
	private var verbVocabulary:Vocabulary;
	private var wordVocabulary:Vocabulary;
	private var curVocabulary:Vocabulary;


	[Embed(source="/dictionary/englishRatedWords.txt", mimeType="application/octet-stream")]
	[Bindable]
	private var RatedWordsClass:Class;
	private var ratedWordsStr:String;

	[Embed(source="/dictionary/englishIrregularVerbs.txt", mimeType="application/octet-stream")]
	[Bindable]
	private var IrregularVerbsClass:Class;
	private var irregularVerbsStr:String;

	private var notesToStore:Array;
	private var noteTitleHash:Object = {};
	private var storage:Storage;

	override public function execute():void {
		if (verbVocabulary.tagColl.length == 0)
			createTags().addCompleteCallback(tagsCreated);
		else
			start();
	}

	private function createTags():IAsyncOperation {
		var tag:Tag;

		tag = verbVocabulary.createTag();
		tag.name = "A1: Beginner level";
		tag.store();

		tag = verbVocabulary.createTag();
		tag.name = "A2: Elementary level";
		tag.store();

		tag = verbVocabulary.createTag();
		tag.name = "B1: Intermediate level";
		tag.store();

		tag = verbVocabulary.createTag();
		tag.name = "B2: Upper-Intermediate level";
		tag.store();

		tag = verbVocabulary.createTag();
		tag.name = "C1: Advanced level";
		tag.store();

		tag = verbVocabulary.createTag();
		tag.name = "C2: Proficiency level";
		tag.store();

		//words

		tag = wordVocabulary.createTag();
		tag.name = "A1: Beginner level";
		tag.store();

		tag = wordVocabulary.createTag();
		tag.name = "A2: Elementary level";
		tag.store();

		tag = wordVocabulary.createTag();
		tag.name = "B1: Intermediate level";
		tag.store();

		tag = wordVocabulary.createTag();
		tag.name = "B2: Upper-Intermediate level";
		tag.store();

		tag = wordVocabulary.createTag();
		tag.name = "C1: Advanced level";
		tag.store();

		tag = wordVocabulary.createTag();
		tag.name = "C2: Proficiency level";
		return tag.store();
	}

	private function tagsCreated(op:IAsyncOperation):void {
		start();
	}

	private function start():void {
		//addIrregularVerbs(verbVocabulary);
		addWords(wordVocabulary);
	}

	private function addIrregularVerbs(voc:Vocabulary):void {
		curVocabulary = voc;
		irregularVerbsStr = new IrregularVerbsClass();
		irregularVerbsStr = irregularVerbsStr.replace(/( {2,})/gi, " ");
		var verbs:Array = irregularVerbsStr.split("\n");
		notesToStore = [];

		for each(var item:String in verbs) {
			var verbForms:Array = item.split(", ");
			if (verbForms.length == 3) {
				var v:IrregularVerb = verbVocabulary.createNote() as IrregularVerb;
				v.title = verbForms[0];
				v.description = "NULL";
				v.past = verbForms[1];
				v.perfect = verbForms[2];

				notesToStore.push(v);
			}
			else {
				trace("Не достаточно значений!");
			}
		}

		total = notesToStore.length;
		storeNextNote();
	}

	private function addWords(voc:Vocabulary):void {
		curVocabulary = voc;
		ratedWordsStr = new RatedWordsClass();
		var translationHash:Object = {};
		var ratedWords:Array = ratedWordsStr.split("\n");

		notesToStore = [];

		for each(var item:String in ratedWords) {
			var parts:Array = item.split(" ");
			if (parts.length == 3) {
				var w:Word = wordVocabulary.createNote() as Word;
				w.title = parts[1];
				w.description = translationHash[w.title] ? translationHash[w.title] : "NULL";
				notesToStore.push(w);
			}
			else {
				trace("Не достаточно значений!");
			}
		}

		notesToStore.reverse();
		total = notesToStore.length;
		storeNextNote();
	}

	public var total:Number = 0;
	public var curNote:Note;
	private function storeNextNote(result:SQLResult = null):void {
		if (notesToStore.length > 0) {
			curNote = notesToStore.pop();
			setProgress(1 - notesToStore.length / total);
			if (noteTitleHash[curNote.title] || curNote.validate()) {
				trace("Note is invalid! – " + curNote.title + ", invalid: " + curNote.validate() || "duplicated");
				storeNextNote();
			}
			else {
				noteTitleHash[curNote.title] = true;
				WebSearchAPI.search(curNote.title, appModel.enLang).addCompleteCallback(webSearchResultReceived);
			}
		}
		else {
			dispatchSuccess();
		}
	}

	private function webSearchResultReceived(op:IAsyncOperation):void {
		if (op.isSuccess) {
			var result:WebSearchResult = op.result;

			if (result.audioComment)
				curNote.audioComment = result.audioComment;

			if (result.description)
				curNote.description = result.description;

			if (result.tagName && curNote.vocabulary.tagNameHash[result.tagName])
				curNote.tagIDs = [(curNote.vocabulary.tagNameHash[result.tagName] as Tag).id];

			if (result.examples && result.examples.length > 0) {
				for each(var example:Object in result.examples) {
					var note:Note = curVocabulary.createNote();
					note.isExample = true;
					note.title = example.en;
					note.description = example.ru;
					curNote.exampleColl.addItem(note);
				}
			}

			storeNote(curNote);
		}
		else {
			dispatchError(op.error);
		}
	}

	private function storeNote(note:Note):void {
		var cmd:StoreNoteCmd = new StoreNoteCmd(storage, note);
		cmd.addCompleteCallback(completeHandler);
		cmd.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			doLaterInSec(storeNextNote, 1);
			if (notesToStore.length % 100 == 0)
				CLog.info(LogTag.LOAD, "Processing " + notesToStore.length + " notes");
		}
		else {
			CLog.info(LogTag.LOAD, "Error by adding word " + curNote.title + ": " + op.error);
			dispatchError();
		}
	}

}
}